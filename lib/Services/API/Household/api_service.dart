import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000';

  static Future<Map<String, dynamic>> create({
    required String username,
    required phoneno,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/household/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'role': 'household',
        'phoneno': phoneno,
        'password': password,
      }),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> login({
    required String phoneno,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/household/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phoneno': phoneno, 'password': password}),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getdata({required String uid}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/household/data/$uid'),
      headers: {'Content-Type': 'application/json'},
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> requestpickup({
    required String uid,
    required String time,
    required ({double latitude, double longitude}) coordinates,
    required File image,
    required List<int> qna,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/household/requestpickup'),
    );

    request.fields['userid'] = uid;
    request.fields['time'] = time;
    request.fields['latitude'] = coordinates.latitude.toString();
    request.fields['longitude'] = coordinates.longitude.toString();
    request.fields['qna'] = qna.join(',');

    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    final streamedResponse = await request.send();

    final response = await http.Response.fromStream(streamedResponse);

    return jsonDecode(response.body);
  }
}
