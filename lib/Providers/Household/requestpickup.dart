import 'dart:io';

import 'package:flutter/foundation.dart';

class PickupRequestProvider extends ChangeNotifier {
  String? pickupid;
  String? time;
  ({double latitude, double longitude})? coordinates;
  File? image;
  List<int> qna = [];
  bool hasActivePickup = false;

  void setpickupid({required String pickupid}) {
    this.pickupid = pickupid;
    notifyListeners();
  }

  void sethasActivePickup({required bool hasActivePickup}) {
    this.hasActivePickup = hasActivePickup;
    notifyListeners();
  }

  void setLocation({required double latitude, required double longitude}) {
    coordinates = (latitude: latitude, longitude: longitude);

    notifyListeners();
  }

  void setImage(File image) {
    this.image = image;
    notifyListeners();
  }

  void setQna(List<int> qna) {
    this.qna = qna;
    notifyListeners();
  }

  void setTime(String time) {
    this.time = time;
    notifyListeners();
  }

  void clearPickup() {
    time = null;
    coordinates = null;
    image = null;
    qna = [];

    notifyListeners();
  }
}
