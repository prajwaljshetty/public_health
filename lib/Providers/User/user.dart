import 'package:flutter/foundation.dart';

// Shared Preference :
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// API :
import 'package:public_health/Services/API/Household/api_service.dart';

class UserProvider extends ChangeNotifier {
  String? userid, username, phoneno, role;
  String? accesstoken, refreshtoken;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  bool get isLoggedIn => refreshtoken != null && refreshtoken!.isNotEmpty;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();

    userid = prefs.getString('uid');
    accesstoken = await _storage.read(key: 'access_token');
    refreshtoken = await _storage.read(key: 'refresh_token');

    _isInitialized = true;
    notifyListeners();
  }

  Future<void> setTokens({
    required String accesstoken,
    required String refreshtoken,
  }) async {
    await _storage.write(key: 'access_token', value: accesstoken);
    await _storage.write(key: 'refresh_token', value: refreshtoken);

    this.accesstoken = accesstoken;
    this.refreshtoken = refreshtoken;

    notifyListeners();
  }

  Future<void> updateAccessToken(String newAccessToken) async {
    await _storage.write(key: 'access_token', value: newAccessToken);

    accesstoken = newAccessToken;
    notifyListeners();
  }

  Future<void> setUser({
    required String userid,
    required String username,
    required String phoneno,
    required String role,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', userid);

    this.userid = userid;
    this.username = username;
    this.phoneno = phoneno;
    this.role = role;

    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('uid');

    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');

    ApiService.disconnect();

    userid = null;
    username = null;
    phoneno = null;
    role = null;
    accesstoken = null;
    refreshtoken = null;

    notifyListeners();
  }
}
