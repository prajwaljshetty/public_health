import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:public_health/Providers/User/user.dart';

// Map
import 'package:public_health/Theme/theme.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

// Language
import 'package:public_health/l10n/app_localizations.dart';

// Request Confirmation
import 'package:public_health/App/Workers/pickupacceptanceconfirmation.dart';

// Assets
import 'package:public_health/assetmaper.dart';

// Provider
import 'package:provider/provider.dart';
import 'package:public_health/Providers/Location/location.dart';

// Services :
import 'package:public_health/Services/API/Workers/api_service.dart';

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

  bool _isMapReady = false;
  bool _mapLoaded = false;
  bool _styleLoaded = false;
  bool _markerReady = false;
  bool _initializationStarted = false;

  bool _isRequesting = false;

  final TextEditingController _codeController = TextEditingController();
  final FocusNode _codeFocusNode = FocusNode();

  String get _verificationCode => _codeController.text;

  bool get _isCodeComplete => _verificationCode.length == 6;

  Future<void> _confirmCollection(
    String code,
    StateSetter setModalState,
  ) async {
    if (_isRequesting) return;

    setModalState(() {
      _isRequesting = true;
    });

    try {
      final userProvider = context.read<UserProvider>();

      final response = await ApiService.confirmCollection(
        pickupid: widget.pickupId,
        code: code,
        userprovider: userProvider,
      );

      if (!mounted) return;

      if (response['status'] == true) {
        // Handle successful collection
      } else {
        // Handle API error
      }
    } finally {
      if (mounted) {
        setModalState(() {
          _isRequesting = false;
        });
      }
    }
  }

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
                    color: AppColors.backgroundwhite,
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(19),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      _receiptDetail(
                        label: l10n.requestedTimeLabel,
                        value: pickupTime,
                      ),
                      const SizedBox(height: 12),
                      const AppDashedDivider(),
                      const SizedBox(height: 12),
                      _receiptDetail(
                        label: l10n.distanceLabel,
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
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
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
                                  l10n.verifyPickup,
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
                                    height: 180,
                                    width: 180,
                                    fit: BoxFit.contain,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    l10n.scanHouseholdQrCode,
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
                                      l10n.scanHouseholdQrInstructions,
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
                            AppPrimaryButton(
                              isLoading: _isRequesting,
                              text: l10n.scanQrCode,
                              loadingText: l10n.pleaseWait,
                              onPressed: () {},
                            ),
                            const SizedBox(height: 10),
                            if (!_isRequesting)
                              SizedBox(
                                width: double.infinity,
                                child: CupertinoButton(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 13,
                                  ),
                                  color: AppColors.backgroundwhite,
                                  borderRadius: BorderRadius.circular(14),
                                  onPressed: () {
                                    _codeController.clear();
                                    _codeFocusNode.unfocus();

                                    _codeDailogBox(
                                      modalContext,
                                      l10n,
                                      setModalState,
                                    );

                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                          if (modalContext.mounted) {
                                            _codeFocusNode.requestFocus();
                                          }
                                        });
                                  },
                                  child: Text(
                                    l10n.tryAnotherWay,
                                    style: AppText.cardTitle.copyWith(
                                      fontSize: 15,
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

  void _codeDailogBox(
    BuildContext modalContext,
    AppLocalizations l10n,
    StateSetter setModalState,
  ) {
    showCupertinoDialog(
      context: modalContext,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AnimatedPadding(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(dialogContext).viewInsets.bottom / 2,
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 14),
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundwhite,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 16),
                        const SizedBox(height: 8),
                        Text(
                          l10n.enterPickupVerificationCode,
                          textAlign: TextAlign.center,
                          style: AppText.cardSubtitle.copyWith(height: 1.5),
                        ),
                        const SizedBox(height: 24),
                        GestureDetector(
                          onTap: () {
                            _codeFocusNode.requestFocus();
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: List.generate(6, (index) {
                                  final code = _codeController.text;
                                  final hasValue = index < code.length;
                                  final isActive =
                                      index == code.length && code.length < 6;

                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 160),
                                    width: 48,
                                    height: 48,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: AppColors.backgroundwhite,
                                      border: Border.all(
                                        color: isActive
                                            ? AppColors.accent
                                            : AppColors.backgroundblack,
                                        width: isActive ? 1.8 : 1.2,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      hasValue ? code[index] : '',
                                      style: AppText.cardTitle.copyWith(
                                        fontSize: 20,
                                      ),
                                    ),
                                  );
                                }),
                              ),
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
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    enableInteractiveSelection: false,
                                    decoration: const BoxDecoration(),
                                    onChanged: (_) {
                                      setDialogState(() {});
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 26),
                        SizedBox(
                          width: double.infinity,
                          child: CupertinoButton(
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            color: _isCodeComplete
                                ? AppColors.accent
                                : AppColors.layering,
                            borderRadius: BorderRadius.circular(13),
                            onPressed: _isCodeComplete
                                ? () {
                                    final code = _verificationCode;
                                    _confirmCollection(code, setModalState);
                                    Navigator.pop(dialogContext);
                                  }
                                : null,
                            child: Text(
                              l10n.verifyCode,
                              style: TextStyle(
                                color: AppColors.backgroundwhite,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        CupertinoButton(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            _codeController.clear();
                            _codeFocusNode.unfocus();
                          },
                          child: Text(
                            l10n.cancel,
                            style: AppText.cardSubtitle.copyWith(
                              color: AppColors.backgroundblack,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
      _codeController.clear();
      _codeFocusNode.unfocus();
    });
  }

  void _showPickupModal(MapViewMode mode) {
    if (isModalOpen || !_isMapReady) return;

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

  Future<void> _onMapLoaded() async {
    _mapLoaded = true;
    await _initializeMap();
  }

  Future<void> _onStyleLoaded() async {
    try {
      await _configurePickupMarker();

      if (!mounted) return;

      _styleLoaded = true;
      _markerReady = true;

      await _initializeMap();
    } catch (_) {}
  }

  Future<void> _initializeMap() async {
    if (!mounted ||
        !_mapLoaded ||
        !_styleLoaded ||
        !_markerReady ||
        _initializationStarted) {
      return;
    }

    _initializationStarted = true;

    try {
      await _moveCamera();

      if (!mounted) return;

      setState(() {
        _isMapReady = true;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _showPickupModal(widget.mode);
      });
    } catch (_) {}
  }

  Future<void> _moveCamera() async {
    final mapboxMap = _mapboxMap;
    if (mapboxMap == null || !mounted) return;

    final position = context.read<LocationProvider>().position;
    if (position == null) return;

    final screenSize = MediaQuery.sizeOf(context);

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
        top: 110,
        left: 65,
        bottom: screenSize.height * 0.48,
        right: 65,
      ),
      0,
      0,
      17,
      null,
    );

    if (!mounted || _mapboxMap == null) return;

    await mapboxMap.flyTo(
      CameraOptions(
        center: camera.center,
        zoom: camera.zoom,
        bearing: 0,
        pitch: 0,
      ),
      MapAnimationOptions(duration: 1200),
    );
  }

  Future<void> _configurePickupMarker() async {
    final mapboxMap = _mapboxMap;

    if (mapboxMap == null) {
      return;
    }

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
          SizedBox.expand(
            child: MapWidget(
              styleUri: 'mapbox://styles/spotmap-app/cmoa88xof000z01sacg9b4om8',
              onMapCreated: (MapboxMap mapboxMap) async {
                _mapboxMap = mapboxMap;

                try {
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
                        coordinates: Position(
                          widget.longitude,
                          widget.latitude,
                        ),
                      ),
                      zoom: 18,
                    ),
                  );
                } catch (_) {}
              },
              onStyleLoadedListener: (_) {
                _onStyleLoaded();
              },
              onMapLoadedListener: (_) {
                _onMapLoaded();
              },
            ),
          ),
          if (!_isMapReady)
            Positioned.fill(
              child: Container(
                color: AppColors.backgroundwhite,
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 32,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundwhite,
                      border: Border.all(
                        color: AppColors.backgroundblack,
                        width: 1.2,
                      ),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 76,
                          height: 76,
                          decoration: BoxDecoration(
                            color: AppColors.backgroundwhite,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: AppColors.backgroundblack,
                              width: 1,
                            ),
                          ),
                          child: const Center(
                            child: CupertinoActivityIndicator(
                              radius: 17,
                              color: AppColors.accent,
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        const Text(
                          'Preparing your map',
                          textAlign: TextAlign.center,
                          style: AppText.cardTitle,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Finding your location and loading pickup details...',
                          textAlign: TextAlign.center,
                          style: AppText.cardSubtitle,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          if (_isMapReady) ...[
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
            Positioned(
              bottom: 30,
              right: 16,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () async {
                  if (widget.mode == MapViewMode.discover) {
                    await _moveCamera();

                    if (!mounted) return;

                    _showPickupModal(widget.mode);
                  } else {
                    _showPickupModal(widget.mode);
                  }
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
                    widget.mode == MapViewMode.discover
                        ? l10n.pickupDetails
                        : l10n.scanQrCode,
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
        ],
      ),
    );
  }
}
