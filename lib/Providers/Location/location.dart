import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:public_health/Services/Location/locationstream.dart';

class LocationProvider extends ChangeNotifier {
  Position? position;
  String? locationError;

  StreamSubscription<Position>? _subscription;

  Future<void> startStreaming() async {
    if (_subscription != null) return;

    // Check whether location services are enabled.
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      locationError = 'LOCATION_SERVICES_DISABLED';
      notifyListeners();
      return;
    }

    // Check location permission.
    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      locationError = 'LOCATION_PERMISSION_DENIED';
      notifyListeners();
      return;
    }

    locationError = null;

    _subscription = Location().stream().listen(
      (newPosition) {
        position = newPosition;
        locationError = null;
        notifyListeners();
      },
      onError: (Object error, StackTrace stackTrace) {
        debugPrint('Location stream error: $error');

        locationError = 'LOCATION_STREAM_ERROR';
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    super.dispose();
  }
}
