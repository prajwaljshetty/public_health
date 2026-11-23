import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:public_health/Config/mapbox_config.dart';

class DirectionsService {
  static const String _baseUrl = 'https://api.mapbox.com/directions/v5/mapbox';

  Future<DirectionsRoute> getRoute({
    required double originLatitude,
    required double originLongitude,
    required double destinationLatitude,
    required double destinationLongitude,
  }) async {
    final coordinates =
        '$originLongitude,$originLatitude;'
        '$destinationLongitude,$destinationLatitude';

    final uri = Uri.parse('$_baseUrl/driving-traffic/$coordinates').replace(
      queryParameters: {
        'access_token': MapboxConfig.accessToken,
        'steps': 'true',
        'geometries': 'geojson',
        'overview': 'full',
        'language': 'en',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Directions API failed: ${response.statusCode} '
        '${response.body}',
      );
    }

    final data = jsonDecode(response.body);

    if (data['code'] != 'Ok' || (data['routes'] as List).isEmpty) {
      throw Exception('No route available.');
    }

    final route = data['routes'][0];

    final coordinatesList = route['geometry']['coordinates'] as List;

    final points = coordinatesList.map<List<double>>((coordinate) {
      return [
        (coordinate[0] as num).toDouble(),
        (coordinate[1] as num).toDouble(),
      ];
    }).toList();

    final instructions = <String>[];

    for (final leg in route['legs']) {
      for (final step in leg['steps']) {
        final instruction = step['maneuver']['instruction'] as String?;

        if (instruction != null && instruction.isNotEmpty) {
          instructions.add(instruction);
        }
      }
    }

    return DirectionsRoute(
      coordinates: points,
      distance: (route['distance'] as num).toDouble(),
      duration: (route['duration'] as num).toDouble(),
      instructions: instructions,
    );
  }
}

class DirectionsRoute {
  final List<List<double>> coordinates;
  final double distance;
  final double duration;
  final List<String> instructions;

  const DirectionsRoute({
    required this.coordinates,
    required this.distance,
    required this.duration,
    required this.instructions,
  });
}
