import 'package:flutter/cupertino.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:public_health/Theme/theme.dart';

class PickupMapPage extends StatelessWidget {
  final double latitude;
  final double longitude;

  const PickupMapPage({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          SizedBox.expand(
            child: MapWidget(
              styleUri: 'mapbox://styles/spotmap-app/cmoa88xof000z01sacg9b4om8',
              onMapCreated: (MapboxMap mapboxMap) async {
                final point = Point(coordinates: Position(longitude, latitude));

                await mapboxMap.setCamera(
                  CameraOptions(center: point, zoom: 18),
                );

                await mapboxMap.style.addSource(
                  GeoJsonSource(
                    id: 'pickup-source',
                    data:
                        '''
                    {
                      "type": "FeatureCollection",
                      "features": [
                        {
                          "type": "Feature",
                          "geometry": {
                            "type": "Point",
                            "coordinates": [$longitude, $latitude]
                          }
                        }
                      ]
                    }
                    ''',
                  ),
                );

                await mapboxMap.style.addLayer(
                  CircleLayer(
                    id: 'pickup-layer',
                    sourceId: 'pickup-source',
                    circleColor: AppColors.accent.value,
                    circleRadius: 10,
                    circleStrokeColor: CupertinoColors.white.value,
                    circleStrokeWidth: 3,
                  ),
                );
              },
            ),
          ),

          Positioned(
            top: 55,
            left: 16,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(21),
                ),
                child: const Icon(
                  CupertinoIcons.back,
                  color: CupertinoColors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
