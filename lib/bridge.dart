import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

// Portal
import 'package:public_health/Portal/portal.dart';

// Home pages
import 'package:public_health/App/Household/home.dart' as householdhome;
import 'package:public_health/App/Workers/home.dart' as workerhome;

// Fallback
import 'package:public_health/Fallback/serverdown.dart';

// Services
import 'package:public_health/Services/API/Household/api_service.dart'
    as household;
import 'package:public_health/Services/API/Workers/api_service.dart' as worker;

// Providers
import 'package:public_health/Providers/User/user.dart';
import 'package:public_health/Providers/Household/requestpickup.dart';

class Bridge extends StatefulWidget {
  const Bridge({super.key});

  @override
  State<Bridge> createState() => _BridgeState();
}

class _BridgeState extends State<Bridge> {
  bool _isChecking = false;
  bool _serverDown = false;

  UserProvider get _userProvider =>
      Provider.of<UserProvider>(context, listen: false);

  PickupRequestProvider get _pickupProvider =>
      Provider.of<PickupRequestProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
    if (!mounted || _isChecking) return;

    _isChecking = true;

    setState(() {
      _serverDown = false;
    });

    try {
      await _userProvider.initialize();

      if (!mounted) return;

      if (!_hasValidSession) {
        await _logoutAndGoToPortal();
        return;
      }

      final householdResponse = await household.ApiService.getdata(
        userprovider: _userProvider,
        pickuprequestprovider: _pickupProvider,
      );

      if (!mounted) return;

      if (householdResponse['status'] == true) {
        await _initializeHousehold();
        return;
      }

      final householdCode = householdResponse['code'];

      if (_isNetworkFailure(householdCode)) {
        _showServerDown();
        return;
      }

      if (_isAuthFailure(householdCode)) {
        await _logoutAndGoToPortal();
        return;
      }

      final workerResponse = await worker.ApiService.getdata(
        userprovider: _userProvider,
      );

      if (!mounted) return;

      if (workerResponse['status'] == true) {
        _goToWorkerHome();
        return;
      }

      final workerCode = workerResponse['code'];

      if (_isNetworkFailure(workerCode)) {
        _showServerDown();
        return;
      }

      if (_isAuthFailure(workerCode)) {
        await _logoutAndGoToPortal();
        return;
      }

      _showServerDown();
    } catch (e, stackTrace) {
      debugPrint('Bridge error: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (mounted) {
        _showServerDown();
      }
    } finally {
      _isChecking = false;
    }
  }

  bool get _hasValidSession {
    final uid = _userProvider.userid;
    final refreshToken = _userProvider.refreshtoken;

    return uid != null &&
        uid.isNotEmpty &&
        refreshToken != null &&
        refreshToken.isNotEmpty;
  }

  Future<void> _initializeHousehold() async {
    if (_pickupProvider.pickupStatus != 'idle') {
      final pickupResponse = await household.ApiService.getpickupdata(
        userprovider: _userProvider,
        pickuprequestprovider: _pickupProvider,
      );

      if (!mounted) return;

      if (pickupResponse['status'] == true) {
        final pickupId = _pickupProvider.pickupid;

        if (pickupId != null && pickupId.isNotEmpty) {
          await household.ApiService.pickupstatusstream(
            userprovider: _userProvider,
            pickuprequestprovider: _pickupProvider,
          );
        }
      }
    }

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(builder: (_) => const householdhome.HomePage()),
    );
  }

  bool _isNetworkFailure(dynamic code) {
    return code == 'NETWORK_ERROR' || code == 'INVALID_RESPONSE';
  }

  bool _isAuthFailure(dynamic code) {
    return code == 'AUTH_REQUIRED' || code == 'REFRESH_FAILED';
  }

  Future<void> _logoutAndGoToPortal() async {
    await _userProvider.logout();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(builder: (_) => const Portal()),
    );
  }

  void _goToWorkerHome() {
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(builder: (_) => const workerhome.HomePage()),
    );
  }

  void _showServerDown() {
    if (!mounted) return;

    setState(() {
      _serverDown = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_serverDown) {
      return ServerDownPage(onReload: checkLogin);
    }

    return const CupertinoPageScaffold(
      child: Center(child: CupertinoActivityIndicator()),
    );
  }
}
