import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// Map
import 'package:public_health/Theme/theme.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

// Language
import 'package:public_health/l10n/app_localizations.dart';

// Request Confirmation
import 'package:public_health/App/Workers/pickupacceptanceconfirmation.dart';

// Assets
import 'package:public_health/assetmaper.dart';

// Lottie :
import 'package:lottie/lottie.dart';

// QR Scanner :
import 'package:mobile_scanner/mobile_scanner.dart';

// Provider
import 'package:provider/provider.dart';
import 'package:public_health/Providers/User/user.dart';
import 'package:public_health/Providers/Navigation/location.dart';
import 'package:public_health/Providers/Navigation/navigation.dart';
import 'package:public_health/Services/Navigation/directions.dart';
import 'package:public_health/Services/Navigation/custom_navigation.dart';
import 'package:public_health/App/Workers/Map/navigationoverlay.dart';

// Services :
import 'package:public_health/Services/API/Workers/api_service.dart';

enum MapViewMode { discover, accepted }

enum AcceptedModalState { idle, scanning, success }

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
  static const _pickupSourceId = 'pickup-source';
  static const _pickupLayerId = 'pickup-layer';
  static const _routeSourceId = 'navigation-route-source';
  static const _routeLayerId = 'navigation-route-layer';

  static const _emptyFeatureCollection =
      '{"type":"FeatureCollection","features":[]}';

  static const _routeDrawThrottle = Duration(milliseconds: 700);
  static const _cameraFollowThrottle = Duration(milliseconds: 1100);

  // Map
  MapboxMap? _mapboxMap;
  GeoJsonSource? _routeSource;

  bool _mapLoaded = false;
  bool _styleLoaded = false;
  bool _markerReady = false;
  bool _initializationStarted = false;
  bool _isMapReady = false;

  // Navigation
  CustomNavigationController? _customNavigationController;
  LocationProvider? _navigationLocationProvider;

  bool _navigationStarted = false;
  bool _isDrawingNavigationRoute = false;
  bool _isFollowingCamera = false;

  DateTime _lastRouteDrawAt = DateTime.fromMillisecondsSinceEpoch(0);
  DateTime _lastCameraFollowAt = DateTime.fromMillisecondsSinceEpoch(0);

  // Pickup modal / collection verification
  bool _isModalOpen = false;
  bool _isRequesting = false;
  bool _isScanned = false;

  AcceptedModalState _modalState = AcceptedModalState.idle;
  String? _collectionError;

  MobileScannerController? _scannerController;

  final TextEditingController _codeController = TextEditingController();
  final FocusNode _codeFocusNode = FocusNode();

  String get _verificationCode => _codeController.text;
  bool get _isCodeComplete => _verificationCode.length == 6;

  AppLocalizations get _l10n => AppLocalizations.of(context)!;

  @override
  void dispose() {
    _navigationLocationProvider?.removeListener(_onLocationChanged);
    _customNavigationController?.removeListener(_onCustomNavigationChanged);
    _customNavigationController?.dispose();
    _codeController.dispose();
    _codeFocusNode.dispose();
    super.dispose();
  }

  String _formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.round()} m';
    }

    return '${(meters / 1000).toStringAsFixed(1)} km';
  }

  String _formatDuration(double seconds) {
    final totalMinutes = (seconds / 60).ceil();

    if (totalMinutes < 60) {
      return '$totalMinutes min';
    }

    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;

    return minutes == 0 ? '${hours}h' : '${hours}h ${minutes}m';
  }

  double _calculateBearing({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    final lat1 = startLatitude * pi / 180;
    final lat2 = endLatitude * pi / 180;
    final deltaLongitude = (endLongitude - startLongitude) * pi / 180;

    final y = sin(deltaLongitude) * cos(lat2);

    final x =
        cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(deltaLongitude);

    final bearing = atan2(y, x) * 180 / pi;

    return (bearing + 360) % 360;
  }

  bool _isValidCode(String code) {
    return RegExp(r'^\d{6}$').hasMatch(code);
  }

  String _pointGeoJson(double latitude, double longitude) {
    return jsonEncode({
      'type': 'FeatureCollection',
      'features': [
        {
          'type': 'Feature',
          'geometry': {
            'type': 'Point',
            'coordinates': [longitude, latitude],
          },
          'properties': {},
        },
      ],
    });
  }

  String _lineStringGeoJson(List<dynamic> coordinates) {
    return jsonEncode({
      'type': 'FeatureCollection',
      'features': [
        {
          'type': 'Feature',
          'geometry': {'type': 'LineString', 'coordinates': coordinates},
          'properties': {},
        },
      ],
    });
  }

  Future<void> _showAlert({String? title, required String content}) {
    return showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: title == null ? null : Text(title),
        content: Text(content),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(_l10n.okButton),
          ),
        ],
      ),
    );
  }

  Future<void> _onMapCreated(MapboxMap mapboxMap) async {
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
            coordinates: Position(widget.longitude, widget.latitude),
          ),
          zoom: 18,
        ),
      );
    } catch (_) {}
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

  Future<void> _configurePickupMarker() async {
    final mapboxMap = _mapboxMap;

    if (mapboxMap == null) return;

    // Pickup marker
    await mapboxMap.addSource(
      GeoJsonSource(
        id: _pickupSourceId,
        data: _pointGeoJson(widget.latitude, widget.longitude),
      ),
    );

    await mapboxMap.addLayer(
      CircleLayer(
        id: _pickupLayerId,
        sourceId: _pickupSourceId,
        circleColor: AppColors.accent.toARGB32(),
        circleRadius: 10,
        circleStrokeColor: CupertinoColors.white.toARGB32(),
        circleStrokeWidth: 3,
      ),
    );

    _routeSource = GeoJsonSource(
      id: _routeSourceId,
      data: _emptyFeatureCollection,
    );

    await mapboxMap.addSource(_routeSource!);

    await mapboxMap.addLayer(
      LineLayer(
        id: _routeLayerId,
        sourceId: _routeSourceId,
        lineColor: AppColors.accent.toARGB32(),
        lineWidth: 6,
        lineCap: LineCap.ROUND,
        lineJoin: LineJoin.ROUND,
      ),
    );
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

      await _loadRoutePreview();

      if (!mounted) return;

      setState(() {
        _isMapReady = true;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _showPickupModal(widget.mode);
      });
    } catch (_) {
      _initializationStarted = false;
    }
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

    final bearing = _calculateBearing(
      startLatitude: position.latitude,
      startLongitude: position.longitude,
      endLatitude: widget.latitude,
      endLongitude: widget.longitude,
    );

    final camera = await mapboxMap.cameraForCoordinateBounds(
      bounds,
      MbxEdgeInsets(
        top: 110,
        left: 65,
        bottom: screenSize.height * 0.48,
        right: 65,
      ),
      bearing,
      0,
      17,
      null,
    );

    if (!mounted || _mapboxMap == null) return;

    await mapboxMap.flyTo(
      CameraOptions(
        center: camera.center,
        zoom: camera.zoom,
        bearing: bearing,
        pitch: 0,
      ),
      MapAnimationOptions(duration: 1200),
    );
  }

  Future<void> _loadRoutePreview() async {
    final l10n = AppLocalizations.of(context)!;
    final position = context.read<LocationProvider>().position;
    final routeSource = _routeSource;

    if (position == null || routeSource == null) return;

    final navigationProvider = context.read<NavigationProvider>();

    try {
      await navigationProvider.startNavigation(
        languageCode: l10n.localeName,
        originLatitude: position.latitude,
        originLongitude: position.longitude,
        destinationLatitude: widget.latitude,
        destinationLongitude: widget.longitude,
      );

      if (!mounted) return;

      final route = navigationProvider.route;

      if (route == null || route.coordinates.length < 2) return;

      await routeSource.updateGeoJSON(_lineStringGeoJson(route.coordinates));

      if (mounted) {
        setState(() {});
      }
    } catch (_) {}
  }

  Future<void> _restoreRoutePreview() async {
    final route = context.read<NavigationProvider>().route;
    final source = _routeSource;
    if (route == null || source == null || route.coordinates.length < 2) return;

    try {
      await source.updateGeoJSON(_lineStringGeoJson(route.coordinates));
    } catch (error) {
      debugPrint('Unable to restore route preview: $error');
    }
  }

  Future<void> _startCustomNavigation() async {
    final l10n = AppLocalizations.of(context)!;
    final locationProvider = context.read<LocationProvider>();
    final position = locationProvider.position;

    if (position == null) {
      _showAlert(
        title: _l10n.locationUnavailable,
        content: _l10n.currentLocationUnavailable,
      );
      return;
    }

    _navigationLocationProvider = locationProvider;

    final controller = CustomNavigationController(
      languageCode: l10n.localeName,
      directionsService: DirectionsService(),
      destinationLatitude: widget.latitude,
      destinationLongitude: widget.longitude,
      onSpeak: (instruction) => debugPrint('Navigation: $instruction'),
    );

    _customNavigationController = controller;
    controller.addListener(_onCustomNavigationChanged);
    locationProvider.addListener(_onLocationChanged);

    setState(() => _navigationStarted = true);

    try {
      await controller.start(position.latitude, position.longitude);

      if (!mounted) return;

      controller.onLocation(
        position.latitude,
        position.longitude,
        accuracy: position.accuracy,
      );

      await _drawRemainingRoute(force: true);
      await _followNavigationCamera(force: true);
    } catch (error) {
      if (!mounted) return;

      _endCustomNavigation(restorePreview: true);

      _showAlert(
        title: _l10n.unableToStartNavigation,
        content: error.toString(),
      );
    }
  }

  void _onLocationChanged() {
    final position = _navigationLocationProvider?.position;
    final controller = _customNavigationController;

    if (position == null || controller == null) return;

    controller.onLocation(
      position.latitude,
      position.longitude,
      accuracy: position.accuracy,
    );
  }

  void _onCustomNavigationChanged() {
    if (!mounted) return;

    setState(() {});
    unawaited(_drawRemainingRoute());
    unawaited(_followNavigationCamera());
  }

  Future<void> _drawRemainingRoute({bool force = false}) async {
    final controller = _customNavigationController;
    final source = _routeSource;

    if (controller == null || source == null || _isDrawingNavigationRoute) {
      return;
    }

    final now = DateTime.now();
    if (!force && now.difference(_lastRouteDrawAt) < _routeDrawThrottle) return;

    final coordinates = controller.remainingCoordinates;
    if (coordinates.length < 2) return;

    _isDrawingNavigationRoute = true;
    _lastRouteDrawAt = now;

    try {
      await source.updateGeoJSON(_lineStringGeoJson(coordinates));
    } catch (error) {
      debugPrint('Unable to update navigation route: $error');
    } finally {
      _isDrawingNavigationRoute = false;
    }
  }

  Future<void> _followNavigationCamera({bool force = false}) async {
    final map = _mapboxMap;
    final controller = _customNavigationController;

    if (map == null || controller == null || _isFollowingCamera) return;

    if (controller.status != NavStatus.navigating &&
        controller.status != NavStatus.rerouting &&
        controller.status != NavStatus.arrived) {
      return;
    }

    final now = DateTime.now();
    if (!force && now.difference(_lastCameraFollowAt) < _cameraFollowThrottle) {
      return;
    }

    _isFollowingCamera = true;
    _lastCameraFollowAt = now;

    try {
      await map.flyTo(
        CameraOptions(
          center: Point(
            coordinates: Position(
              controller.snappedLongitude,
              controller.snappedLatitude,
            ),
          ),
          zoom: 15,
          bearing: controller.bearing,
          pitch: 0,
        ),
        MapAnimationOptions(duration: 850),
      );
    } catch (error) {
      debugPrint('Unable to follow navigation camera: $error');
    } finally {
      _isFollowingCamera = false;
    }
  }

  Future<void> _recenterNavigation() async {
    await _followNavigationCamera(force: true);
  }

  void _endCustomNavigation({bool restorePreview = true}) {
    final controller = _customNavigationController;
    final locationProvider = _navigationLocationProvider;

    locationProvider?.removeListener(_onLocationChanged);
    controller?.removeListener(_onCustomNavigationChanged);
    controller?.stop();
    controller?.dispose();

    _customNavigationController = null;
    _navigationLocationProvider = null;
    _navigationStarted = false;
    _isDrawingNavigationRoute = false;
    _isFollowingCamera = false;

    if (mounted) setState(() {});
    if (restorePreview) unawaited(_restoreRoutePreview());
  }

  void _showPickupModal(MapViewMode mode) {
    if (_isModalOpen || !_isMapReady) return;

    _isModalOpen = true;

    switch (mode) {
      case MapViewMode.discover:
        _showDiscoverModal();
        break;

      case MapViewMode.accepted:
        _showAcceptedModal();
        break;
    }
  }

  void _showDiscoverModal() {
    final pickupTime = DateFormat(
      'dd MMM yyyy, hh:mm a',
      _l10n.localeName,
    ).format(DateTime.parse(widget.time));

    showCupertinoModalPopup(
      context: context,
      builder: (_) => _buildDiscoverModal(pickupTime),
    ).whenComplete(() {
      _isModalOpen = false;
    });
  }

  void _openPickupAcceptance() {
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
  }

  Future<void> _copyPickupId() async {
    await Clipboard.setData(ClipboardData(text: widget.pickupId));

    if (!mounted) return;

    _showAlert(content: _l10n.pickupIdCopied);
  }

  Widget _buildDiscoverModal(String pickupTime) {
    final l10n = _l10n;

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
                    value: widget.username,
                  ),
                  _receiptDivider(),
                  _buildPickupIdRow(),
                  _receiptDivider(),
                  _receiptDetail(
                    label: l10n.requestedTimeLabel,
                    value: pickupTime,
                  ),
                  _receiptDivider(),
                  _receiptDetail(
                    label: l10n.distanceLabel,
                    value: _formatDistance(widget.distance),
                  ),
                  const SizedBox(height: 18),
                ],
              ),
            ),
            const SizedBox(height: 14),
            AppPrimaryButton(
              text: l10n.acceptPickup,
              onPressed: _openPickupAcceptance,
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }

  Widget _receiptDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: AppDashedDivider(),
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
            style: AppText.cardSubtitle.copyWith(color: AppColors.textPrimary),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppText.label.copyWith(
              fontSize: 14,
              height: 1.4,
              color: AppColors.accent,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPickupIdRow() {
    final id = widget.pickupId;
    final shortPickupId = id.length > 20 ? '${id.substring(0, 20)}...' : id;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            _l10n.pickupIdLabel,
            style: AppText.cardSubtitle.copyWith(color: AppColors.textPrimary),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
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
                    color: AppColors.accent,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              CupertinoButton(
                padding: EdgeInsets.zero,
                minimumSize: ui.Size.zero,
                onPressed: _copyPickupId,
                child: const Icon(
                  CupertinoIcons.doc_on_doc,
                  size: 14,
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showAcceptedModal() {
    _codeController.clear();
    _codeFocusNode.unfocus();

    _modalState = AcceptedModalState.idle;
    _collectionError = null;

    showCupertinoModalPopup(
      context: context,
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return _buildAcceptedModal(modalContext, setModalState);
          },
        );
      },
    ).whenComplete(_disposeAcceptedModal);
  }

  Future<void> _disposeAcceptedModal() async {
    await _disposeScanner();

    if (!mounted) return;

    setState(() {
      _isModalOpen = false;
      _modalState = AcceptedModalState.idle;
      _collectionError = null;
      _isRequesting = false;
    });

    _isScanned = false;
    _codeController.clear();
    _codeFocusNode.unfocus();
  }

  Future<void> _startScanner(StateSetter setModalState) async {
    if (_modalState != AcceptedModalState.idle || _isRequesting) {
      return;
    }

    _isScanned = false;

    _scannerController = MobileScannerController(
      formats: [BarcodeFormat.qrCode],
      autoTorch: true,
      facing: CameraFacing.back,
    );

    setModalState(() {
      _collectionError = null;
      _modalState = AcceptedModalState.scanning;
    });
  }

  Future<void> _stopScanner(StateSetter setModalState) async {
    await _disposeScanner();

    _isScanned = false;

    setModalState(() {
      _modalState = AcceptedModalState.idle;
    });
  }

  Future<void> _disposeScanner() async {
    final controller = _scannerController;
    _scannerController = null;

    await controller?.dispose();
  }

  Future<void> _handleScannedCode(
    String code,
    BuildContext modalContext,
    StateSetter setModalState,
  ) async {
    if (_modalState != AcceptedModalState.scanning ||
        _isRequesting ||
        _isScanned ||
        !_isValidCode(code)) {
      return;
    }

    _isScanned = true;

    await _verifyCode(code, modalContext, setModalState);
  }

  Future<void> _verifyCode(
    String code,
    BuildContext modalContext,
    StateSetter setModalState,
  ) async {
    if (_isRequesting || _modalState == AcceptedModalState.success) {
      return;
    }

    _isScanned = true;

    await _disposeScanner();

    if (!mounted || !modalContext.mounted) return;

    setModalState(() {
      _modalState = AcceptedModalState.idle;
      _collectionError = null;
    });

    final success = await _confirmCollection(code, setModalState);

    if (!mounted || !modalContext.mounted) return;

    setModalState(() {
      _modalState = success
          ? AcceptedModalState.success
          : AcceptedModalState.idle;

      if (success) {
        _collectionError = null;
      }
    });

    _isScanned = false;
  }

  Future<bool> _confirmCollection(
    String code,
    StateSetter setModalState,
  ) async {
    setModalState(() {
      _isRequesting = true;
      _collectionError = null;
    });

    try {
      final userProvider = context.read<UserProvider>();

      final response = await ApiService.confirmCollection(
        pickupid: widget.pickupId,
        code: code,
        userprovider: userProvider,
      );

      if (!mounted) return false;

      if (response['status'] != true) {
        setModalState(() {
          _collectionError = _mapCollectionError(response['code']);
        });

        return false;
      }

      return true;
    } catch (e) {
      if (!mounted) return false;

      setModalState(() {
        _collectionError = _l10n.serverConnectionError;
      });

      return false;
    } finally {
      if (mounted) {
        setModalState(() {
          _isRequesting = false;
        });
      }
    }
  }

  String _mapCollectionError(Object? code) {
    final l10n = _l10n;

    return switch (code) {
      'INVALID_PICKUP_CODE' ||
      'INCORRECT_PICKUP_CODE' => l10n.incorrectVerificationCode,

      'PICKUP_CODE_NOT_GENERATED' => l10n.verificationCodeUnavailable,

      'PICKUP_NOT_AVAILABLE_FOR_COLLECTION' ||
      'PICKUP_NOT_ACCEPTED' => l10n.pickupNoLongerAvailable,

      'PICKUP_NOT_ASSIGNED_TO_WORKER' ||
      'INSUFFICIENT_PERMISSIONS' => l10n.unauthorizedCollection,

      'COLLECTION_ALREADY_PENDING' ||
      'COLLECTION_PENDING_SYNC' => l10n.collectionAlreadyProcessing,

      'NETWORK_ERROR' => l10n.serverConnectionError,

      'INVALID_RESPONSE' => l10n.invalidServerResponse,

      _ => l10n.collectionVerificationFailed,
    };
  }

  Widget _buildAcceptedModal(
    BuildContext modalContext,
    StateSetter setModalState,
  ) {
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
              _buildVerificationCard(modalContext, setModalState),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerificationCard(
    BuildContext modalContext,
    StateSetter setModalState,
  ) {
    final isScanning = _modalState == AcceptedModalState.scanning;
    final isSuccess = _modalState == AcceptedModalState.success;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.backgroundwhite,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.backgroundblack, width: 1.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildVerificationHeader(isSuccess),
          const SizedBox(height: 18),
          _buildVerificationContent(
            modalContext,
            setModalState,
            isScanning,
            isSuccess,
          ),
          const SizedBox(height: 12),
          _buildVerificationActions(
            modalContext,
            setModalState,
            isScanning,
            isSuccess,
          ),
          if (_collectionError != null && !isSuccess) _buildCollectionError(),
        ],
      ),
    );
  }

  Widget _buildVerificationHeader(bool isSuccess) {
    final l10n = _l10n;

    return Row(
      children: [
        const Icon(
          CupertinoIcons.cube_box_fill,
          color: AppColors.boxyellow,
          size: 33,
        ),
        const SizedBox(width: 10),
        Text(
          isSuccess ? l10n.collectionConfirmed : l10n.verifyPickup,
          style: AppText.cardTitle.copyWith(fontSize: 19),
        ),
      ],
    );
  }

  Widget _buildVerificationContent(
    BuildContext modalContext,
    StateSetter setModalState,
    bool isScanning,
    bool isSuccess,
  ) {
    final l10n = _l10n;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        color: AppColors.backgroundwhite,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppColors.backgroundblack, width: 1.3),
      ),
      child: Column(
        children: [
          if (isSuccess)
            _buildSuccessContent()
          else if (isScanning && _scannerController != null)
            _buildScannerPreview(modalContext, setModalState)
          else if (_isRequesting)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 55),
              child: CupertinoActivityIndicator(radius: 18),
            )
          else
            Image.asset(
              AssetMapper.qrCode,
              height: 180,
              width: 180,
              fit: BoxFit.contain,
            ),

          if (!isSuccess) ...[
            const SizedBox(height: 16),
            Text(
              _isRequesting
                  ? l10n.verifyingCollection
                  : l10n.scanHouseholdQrCode,
              textAlign: TextAlign.center,
              style: AppText.cardTitle.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                isScanning
                    ? l10n.positionQrCode
                    : _isRequesting
                    ? l10n.verifyingCodeMessage
                    : l10n.scanHouseholdQrInstructions,
                textAlign: TextAlign.center,
                style: AppText.cardSubtitle.copyWith(height: 1.5),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSuccessContent() {
    final l10n = _l10n;

    return Column(
      children: [
        const SizedBox(height: 20),
        Lottie.asset(
          AssetMapper.pickupConfirmed,
          width: 100,
          height: 100,
          fit: BoxFit.contain,
          repeat: false,
        ),
        const SizedBox(height: 18),
        Text(
          l10n.pickupCollectedSuccessfully,
          textAlign: TextAlign.center,
          style: AppText.cardTitle.copyWith(fontSize: 17),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.collectionVerifiedMessage,
          textAlign: TextAlign.center,
          style: AppText.cardSubtitle.copyWith(height: 1.5),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildScannerPreview(
    BuildContext modalContext,
    StateSetter setModalState,
  ) {
    return Center(
      child: SizedBox(
        width: 280,
        height: 280,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: MobileScanner(
            controller: _scannerController!,
            onDetect: (capture) {
              if (_isScanned || capture.barcodes.isEmpty) {
                return;
              }

              final value = capture.barcodes.first.rawValue ?? '';

              _handleScannedCode(value, modalContext, setModalState);
            },
            errorBuilder: (context, error) => _buildScannerError(error),
          ),
        ),
      ),
    );
  }

  Widget _buildScannerError(MobileScannerException error) {
    final l10n = _l10n;

    return Container(
      color: CupertinoColors.black,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            CupertinoIcons.exclamationmark_circle,
            color: CupertinoColors.white,
            size: 32,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.cameraUnavailable,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: CupertinoColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.errorDetails?.message ?? l10n.unableToAccessCamera,
            textAlign: TextAlign.center,
            style: const TextStyle(color: CupertinoColors.white, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationActions(
    BuildContext modalContext,
    StateSetter setModalState,
    bool isScanning,
    bool isSuccess,
  ) {
    final l10n = _l10n;

    if (isSuccess) {
      return AppPrimaryButton(
        text: l10n.done,
        onPressed: () {
          Navigator.of(modalContext).pop();
          Navigator.of(context).pop(true);
        },
      );
    }

    return Column(
      children: [
        AppPrimaryButton(
          isLoading: _isRequesting,
          text: isScanning ? l10n.cancel : l10n.scanQrCode,
          loadingText: l10n.pleaseWait,
          onPressed: () {
            if (_isRequesting) return;

            if (isScanning) {
              _stopScanner(setModalState);
            } else {
              _startScanner(setModalState);
            }
          },
        ),

        if (!isScanning && !_isRequesting) ...[
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: CupertinoButton(
              padding: const EdgeInsets.symmetric(vertical: 13),
              color: AppColors.backgroundwhite,
              borderRadius: BorderRadius.circular(14),
              onPressed: () {
                _codeController.clear();
                _codeFocusNode.unfocus();

                _showCodeDialog(modalContext, (code) async {
                  await _verifyCode(code, modalContext, setModalState);
                });

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (modalContext.mounted) {
                    _codeFocusNode.requestFocus();
                  }
                });
              },
              child: Text(
                l10n.tryAnotherWay,
                style: AppText.cardTitle.copyWith(fontSize: 15),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCollectionError() {
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Center(
        child: Text(
          _collectionError!,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            color: CupertinoColors.systemRed,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _showCodeDialog(
    BuildContext modalContext,
    Future<void> Function(String code) onVerify,
  ) {
    final l10n = _l10n;

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
                        const SizedBox(height: 24),
                        Text(
                          l10n.enterPickupVerificationCode,
                          textAlign: TextAlign.center,
                          style: AppText.cardSubtitle.copyWith(height: 1.5),
                        ),
                        const SizedBox(height: 24),
                        _buildCodeInput(setDialogState),
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

                                    Navigator.pop(dialogContext);
                                    onVerify(code);
                                  }
                                : null,
                            child: Text(
                              l10n.verifyCode,
                              style: const TextStyle(
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

  Widget _buildCodeInput(StateSetter setDialogState) {
    return GestureDetector(
      onTap: _codeFocusNode.requestFocus,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) {
              final code = _codeController.text;
              final hasValue = index < code.length;
              final isActive = index == code.length && code.length < 6;

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
                  style: AppText.cardTitle.copyWith(fontSize: 20),
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
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                autofillHints: const [AutofillHints.oneTimeCode],
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                enableInteractiveSelection: false,
                decoration: const BoxDecoration(),
                onChanged: (_) => setDialogState(() {}),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutePreview() {
    return Consumer<NavigationProvider>(
      builder: (context, navigationProvider, _) {
        final route = navigationProvider.route;

        if (route == null) return const SizedBox.shrink();

        final eta = DateTime.now().add(
          Duration(seconds: route.duration.round()),
        );

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.backgroundwhite,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRouteHeader(),
              const SizedBox(height: 18),
              _buildRouteStats(
                duration: route.duration,
                distance: route.distance,
                eta: eta,
              ),
              const SizedBox(height: 18),
              _buildRouteActions(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRouteHeader() {
    final l10n = _l10n;

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.backgroundwhite,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.backgroundblack, width: 1.2),
          ),
          child: const Icon(
            CupertinoIcons.location_fill,
            color: AppColors.accent,
            size: 23,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.routeDetails,
                style: AppText.cardTitle.copyWith(fontSize: 17),
              ),
              const SizedBox(height: 4),
              Text(l10n.pickupRouteReady, style: AppText.cardSubtitle),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRouteStats({
    required double duration,
    required double distance,
    required DateTime eta,
  }) {
    final l10n = _l10n;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.backgroundwhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.backgroundblack, width: 1.1),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildRouteMetric(
              value: _formatDuration(duration),
              label: l10n.estimatedArrival,
            ),
          ),
          Container(width: 1, height: 42, color: AppColors.backgroundblack),
          Expanded(
            child: _buildRouteMetric(
              value: _formatDistance(distance),
              label: l10n.roadDistance,
            ),
          ),
          Container(width: 1, height: 42, color: AppColors.backgroundblack),
          Expanded(
            child: _buildRouteMetric(
              value: DateFormat('h:mm a').format(eta),
              label: l10n.arrival,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteMetric({required String value, required String label}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.title.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.cardSubtitle.copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteActions() {
    final l10n = _l10n;

    return Row(
      children: [
        Expanded(
          child: _buildRouteActionButton(
            icon: CupertinoIcons.location_north_fill,
            label: l10n.startNavigation,
            onPressed: _startCustomNavigation,
          ),
        ),
        if (widget.mode == MapViewMode.accepted) ...[
          const SizedBox(width: 10),
          Expanded(
            child: _buildRouteActionButton(
              icon: CupertinoIcons.qrcode,
              label: l10n.scanQrCode,
              onPressed: () => _showPickupModal(widget.mode),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRouteActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return CupertinoButton(
      color: AppColors.accent,
      borderRadius: BorderRadius.circular(15),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: CupertinoColors.white, size: 17),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: CupertinoColors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          SizedBox.expand(child: _buildMap()),
          if (!_isMapReady) Positioned.fill(child: _buildLoadingOverlay()),
          if (_isMapReady) ...[_buildBackButton(), ..._buildBottomOverlays()],
        ],
      ),
    );
  }

  Widget _buildMap() {
    return MapWidget(
      styleUri: 'mapbox://styles/mapbox/outdoors-v12',
      //styleUri: 'mapbox://styles/mapbox/navigation-day-v1',
      onMapCreated: _onMapCreated,
      onStyleLoadedListener: (_) => _onStyleLoaded(),
      onMapLoadedListener: (_) => _onMapLoaded(),
    );
  }

  Widget _buildLoadingOverlay() {
    final l10n = _l10n;

    return Container(
      color: AppColors.backgroundwhite,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          decoration: BoxDecoration(
            color: AppColors.backgroundwhite,
            border: Border.all(color: AppColors.backgroundblack, width: 1.2),
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
              Text(
                l10n.preparingMap,
                textAlign: TextAlign.center,
                style: AppText.cardTitle,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.loadingMapDescription,
                textAlign: TextAlign.center,
                style: AppText.cardSubtitle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Positioned(
      top: 55,
      left: 16,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () => Navigator.pop(context),
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.backgroundwhite,
            borderRadius: BorderRadius.circular(21),
          ),
          child: const Icon(CupertinoIcons.back, color: CupertinoColors.black),
        ),
      ),
    );
  }

  List<Widget> _buildBottomOverlays() {
    final navigation = _customNavigationController;

    if (_navigationStarted && navigation != null) {
      return [
        Positioned(
          top: 108,
          left: 16,
          right: 16,
          child: NavigationBanner(
            step: navigation.nextStep ?? navigation.currentStep,
            distanceToManeuver: navigation.distanceToManeuver,
            status: navigation.status,
          ),
        ),
        Positioned(
          right: 16,
          bottom: 205,
          child: RecenterButton(onPressed: _recenterNavigation),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 18,
          child: NavigationBottomBar(
            remainingDuration: navigation.remainingDuration,
            remainingDistance: navigation.remainingDistance,
            onEnd: () => _endCustomNavigation(),
          ),
        ),
      ];
    }

    if (widget.mode == MapViewMode.accepted) {
      return [
        Positioned(
          bottom: 20,
          left: 16,
          right: 16,
          child: _buildRoutePreview(),
        ),
      ];
    } else {
      return [
        Positioned(
          bottom: 24,
          right: 16,
          child: CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(16),
            onPressed: () => _showPickupModal(widget.mode),
            child: Text(
              AppLocalizations.of(context)!.reviewPickupRequest,
              style: const TextStyle(
                color: CupertinoColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ];
    }
  }
}
