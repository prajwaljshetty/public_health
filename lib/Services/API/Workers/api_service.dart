import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000';

  static Future<Map<String, dynamic>> login({
    required String workerid,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/worker/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'workerid': workerid, 'password': password}),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getdata({required String uid}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/worker/data/$uid'),
      headers: {'Content-Type': 'application/json'},
    );
    return jsonDecode(response.body);
  }
}
