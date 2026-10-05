import 'package:flutter/cupertino.dart';

// Map :
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

// Theme :
import 'package:public_health/Theme/theme.dart';

// Language :
import 'package:public_health/l10n/app_localizations.dart';

class PickupMapPage extends StatefulWidget {
  final double latitude;
  final double longitude;

  const PickupMapPage({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<PickupMapPage> createState() => _PickupMapPageState();
}

class _PickupMapPageState extends State<PickupMapPage> {
  MapboxMap? _mapboxMap;

  void _showPickupModal() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: CupertinoColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey4,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 20),

                // Title
                const Text(
                  'Pickup Available',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 20),

                // Button
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton.filled(
                    onPressed: () {
                      Navigator.pop(context);

                      // Accept pickup
                    },
                    child: const Text('Accept Pickup'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _moveCamera() {
    _mapboxMap?.flyTo(
      CameraOptions(
        center: Point(coordinates: Position(widget.longitude, widget.latitude)),
        zoom: 18,
      ),
      MapAnimationOptions(duration: 1000),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          // MAP
          SizedBox.expand(
            child: MapWidget(
              styleUri: 'mapbox://styles/spotmap-app/cmoa88xof000z01sacg9b4om8',

              onMapCreated: (MapboxMap mapboxMap) async {
                _mapboxMap = mapboxMap;
                final point = Point(
                  coordinates: Position(widget.longitude, widget.latitude),
                );

                // Camera
                await mapboxMap.setCamera(
                  CameraOptions(center: point, zoom: 18),
                );

                // Source
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
                            "coordinates": [
                              ${widget.longitude},
                              ${widget.latitude}
                            ]
                          }
                        }
                      ]
                    }
                    ''',
                  ),
                );

                // Pickup marker
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

                // Show modal after map loads
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _showPickupModal();
                });
              },
            ),
          ),

          // BACK BUTTON
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

          // SHOW MODAL BUTTON
          Positioned(
            bottom: 30,
            right: 16,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                _moveCamera();
                _showPickupModal();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 10,
                      offset: Offset(0, 3),
                      color: Color.fromARGB(255, 208, 208, 208),
                    ),
                  ],
                ),
                child: Text(
                  l10n.pickupDetails,
                  style: TextStyle(
                    color: AppColors.yellow,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
