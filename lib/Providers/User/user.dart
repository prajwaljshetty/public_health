import 'package:flutter/foundation.dart';

// Local Storage :
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String? userid, username, phoneno, role;

  bool get isLoggedIn => userid != null;

  Future<void> setUser({
    required String userid,
    required String username,
    required String phoneno,
    required String role,
  }) async {
    this.userid = userid;
    this.username = username;
    this.phoneno = phoneno;
    this.role = role;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', userid);
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('uid');
    userid = null;
    username = null;
    phoneno = null;
    role = null;
    notifyListeners();
  }
}
