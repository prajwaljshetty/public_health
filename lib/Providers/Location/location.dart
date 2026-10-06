// Locations :
import 'package:flutter/foundation.dart';

// Location Streamer :
import 'package:geolocator/geolocator.dart';
import 'package:public_health/Services/Location/locationstream.dart';

class LocationProvider extends ChangeNotifier {
  Position? position;

  void startStreaming() {
    Location().stream().listen((newPostion) {
      position = newPostion;
      notifyListeners();
    });
  }
}
