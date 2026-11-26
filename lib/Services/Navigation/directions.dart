import 'dart:convert';

// HTTP :
import 'package:http/http.dart' as http;
import 'package:public_health/Config/mapbox_config.dart';

// Language

class DirectionsService {
  static const String _baseUrl = 'https://api.mapbox.com/directions/v5/mapbox';

  Future<DirectionsRoute> getRoute({
    required String languageCode,
    required double originLatitude,
    required double originLongitude,
    required double destinationLatitude,
    required double destinationLongitude,
  }) async {
    final coordinates =
        '$originLongitude,$originLatitude;$destinationLongitude,$destinationLatitude';

    final uri = Uri.parse('$_baseUrl/driving-traffic/$coordinates').replace(
      queryParameters: {
        'access_token': MapboxConfig.accessToken,
        'steps': 'true',
        'geometries': 'geojson',
        'overview': 'full',
        'language': languageCode,
        'alternatives': 'false',
        'roundabout_exits': 'true',
      },
    );

    final response = await http.get(uri).timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        'Directions API failed: ${response.statusCode} ${response.body}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (data['code'] != 'Ok') {
      throw Exception(
        'Directions API returned ${data['code']}: '
        '${data['message'] ?? 'Unknown error'}',
      );
    }

    final routes = data['routes'] as List?;

    if (routes == null || routes.isEmpty) {
      throw Exception('No route available.');
    }

    final route = routes.first as Map<String, dynamic>;

    final rawCoordinates = route['geometry']['coordinates'] as List;

    final points = rawCoordinates.map<List<double>>((coordinate) {
      return [
        (coordinate[0] as num).toDouble(),
        (coordinate[1] as num).toDouble(),
      ];
    }).toList();

    if (points.length < 2) {
      throw Exception('The returned route has no usable geometry.');
    }

    final instructions = <String>[];
    final steps = <DirectionsStep>[];

    var startDistance = 0.0;

    for (final rawLeg in route['legs'] as List) {
      final leg = rawLeg as Map<String, dynamic>;

      for (final rawStep in leg['steps'] as List) {
        final step = rawStep as Map<String, dynamic>;
        final maneuver = step['maneuver'] as Map<String, dynamic>;
        final location = maneuver['location'] as List;

        final instruction = (maneuver['instruction'] as String?) ?? '';

        final distance = (step['distance'] as num).toDouble();

        if (instruction.isNotEmpty) {
          instructions.add(instruction);
        }

        steps.add(
          DirectionsStep(
            instruction: instruction,
            type: (maneuver['type'] as String?) ?? 'turn',
            modifier: maneuver['modifier'] as String?,
            roadName: (step['name'] as String?) ?? '',
            distance: distance,
            duration: (step['duration'] as num).toDouble(),
            startDistance: startDistance,
            longitude: (location[0] as num).toDouble(),
            latitude: (location[1] as num).toDouble(),
          ),
        );

        startDistance += distance;
      }
    }

    return DirectionsRoute(
      coordinates: points,
      distance: (route['distance'] as num).toDouble(),
      duration: (route['duration'] as num).toDouble(),
      instructions: instructions,
      steps: steps,
    );
  }
}

class DirectionsStep {
  const DirectionsStep({
    required this.instruction,
    required this.type,
    required this.modifier,
    required this.roadName,
    required this.distance,
    required this.duration,
    required this.startDistance,
    required this.longitude,
    required this.latitude,
  });

  final String instruction;
  final String type;
  final String? modifier;
  final String roadName;
  final double distance;
  final double duration;
  final double startDistance;
  final double longitude;
  final double latitude;
}

class DirectionsRoute {
  const DirectionsRoute({
    required this.coordinates,
    required this.distance,
    required this.duration,
    required this.instructions,
    required this.steps,
  });

  final List<List<double>> coordinates;
  final double distance;
  final double duration;
  final List<String> instructions;
  final List<DirectionsStep> steps;
}
