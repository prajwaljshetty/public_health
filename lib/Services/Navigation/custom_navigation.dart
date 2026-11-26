import 'dart:math';

import 'package:flutter/foundation.dart';

// Service :
import 'package:public_health/Services/Navigation/directions.dart';

// Language :

const double _earthRadius = 6371008.8;

double _rad(double d) => d * pi / 180;
double _deg(double r) => r * 180 / pi;

double haversine(double lat1, double lon1, double lat2, double lon2) {
  final dLat = _rad(lat2 - lat1);
  final dLon = _rad(lon2 - lon1);

  final s1 = sin(dLat / 2);
  final s2 = sin(dLon / 2);

  final a = s1 * s1 + cos(_rad(lat1)) * cos(_rad(lat2)) * s2 * s2;

  return 2 * _earthRadius * asin(min(1.0, sqrt(a)));
}

double bearingBetween(double lat1, double lon1, double lat2, double lon2) {
  final p1 = _rad(lat1);
  final p2 = _rad(lat2);
  final dLon = _rad(lon2 - lon1);

  final y = sin(dLon) * cos(p2);
  final x = cos(p1) * sin(p2) - sin(p1) * cos(p2) * cos(dLon);

  return (_deg(atan2(y, x)) + 360) % 360;
}

typedef NavStep = DirectionsStep;

class NavRoute {
  NavRoute({
    required this.coordinates,
    required this.steps,
    required this.distance,
    required this.duration,
  }) : cumulative = _buildCumulative(coordinates);

  final List<List<double>> coordinates;

  final List<NavStep> steps;
  final double distance;
  final double duration;

  final List<double> cumulative;

  static List<double> _buildCumulative(List<List<double>> coordinates) {
    final result = <double>[0];

    for (var i = 1; i < coordinates.length; i++) {
      result.add(
        result.last +
            haversine(
              coordinates[i - 1][1],
              coordinates[i - 1][0],
              coordinates[i][1],
              coordinates[i][0],
            ),
      );
    }

    return result;
  }
}

enum NavStatus { idle, loading, navigating, rerouting, arrived }

class _Snap {
  const _Snap({
    required this.languageCode,
    required this.segment,
    required this.along,
    required this.distance,
    required this.latitude,
    required this.longitude,
  });

  final String languageCode;
  final int segment;
  final double along;
  final double distance;
  final double latitude;
  final double longitude;
}

class CustomNavigationController extends ChangeNotifier {
  CustomNavigationController({
    required this.languageCode,
    required this.directionsService,
    required this.destinationLatitude,
    required this.destinationLongitude,
    this.onSpeak,
    this.offRouteThreshold = 40,
    this.arrivalThreshold = 25,
  });

  final DirectionsService directionsService;

  final double destinationLatitude;
  final double destinationLongitude;

  final double offRouteThreshold;
  final double arrivalThreshold;

  final String languageCode;

  final void Function(String text)? onSpeak;

  NavRoute? _route;
  NavStatus _status = NavStatus.idle;

  int _segIndex = 0;
  int _stepIndex = 0;
  int _offRouteCount = 0;

  bool _rerouting = false;
  bool _disposed = false;

  DateTime _lastReroute = DateTime.fromMillisecondsSinceEpoch(0);

  final Set<String> _spoken = {};

  double snappedLatitude = 0;
  double snappedLongitude = 0;

  double bearing = 0;

  double distanceToManeuver = 0;
  double remainingDistance = 0;
  double remainingDuration = 0;

  int routeRevision = 0;

  NavStatus get status => _status;

  NavRoute? get route => _route;

  NavStep? get currentStep {
    final route = _route;

    if (route == null || route.steps.isEmpty) {
      return null;
    }

    return route.steps[_stepIndex.clamp(0, route.steps.length - 1).toInt()];
  }

  NavStep? get nextStep {
    final route = _route;

    if (route == null || _stepIndex + 1 >= route.steps.length) {
      return null;
    }

    return route.steps[_stepIndex + 1];
  }

