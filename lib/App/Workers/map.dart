import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// Map :
import 'package:public_health/Theme/theme.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

// Language :
import 'package:public_health/l10n/app_localizations.dart';

// Request Confirmation :
import 'package:public_health/App/Workers/pickupacceptanceconfirmation.dart';

// Assets
import 'package:public_health/assetmaper.dart';

// Provider :
import 'package:provider/provider.dart';
import 'package:public_health/Providers/Location/location.dart';

enum MapViewMode { discover, accepted }

class MapPage extends StatefulWidget {
  final String pickupId;
  final String username;
  final String time;
  final double distance;
  final List<int> qna;
  final double latitude;
  final double longitude;
  final MapViewMode mode;

  const MapPage({
    super.key,
    required this.pickupId,
    required this.username,
    required this.time,
    required this.distance,
    required this.qna,
    required this.latitude,
    required this.longitude,
    this.mode = MapViewMode.discover,
  });

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapboxMap? _mapboxMap;

  bool isModalOpen = false;

  // One controller handles all six digits, including paste and backspace.
  final TextEditingController _codeController = TextEditingController();
  final FocusNode _codeFocusNode = FocusNode();

  String get _verificationCode => _codeController.text;

  bool get _isCodeComplete => _verificationCode.length == 6;

  void _discover() {
    final l10n = AppLocalizations.of(context)!;

    final recipientName = widget.username;
    final id = widget.pickupId;

    final pickupTime = DateFormat('dd MMM yyyy, hh:mm a')
        .format(DateTime.parse(widget.time));

    final shortPickupId = id.length > 20 ? '${id.substring(0, 20)}...' : id;

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

                Container(
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
                                            content: Text(l10n.pickupIdCopied),
                                            actions: [
                                              CupertinoDialogAction(
                                                onPressed: () {
                                                  Navigator.pop(dialogContext);
                                                },
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

                const SizedBox(height: 14),

                AppPrimaryButton(
                  text: l10n.acceptPickup,
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => PickupAcceptanceConfirmationPage(
                          pickupId: widget.pickupId,
                          username: widget.username,
                          time: widget.time,
                          distance: widget.distance,
                          qna: widget.qna,
                          latitude: widget.latitude,
                          longitude: widget.longitude,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 6),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {
      isModalOpen = false;
    });
  }

  void _accepted() {
    final l10n = AppLocalizations.of(context)!;

    _codeController.clear();
    _codeFocusNode.unfocus();

    showCupertinoModalPopup(
      context: context,
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: const BoxDecoration(
                color: AppColors.backgroundwhite,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 38,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.layering,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      const SizedBox(height: 16),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundwhite,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: AppColors.backgroundblack,
                            width: 1.3,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  CupertinoIcons.cube_box_fill,
                                  color: AppColors.boxyellow,
                                  size: 33,
                                ),

                                const SizedBox(width: 10),

                                Text(
                                  'Verify Pickup',
                                  style: AppText.cardTitle.copyWith(
                                    fontSize: 19,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 18),

                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 22,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundwhite,
                                borderRadius: BorderRadius.circular(17),
                                border: Border.all(
                                  color: AppColors.backgroundblack,
                                  width: 1.3,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Image.asset(
                                    AssetMapper.qrCode,
                                    height: 150,
                                    width: 150,
                                    fit: BoxFit.contain,
                                  ),

                                  const SizedBox(height: 16),

                                  Text(
                                    'Scan Household QR Code',
                                    textAlign: TextAlign.center,
                                    style: AppText.cardTitle.copyWith(
                                      fontSize: 16,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Text(
                                      'Ask the household to display their pickup QR code, then scan it to verify the handover.',
                                      textAlign: TextAlign.center,
                                      style: AppText.cardSubtitle.copyWith(
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),

                            SizedBox(
                              width: double.infinity,
                              child: CupertinoButton(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 13,
                                ),
                                color: AppColors.accent,
                                borderRadius: BorderRadius.circular(14),
                                onPressed: () {
                                  // TODO:
                                  // Navigate to QR scanner page.
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      CupertinoIcons.qrcode_viewfinder,
                                      color: CupertinoColors.white,
                                      size: 20,
                                    ),

                                    const SizedBox(width: 9),

                                    Text(
                                      'Scan QR Code',
                                      style: TextStyle(
                                        color: AppColors.backgroundwhite,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: AppColors.layering,
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Text(
                                    'OR',
                                    style: AppText.cardSubtitle,
                                  ),
                                ),

                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: AppColors.layering,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 18),

                            // MANUAL CODE TITLE
                            Text(
                              "Can't scan QR?",
                              style: AppText.cardTitle.copyWith(fontSize: 17),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              'Enter the 6-digit pickup verification code.',
                              style: AppText.cardSubtitle,
                            ),

                            const SizedBox(height: 16),

                            // SIX-DIGIT OTP INPUT
                            GestureDetector(
                              onTap: () {
                                _codeFocusNode.requestFocus();
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Visual boxes
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: List.generate(6, (index) {
                                      final code = _codeController.text;
                                      final hasValue = index < code.length;
                                      final isActive =
                                          index == code.length &&
                                          code.length < 6;

                                      return AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 160,
                                        ),
                                        width: 42,
                                        height: 50,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: AppColors.backgroundwhite,
                                          border: Border.all(
                                            color: isActive
                                                ? AppColors.accent
                                                : AppColors.layering,
                                            width: isActive ? 1.8 : 1.2,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Text(
                                          hasValue ? code[index] : '',
                                          style: AppText.cardTitle.copyWith(
                                            fontSize: 22,
                                          ),
                                        ),
                                      );
                                    }),
                                  ),

                                  // One invisible field receives all keyboard input.
                                  Positioned.fill(
                                    child: Opacity(
                                      opacity: 0,
                                      child: CupertinoTextField(
                                        controller: _codeController,
                                        focusNode: _codeFocusNode,
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        maxLength: 6,
                                        maxLengthEnforcement:
                                            MaxLengthEnforcement.enforced,
                                        autofillHints: const [
                                          AutofillHints.oneTimeCode,
                                        ],
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        enableInteractiveSelection: false,
                                        decoration: const BoxDecoration(),
                                        onChanged: (_) {
                                          setModalState(() {});
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 18),

                            SizedBox(
                              width: double.infinity,
                              child: CupertinoButton(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 13,
                                ),
                                color: AppColors.accent,
                                borderRadius: BorderRadius.circular(14),
                                disabledColor: AppColors.layering,
                                onPressed: _isCodeComplete
                                    ? () {
                                        final code = _verificationCode;
                                      }
                                    : null,
                                child: Text(
                                  'Verify Code',
                                  style: TextStyle(
                                    color: AppColors.backgroundwhite,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      isModalOpen = false;

      _codeController.clear();
      _codeFocusNode.unfocus();
    });
  }

  void _showPickupModal(MapViewMode mode) {
    if (isModalOpen) return;

    isModalOpen = true;

    switch (mode) {
      case MapViewMode.discover:
        _discover();
        break;

      case MapViewMode.accepted:
        _accepted();
        break;
    }
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

  Future<void> _moveCamera() async {
    final mapboxMap = _mapboxMap;
    if (mapboxMap == null) return;

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

    final camera = await mapboxMap.cameraForCoordinateBounds(
      bounds,
      MbxEdgeInsets(
        top: 140,
        left: 100,
        bottom: MediaQuery.sizeOf(context).height * 0.55,
        right: 100,
      ),
      null,
      null,
      null,
      null,
    );

    if (!mounted || _mapboxMap == null) return;

    await mapboxMap.flyTo(
      CameraOptions(
        center: camera.center,
        zoom: (camera.zoom ?? 12).clamp(3.0, 18.0),
        bearing: camera.bearing,
        pitch: 0,
      ),
      MapAnimationOptions(duration: 1000),
    );
  }

  // CONFIGURE PICKUP MARKER :
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
        circleColor: AppColors.accent.toARGB32(),
        circleRadius: 10,
        circleStrokeColor: CupertinoColors.white.toARGB32(),
        circleStrokeWidth: 3,
      ),
    );
  }

  @override
  void dispose() {
    // Verification Code :
    _codeController.dispose();
    _codeFocusNode.dispose();

    super.dispose();
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
                    pulsingColor: AppColors.accent.toARGB32(),
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
                      _showPickupModal(widget.mode);
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
                _showPickupModal(widget.mode);
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
                    color: AppColors.backgroundwhite,
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
