import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// Map :
import 'package:public_health/Theme/theme.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

// Geo Locator :
import 'package:geolocator/geolocator.dart' as geo;

// Language :
import 'package:public_health/l10n/app_localizations.dart';

// Provider :
import 'package:provider/provider.dart';
import 'package:public_health/Providers/Location/location.dart';

class PickupMapPage extends StatefulWidget {
  final String pickupId;
  final String username;
  final String time;
  final double distance;
  final List<int> qna;
  final double latitude;
  final double longitude;

  const PickupMapPage({
    super.key,
    required this.pickupId,
    required this.username,
    required this.time,
    required this.distance,
    required this.qna,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<PickupMapPage> createState() => _PickupMapPageState();
}

class _PickupMapPageState extends State<PickupMapPage> {
  MapboxMap? _mapboxMap;

  void _showPickupModal() {
    final l10n = AppLocalizations.of(context)!;

    final recipientName = widget.username;
    final id = widget.pickupId;
    final pickupTime = DateFormat('dd MMM yyyy,hh:mm a')
        .format(DateTime.parse(widget.time));
    final shortPickupId = id.length > 12 ? '${id.substring(0, 20)}...' : id;

    showCupertinoModalPopup(
      context: context,
      builder: (modalContext) {
        return Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          decoration: const BoxDecoration(
            color: AppColors.backgroundwhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Modal handle
                Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.layering,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 22),

                // Receipt outer card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundwhite,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.border, width: 1.5),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.yellow,
                      borderRadius: BorderRadius.circular(19),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Receipt title
                        Text(
                          l10n.requestDetails,
                          style: AppText.cardTitle.copyWith(fontSize: 16),
                        ),

                        const SizedBox(height: 20),

                        // Recipient
                        _receiptDetail(
                          label: l10n.recipientLabel,
                          value: recipientName,
                        ),

                        const SizedBox(height: 12),
                        const AppDashedDivider(),
                        const SizedBox(height: 12),

                        // Pickup ID with copy button
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                l10n.pickupIdLabel,
                                style: AppText.cardSubtitle.copyWith(
                                  color: AppColors.accent,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundblack.withAlpha(10),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      shortPickupId,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppText.cardSubtitle.copyWith(
                                        fontSize: 12,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    minimumSize: ui.Size.zero,
                                    onPressed: () async {
                                      await Clipboard.setData(
                                        ClipboardData(text: widget.pickupId),
                                      );

                                      if (!context.mounted) return;

                                      showCupertinoDialog<void>(
                                        context: context,
                                        builder: (dialogContext) =>
                                            CupertinoAlertDialog(
                                              content: Text(
                                                l10n.pickupIdCopied,
                                              ),
                                              actions: [
                                                CupertinoDialogAction(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                        dialogContext,
                                                      ),
                                                  child: Text(l10n.okButton),
                                                ),
                                              ],
                                            ),
                                      );
                                    },
                                    child: const Icon(
                                      CupertinoIcons.doc_on_doc,
                                      size: 14,
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),
                        const AppDashedDivider(),
                        const SizedBox(height: 12),

                        // Pickup time
                        _receiptDetail(
                          label: l10n.requestedTimeLabel,
                          value: pickupTime,
                        ),

                        const SizedBox(height: 12),
                        const AppDashedDivider(),
                        const SizedBox(height: 12),

                        // Distance
                        _receiptDetail(
                          label: 'Distance',
                          value: '${widget.distance.toStringAsFixed(2)} km',
                        ),

                        const SizedBox(height: 18),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                AppPrimaryButton(
                  text: l10n.acceptPickup,
                  onPressed: () {
                    Navigator.pop(modalContext);

                    // TODO: Connect pickup acceptance logic.
                  },
                ),

                const SizedBox(height: 6),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _receiptDetail({required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: AppText.cardSubtitle.copyWith(color: AppColors.accent),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppText.label.copyWith(fontSize: 14, height: 1.4),
          ),
        ),
      ],
    );
  }

  void _moveCamera() {
    if (_mapboxMap == null) return;

    final position = context.read<LocationProvider>().position;

    if (position == null) return;

    final distance = geo.Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      widget.latitude,
      widget.longitude,
    );

    // Same / very close location
    if (distance < 100) {
      _mapboxMap!.flyTo(
        CameraOptions(
          center: Point(
            coordinates: Position(widget.longitude, widget.latitude),
          ),
          zoom: 17,
        ),
        MapAnimationOptions(duration: 1000),
      );

      return;
    }

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

  Future<void> _configurePickupMarker() async {
    final mapboxMap = _mapboxMap;
    if (mapboxMap == null) return;

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
            },
            "properties": {}
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
                    pulsingMaxRadius: 30,
                  ),
                );

                await mapboxMap.setCamera(
                  CameraOptions(
                    center: Point(
                      coordinates: Position(widget.longitude, widget.latitude),
                    ),
                    zoom: 18,
                  ),
                );
              },

              onStyleLoadedListener: (_) async {
                try {
                  await _configurePickupMarker();

                  if (!mounted) return;

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Future.delayed(const Duration(seconds: 1), () {
                      if (!mounted) return;

                      _moveCamera();
                      _showPickupModal();
                    });
                  });
                } catch (error, stackTrace) {
                  debugPrint('Failed to add pickup marker: $error');
                  debugPrintStack(stackTrace: stackTrace);
                }
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
                  color: AppColors.backgroundwhite,
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