  List<List<double>> get remainingCoordinates {
    final route = _route;

    if (route == null) {
      return const [];
    }

    final from = (_segIndex + 1).clamp(0, route.coordinates.length).toInt();

    return [
      [snappedLongitude, snappedLatitude],
      ...route.coordinates.sublist(from),
    ];
  }

  Future<void> start(double latitude, double longitude) async {
    _status = NavStatus.loading;
    _route = null;

    _segIndex = 0;
    _stepIndex = 0;
    _offRouteCount = 0;
    _rerouting = false;

    _spoken.clear();

    _notify();

    try {
      final directionsRoute = await directionsService.getRoute(
        languageCode: languageCode,
        originLatitude: latitude,
        originLongitude: longitude,
        destinationLatitude: destinationLatitude,
        destinationLongitude: destinationLongitude,
      );

      final route = NavRoute(
        coordinates: directionsRoute.coordinates,
        steps: directionsRoute.steps,
        distance: directionsRoute.distance,
        duration: directionsRoute.duration,
      );

      _applyRoute(route);

      _status = NavStatus.navigating;

      if (route.steps.isNotEmpty && route.steps.first.instruction.isNotEmpty) {
        onSpeak?.call(route.steps.first.instruction);
      }

      _notify();
    } catch (_) {
      _status = NavStatus.idle;
      _notify();
      rethrow;
    }
  }

