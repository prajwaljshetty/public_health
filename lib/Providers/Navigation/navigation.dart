import 'package:flutter/foundation.dart';
import 'package:public_health/Services/Navigation/directions.dart';

class NavigationProvider extends ChangeNotifier {
  final DirectionsService _directionsService = DirectionsService();

  DirectionsRoute? _route;
  bool _isLoading = false;
  String? _error;
  int _currentInstructionIndex = 0;

  DirectionsRoute? get route => _route;

  bool get isLoading => _isLoading;

  String? get error => _error;

  int get currentInstructionIndex => _currentInstructionIndex;

  String? get currentInstruction {
    if (_route == null || _route!.instructions.isEmpty) {
      return null;
    }

    if (_currentInstructionIndex >= _route!.instructions.length) {
      return null;
    }

    return _route!.instructions[_currentInstructionIndex];
  }

  Future<void> startNavigation({
    required String languageCode,
    required double originLatitude,
    required double originLongitude,
    required double destinationLatitude,
    required double destinationLongitude,
  }) async {
    _isLoading = true;
    _error = null;
    _route = null;
    _currentInstructionIndex = 0;

    notifyListeners();

    try {
      _route = await _directionsService.getRoute(
        languageCode: languageCode,
        originLatitude: originLatitude,
        originLongitude: originLongitude,
        destinationLatitude: destinationLatitude,
        destinationLongitude: destinationLongitude,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void nextInstruction() {
    if (_route == null) return;

    if (_currentInstructionIndex < _route!.instructions.length - 1) {
      _currentInstructionIndex++;
      notifyListeners();
    }
  }

  void resetNavigation() {
    _route = null;
    _isLoading = false;
    _error = null;
    _currentInstructionIndex = 0;

    notifyListeners();
  }
}
