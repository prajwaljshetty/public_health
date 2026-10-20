import 'dart:convert';

// HTTP :
import 'package:http/http.dart' as http;
import 'package:public_health/Providers/User/user.dart';
import 'package:public_health/Providers/Household/requestpickup.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000';

  static Future<Map<String, dynamic>> create({
    required String username,
    required String phoneno,
    required String password,
    required UserProvider userprovider,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/household/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'phoneno': phoneno,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode >= 200 &&
        response.statusCode < 300 &&
        data['status'] == true) {
      await userprovider.setTokens(
        accesstoken: data['access_token'] as String,
        refreshtoken: data['refresh_token'] as String,
      );
    }

    return {'status': data['status'], 'code': data['message']};
  }

  static Future<Map<String, dynamic>> login({
    required String phoneno,
    required String password,
    required UserProvider userprovider,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/household/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phoneno': phoneno, 'password': password}),
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
    required PickupRequestProvider pickuprequestprovider,
  }) async {
    try {
      var response = await http.get(
        Uri.parse('$baseUrl/household/data'),
        headers: {'Authorization': 'Bearer ${userprovider.accesstoken}'},
      );

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
          Uri.parse('$baseUrl/household/data'),
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

      pickuprequestprovider.hasActivePickup =
          userData['has_active_pickup'] as bool;

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
      Uri.parse('$baseUrl/household/refresh'),
      headers: {'Authorization': 'Bearer $refreshtoken'},
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getpickupdata({
    required UserProvider userprovider,
    required PickupRequestProvider pickuprequestprovider,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/household/pickupdata'),
        headers: {'Authorization': 'Bearer ${userprovider.accesstoken}'},
      );

      final requestData = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return {
          'status': false,
          'code': response.statusCode == 401 ? 'AUTH_REQUIRED' : 'HTTP_ERROR',
          'message': requestData['detail'] ?? 'Failed to fetch pickup data.',
        };
      }

      if (requestData['status'] != true) {
        return {
          'status': false,
          'code': 'PICKUP_DATA_ERROR',
          'message': requestData['message'] ?? 'Failed to fetch pickup data.',
        };
      }

      final pickup = requestData['pickupdata'];

      if (pickup != null) {
        final coordinate = pickup['coordinate'];

        pickuprequestprovider.pickupid = pickup['pickupid'] as String?;

        pickuprequestprovider.coordinates = (
          latitude: (coordinate['latitude'] as num).toDouble(),
          longitude: (coordinate['longitude'] as num).toDouble(),
        );

        pickuprequestprovider.time = pickup['time'];

        pickuprequestprovider.qna = List<int>.from(pickup['qna'] ?? []);
      }

      return requestData;
    } on http.ClientException {
      return {
        'status': false,
        'code': 'NETWORK_ERROR',
        'message': 'Unable to connect to the server.',
      };
    } on FormatException {
      return {
        'status': false,
        'code': 'INVALID_RESPONSE',
        'message': 'Invalid response received from the server.',
      };
    }
  }

  static Future<Map<String, dynamic>> requestpickup({
    required UserProvider userprovider,
    required String time,
    required ({double latitude, double longitude}) coordinates,
    required List<int> qna,
  }) async {
    try {
      final accessToken = userprovider.accesstoken;

      if (accessToken == null || accessToken.isEmpty) {
        return {
          'status': false,
          'code': 'AUTH_REQUIRED',
          'message': 'Please log in again.',
        };
      }

      final response = await http.post(
        Uri.parse('$baseUrl/household/requestpickup'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'time': time,
          'coordinate': {
            'latitude': coordinates.latitude,
            'longitude': coordinates.longitude,
          },
          'qna': qna,
        }),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return {
          'status': false,
          'code': response.statusCode == 401 ? 'AUTH_REQUIRED' : 'HTTP_ERROR',
          'message': data['detail'] ?? 'Failed to submit pickup request.',
        };
      }

      return data;
    } on http.ClientException {
      return {
        'status': false,
        'code': 'NETWORK_ERROR',
        'message': 'Unable to connect to the server.',
      };
    } on FormatException {
      return {
        'status': false,
        'code': 'INVALID_RESPONSE',
        'message': 'Invalid response received from the server.',
      };
    }
  }
}
