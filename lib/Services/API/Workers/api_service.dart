import 'dart:convert';

// HTTP :
import 'package:http/http.dart' as http;

// Websocket :
import 'package:web_socket_channel/web_socket_channel.dart';

// Provider :
import 'package:public_health/Providers/User/user.dart';

class ApiService {
  static const String httpBaseUrl = 'http://127.0.0.1:8000';
  static const String webSocketBaseUrl = 'ws://127.0.0.1:8000';
  static WebSocketChannel? pickupChannel;

  static Future<Map<String, dynamic>> login({
    required String workerid,
    required String password,
    required UserProvider userprovider,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$httpBaseUrl/worker/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'worker_id': workerid, 'password': password}),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 200 &&
          response.statusCode < 300 &&
          data['status'] == true) {
        await userprovider.setTokens(
          accesstoken: data['access_token'] as String,
          refreshtoken: data['refresh_token'] as String,
        );

        return {'status': true, 'user_id': data['user_id']};
      }

      final detail = data['detail'] ?? data['message'];

      return {
        'status': false,
        'code': switch (detail) {
          'USER_NOT_FOUND' => 'USER_NOT_FOUND',
          'INCORRECT_PASSWORD' => 'INCORRECT_PASSWORD',
          _ => 'LOGIN_FAILED',
        },
      };
    } on http.ClientException {
      return {'status': false, 'code': 'NETWORK_ERROR'};
    } on FormatException {
      return {'status': false, 'code': 'INVALID_RESPONSE'};
    }
  }

  static Future<Map<String, dynamic>> getdata({
    required UserProvider userprovider,
  }) async {
    try {
      var response = await http.get(
        Uri.parse('$httpBaseUrl/worker/data'),
        headers: {'Authorization': 'Bearer ${userprovider.accesstoken}'},
      );
      print(response.body);

      if (response.statusCode == 401) {
        final refreshToken = userprovider.refreshtoken;

        if (refreshToken == null || refreshToken.isEmpty) {
          return {
            'status': false,
            'message': 'Please log in again.',
            'code': 'AUTH_REQUIRED',
          };
        }

        final tokenResponse = await getacesstoken(refreshtoken: refreshToken);

        if (tokenResponse['status'] != true ||
            tokenResponse['access_token'] == null) {
          return {
            'status': false,
            'message':
                tokenResponse['detail'] ??
                tokenResponse['message'] ??
                'Session expired. Please log in again.',
            'code': 'REFRESH_FAILED',
          };
        }

        final newAccessToken = tokenResponse['access_token'] as String;

        await userprovider.updateAccessToken(newAccessToken);

        response = await http.get(
          Uri.parse('$httpBaseUrl/worker/data'),
          headers: {'Authorization': 'Bearer $newAccessToken'},
        );
      }

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return {
          'status': false,
          'message': response.statusCode == 401
              ? 'Session expired. Please log in again.'
              : 'Request failed with status ${response.statusCode}.',
          'code': response.statusCode == 401 ? 'AUTH_REQUIRED' : 'HTTP_ERROR',
        };
      }

      final result = jsonDecode(response.body) as Map<String, dynamic>;

      if (result['status'] != true) {
        return {
          'status': false,
          'message': result['message'] ?? 'Unable to fetch user data.',
          'code': 'API_ERROR',
        };
      }

      final userData = result['user_data'] as Map<String, dynamic>;

      await userprovider.setUser(
        userid: userData['user_id'] as String,
        username: userData['user_name'] as String,
        phoneno: userData['phoneno'] as String,
        role: userData['role'] as String,
      );

      return result;
    } on http.ClientException {
      return {
        'status': false,
        'message': 'Unable to connect to the server.',
        'code': 'NETWORK_ERROR',
      };
    } on FormatException {
      return {
        'status': false,
        'message': 'The server returned an invalid response.',
        'code': 'INVALID_RESPONSE',
      };
    }
  }

  static Future<Map<String, dynamic>> getacesstoken({
    required String refreshtoken,
  }) async {
    final response = await http.post(
      Uri.parse('$httpBaseUrl/worker/refresh'),
      headers: {'Authorization': 'Bearer $refreshtoken'},
    );

    return jsonDecode(response.body);
  }

  static Future<WebSocketChannel?> pickupsStream({
    required UserProvider userprovider,
  }) async {
    try {
      final accessToken = userprovider.accesstoken;

      if (accessToken == null || accessToken.isEmpty) {
        return null;
      }

      final channel = WebSocketChannel.connect(
        Uri.parse('$webSocketBaseUrl/worker/pickups'),
      );

      await channel.ready;

      channel.sink.add(accessToken);

      pickupChannel = channel;

      return channel;
    } catch (error) {
      return null;
    }
  }

  static void disconnectPickups() {
    pickupChannel?.sink.add('logout');
    pickupChannel?.sink.close();
    pickupChannel = null;
  }
}
