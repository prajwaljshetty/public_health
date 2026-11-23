import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:public_health/Services/Navigation/directions.dart';

class NavigationProvider extends ChangeNotifier {
  final DirectionsService _directionsService = DirectionsService();

  DirectionsRoute? route;

  bool isLoading = false;
  String? error;

  int currentInstructionIndex = 0;

  Future<void> startNavigation({
    required Position origin,
    required double destinationLatitude,
    required double destinationLongitude,
  }) async {
    isLoading = true;
    error = null;
    route = null;
    currentInstructionIndex = 0;
    notifyListeners();

    try {
      route = await _directionsService.getRoute(
        originLatitude: origin.latitude,
        originLongitude: origin.longitude,
        destinationLatitude: destinationLatitude,
        destinationLongitude: destinationLongitude,
      );
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void nextInstruction() {
    if (route == null) return;

    if (currentInstructionIndex < route!.instructions.length - 1) {
      currentInstructionIndex++;
      notifyListeners();
    }
  }

  void resetNavigation() {
    route = null;
    error = null;
    isLoading = false;
    currentInstructionIndex = 0;
    notifyListeners();
  }

  String? get currentInstruction {
    if (route == null || route!.instructions.isEmpty) return null;

    return route!.instructions[currentInstructionIndex];
  }
}
