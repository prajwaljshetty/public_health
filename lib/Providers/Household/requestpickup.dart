import 'package:flutter/foundation.dart';

class PickupRequestProvider extends ChangeNotifier {
  String? pickupid;
  String? time;
  ({double latitude, double longitude})? coordinates;
  List<int> qna = [];
  String pickupStatus = "idle";

  void setpickupid({required String pickupid}) {
    this.pickupid = pickupid;
    notifyListeners();
  }

  void setPickupStatus(String status) {
    pickupStatus = status;
    notifyListeners();
  }

  void setLocation({required double latitude, required double longitude}) {
    coordinates = (latitude: latitude, longitude: longitude);

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
    qna = [];
    pickupStatus = "idle";
    notifyListeners();
  }
}
