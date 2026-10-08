// Locations :
import 'dart:async';

import 'package:flutter/foundation.dart';

// Location Streamer :
import 'package:geolocator/geolocator.dart';
import 'package:public_health/Services/Location/locationstream.dart';

class LocationProvider extends ChangeNotifier {
  Position? position;

  StreamSubscription<Position>? _subscription;

  void startStreaming() {
    _subscription ??= Location().stream().listen((newPosition) {
      position = newPosition;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
