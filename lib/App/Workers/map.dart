import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;

// Map :
import 'package:public_health/Theme/theme.dart';

// Language :
import 'package:public_health/l10n/app_localizations.dart';

// Provider :
import 'package:provider/provider.dart';
import 'package:public_health/Providers/Location/location.dart';

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

  @override
  void initState() {
    super.initState();
  }

  void _showPickupModal() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                    color: AppColors.accent,
                    borderRadius: const BorderRadius.all(Radius.circular(24)),
                    onPressed: () {
                      Navigator.pop(context);
                      // Accept pickup
                    },
                    child: const Text(
                      'Accept Pickup',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
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
    if (_mapboxMap == null) return;

    final position = context.read<LocationProvider>().position;

    if (position == null) return;

    final bounds = CoordinateBounds(
      southwest: Point(
        coordinates: Position(
          min(position.longitude, widget.longitude),
          min(position.latitude, widget.latitude),
        ),
      ),
      northeast: Point(
        coordinates: Position(
          max(position.longitude, widget.longitude),
          max(position.latitude, widget.latitude),
        ),
      ),
      infiniteBounds: false,
    );

    _mapboxMap!
        .cameraForCoordinateBounds(
          bounds,
          MbxEdgeInsets(top: 320, left: 60, bottom: 300, right: 60),
          null,
          null,
          null,
          null,
        )
        .then((camera) {
          if (!mounted) return;

          _mapboxMap!.flyTo(camera, MapAnimationOptions(duration: 1000));
        });
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

                await mapboxMap.location.updateSettings(
                  LocationComponentSettings(
                    enabled: true,
                    pulsingEnabled: true,
                    pulsingColor: AppColors.accent.value,
                    pulsingMaxRadius: 20,
                    showAccuracyRing: true,
                    accuracyRingColor: AppColors.accent.value,
                    accuracyRingBorderColor: AppColors.accent.value,
                  ),
                );

                final point = Point(
                  coordinates: Position(widget.longitude, widget.latitude),
                );

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

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Future.delayed(const Duration(seconds: 1), () {
                    if (!mounted) return;

                    _moveCamera();
                    _showPickupModal();
                  });
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
                  borderRadius: BorderRadius.circular(18),
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
