import 'dart:convert';

// HTTP :
import 'package:http/http.dart' as http;

// Websocket :
import 'package:web_socket_channel/web_socket_channel.dart';

class ApiService {
  static const String httpBaseUrl = 'http://127.0.0.1:8000';
  static const String webSocketBaseUrl = 'ws://127.0.0.1:8000';
  static WebSocketChannel? pickupChannel;

  static Future<Map<String, dynamic>> login({
    required String workerid,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$httpBaseUrl/worker/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'workerid': workerid, 'password': password}),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getdata({required String uid}) async {
    final response = await http.get(
      Uri.parse('$httpBaseUrl/worker/data/$uid'),
      headers: {'Content-Type': 'application/json'},
    );
    return jsonDecode(response.body);
  }

  static WebSocketChannel pickupsStream(String uid) {
    pickupChannel = WebSocketChannel.connect(
      Uri.parse('$webSocketBaseUrl/worker/pickups/$uid'),
    );
    return pickupChannel!;
  }

  static void disconnectPickups() {
    pickupChannel?.sink.add('logout');
    pickupChannel?.sink.close();
    pickupChannel = null;
  }
}