  void stop() {
    _status = NavStatus.idle;
    _route = null;

    _segIndex = 0;
    _stepIndex = 0;
    _offRouteCount = 0;
    _rerouting = false;

    _spoken.clear();

    _notify();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _notify() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  void onLocation(double latitude, double longitude, {double accuracy = 0}) {
    final route = _route;

    if (route == null || _status != NavStatus.navigating) {
      return;
    }

    if (accuracy > 60) {
      return;
    }

    var snap = _snap(route, latitude, longitude, windowed: true);

    if (snap.distance > offRouteThreshold) {
      snap = _snap(route, latitude, longitude, windowed: false);
    }

    if (snap.distance > offRouteThreshold) {
      _offRouteCount++;

      if (_offRouteCount >= 3) {
        _reroute(latitude, longitude);
      }

      return;
    }

    _offRouteCount = 0;

    _segIndex = snap.segment;

    snappedLatitude = snap.latitude;
    snappedLongitude = snap.longitude;

    final a = route.coordinates[_segIndex];
    final b = route.coordinates[_segIndex + 1];

    bearing = bearingBetween(a[1], a[0], b[1], b[0]);

    final total = route.cumulative.last;

    final progress = route.cumulative[_segIndex] + snap.along;

    final scale = total > 0 ? route.distance / total : 1.0;

    final travelled = progress * scale;

    while (_stepIndex + 1 < route.steps.length - 1 &&
        route.steps[_stepIndex + 1].startDistance <= travelled) {
      _stepIndex++;
    }

    remainingDistance = max(0.0, route.distance - travelled).toDouble();

    if (route.steps.length >= 2) {
      final current = route.steps[_stepIndex];
      final next = route.steps[_stepIndex + 1];

      distanceToManeuver = max(0.0, next.startDistance - travelled).toDouble();

      final fraction = current.distance > 0
          ? ((travelled - current.startDistance) / current.distance)
                .clamp(0.0, 1.0)
                .toDouble()
          : 1.0;

      var duration = current.duration * (1 - fraction);

      for (var i = _stepIndex + 1; i < route.steps.length; i++) {
        duration += route.steps[i].duration;
      }

      remainingDuration = duration;

      _maybeSpeak(next);
    } else {
      distanceToManeuver = remainingDistance;

      remainingDuration =
          route.duration * (remainingDistance / max(1.0, route.distance));
    }

    if (remainingDistance <= arrivalThreshold) {
      _status = NavStatus.arrived;

      onSpeak?.call('You have arrived at your destination');
    }

    _notify();
  }

  void _applyRoute(NavRoute route) {
    if (route.coordinates.length < 2) {
      throw Exception('The returned route has no usable geometry.');
    }

    _route = route;

    _segIndex = 0;
    _stepIndex = 0;
    _offRouteCount = 0;

    _spoken.clear();

    final coordinates = route.coordinates;

    snappedLongitude = coordinates.first[0];
    snappedLatitude = coordinates.first[1];

    bearing = bearingBetween(
      coordinates[0][1],
      coordinates[0][0],
      coordinates[1][1],
      coordinates[1][0],
    );

    remainingDistance = route.distance;
    remainingDuration = route.duration;

    distanceToManeuver = route.steps.length > 1
        ? route.steps[1].startDistance
        : route.distance;

    routeRevision++;
  }

  Future<void> _reroute(double latitude, double longitude) async {
    if (_rerouting) return;

    if (DateTime.now().difference(_lastReroute).inSeconds < 8) {
      return;
    }

    _rerouting = true;
    _status = NavStatus.rerouting;

    _notify();

    try {
      final directionsRoute = await directionsService.getRoute(
        languageCode: languageCode,
        originLatitude: latitude,
        originLongitude: longitude,
        destinationLatitude: destinationLatitude,
        destinationLongitude: destinationLongitude,
      );

      final route = NavRoute(
        coordinates: directionsRoute.coordinates,
        steps: directionsRoute.steps,
        distance: directionsRoute.distance,
        duration: directionsRoute.duration,
      );

      _applyRoute(route);

      onSpeak?.call('Rerouting');
    } catch (_) {
      // Keep the previous route.
      // Another attempt can happen after the cooldown.
    } finally {
      _rerouting = false;
      _offRouteCount = 0;
      _lastReroute = DateTime.now();

      _status = NavStatus.navigating;

      _notify();
    }
  }

  void _maybeSpeak(NavStep next) {
    if (onSpeak == null || next.instruction.isEmpty) {
      return;
    }

    if (distanceToManeuver < 400 && _spoken.add('$_stepIndex:far')) {
      final distance = distanceToManeuver >= 1000
          ? '${(distanceToManeuver / 1000).toStringAsFixed(1)} kilometres'
          : '${(distanceToManeuver / 50).round() * 50} metres';

      onSpeak!.call('In $distance, ${next.instruction}');
    }

    if (distanceToManeuver < 60 && _spoken.add('$_stepIndex:near')) {
      onSpeak!.call(next.instruction);
    }
  }

  _Snap _snap(
    NavRoute route,
    double latitude,
    double longitude, {
    required bool windowed,
  }) {
    final coordinates = route.coordinates;
    final lastSegment = coordinates.length - 2;

    final start = (windowed ? max(0, _segIndex - 2) : 0).toInt();

    final end = (windowed ? min(lastSegment, _segIndex + 80) : lastSegment)
        .toInt();

    const metresPerDegree = 111320.0;

    final longitudeScale = metresPerDegree * cos(_rad(latitude));

    var bestDistance = double.infinity;
    var bestSegment = start;
    var bestT = 0.0;

    for (var i = start; i <= end; i++) {
      final a = coordinates[i];
      final b = coordinates[i + 1];

      final ax = (a[0] - longitude) * longitudeScale;
      final ay = (a[1] - latitude) * metresPerDegree;

      final bx = (b[0] - longitude) * longitudeScale;
      final by = (b[1] - latitude) * metresPerDegree;

      final dx = bx - ax;
      final dy = by - ay;

      final lengthSquared = dx * dx + dy * dy;

      final t = lengthSquared == 0
          ? 0.0
          : (-(ax * dx + ay * dy) / lengthSquared).clamp(0.0, 1.0).toDouble();

      final px = ax + t * dx;
      final py = ay + t * dy;

      final distance = sqrt(px * px + py * py);

      if (distance < bestDistance) {
        bestDistance = distance;
        bestSegment = i;
        bestT = t;
      }
    }

    final a = coordinates[bestSegment];
    final b = coordinates[bestSegment + 1];

    final segmentLength =
        route.cumulative[bestSegment + 1] - route.cumulative[bestSegment];

    return _Snap(
      languageCode: languageCode,
      segment: bestSegment,
      along: bestT * segmentLength,
      distance: bestDistance,
      latitude: a[1] + (b[1] - a[1]) * bestT,
      longitude: a[0] + (b[0] - a[0]) * bestT,
    );
  }
}
