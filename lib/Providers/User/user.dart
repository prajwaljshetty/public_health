import 'package:flutter/foundation.dart';

// Shared Preference :
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// API :
import 'package:public_health/Services/API/Household/api_service.dart'
    as household;
import 'package:public_health/Services/API/Workers/api_service.dart' as worker;

class UserProvider extends ChangeNotifier {
  String? userid, username, phoneno, role, workerid;
  String? accesstoken, refreshtoken;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  bool get isLoggedIn => refreshtoken != null && refreshtoken!.isNotEmpty;

  Future<void> initialize() async {
    userid = await _storage.read(key: 'user_id');
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

  Future<void> setPref({required String userid}) async {
    await _storage.write(key: 'user_id', value: userid);
  }

  Future<void> setUser({
    required String userid,
    required String username,
    required String? workerid,
    required String phoneno,
    required String role,
  }) async {
    await setPref(userid: userid);
    this.userid = userid;
    this.workerid = workerid;
    this.username = username;
    this.phoneno = phoneno;
    this.role = role;

    notifyListeners();
  }

  Future<void> logout() async {
    await _storage.delete(key: 'user_id');
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');

    role == 'household'
        ? household.ApiService.disconnect()
        : worker.ApiService.disconnect();

    userid = null;
    username = null;
    phoneno = null;
    role = null;
    accesstoken = null;
    refreshtoken = null;

    notifyListeners();
  }
}
