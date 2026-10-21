import 'package:flutter/cupertino.dart';

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
import 'package:provider/provider.dart';
import 'package:public_health/Providers/User/user.dart';
import 'package:public_health/Providers/Household/requestpickup.dart';

class Bridge extends StatefulWidget {
  const Bridge({super.key});

  @override
  State<Bridge> createState() => _BridgeState();
}

class _BridgeState extends State<Bridge> {
  bool _checking = true;
  bool _serverDown = false;

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
    if (!mounted) return;

    setState(() {
      _checking = true;
      _serverDown = false;
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      final pickupProvider = Provider.of<PickupRequestProvider>(
        context,
        listen: false,
      );

      await userProvider.initialize();

      if (!mounted) return;

      final uid = userProvider.userid;
      final accessToken = userProvider.accesstoken;
      final refreshToken = userProvider.refreshtoken;

      final hasUserId = uid != null && uid.isNotEmpty;
      final hasAccessToken = accessToken != null && accessToken.isNotEmpty;
      final hasRefreshToken = refreshToken != null && refreshToken.isNotEmpty;

      if (!hasUserId && !hasAccessToken && !hasRefreshToken) {
        goToPortal();
        return;
      }

      if (hasAccessToken) {
        final householdResponse = await household.ApiService.getdata(
          userprovider: userProvider,
          pickuprequestprovider: pickupProvider,
        );

        if (!mounted) return;

        if (householdResponse['status'] == true) {
          if (pickupProvider.pickupStatus != 'idle') {
            final pickupResponse = await household.ApiService.getpickupdata(
              userprovider: userProvider,
              pickuprequestprovider: pickupProvider,
            );

            if (!mounted) return;

            if (pickupResponse['status'] == true) {
              final pickupId = pickupProvider.pickupid;

              if (pickupId != null && pickupId.isNotEmpty) {
                await household.ApiService.pickupstatusstream(
                  userprovider: userProvider,
                  pickuprequestprovider: pickupProvider,
                );
              }
            }
          }

          if (!mounted) return;

          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(builder: (_) => const householdhome.HomePage()),
          );

          return;
        }

        // 6. Handle household session errors.
        final code = householdResponse['code'];

        if (code == 'NETWORK_ERROR' ||
            code == 'HTTP_ERROR' ||
            code == 'INVALID_RESPONSE') {
          showServerDown();
          return;
        }

        if (code == 'AUTH_REQUIRED' || code == 'REFRESH_FAILED') {
          await userProvider.logout();

          if (!mounted) return;

          goToPortal();
          return;
        }

        showServerDown();
        return;
      }

      // 7. Check the worker session.
      if (hasUserId) {
        final workerResponse = await worker.ApiService.getdata(uid: uid);

        if (!mounted) return;

        if (workerResponse['status'] == true) {
          final workerData = workerResponse['userdata'];

          await userProvider.setUser(
            userid: workerData['userid'],
            username: workerData['username'],
            phoneno: workerData['phoneno'],
            role: workerData['role'],
          );

          if (!mounted) return;

          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(builder: (_) => const workerhome.HomePage()),
          );

          return;
        }

        // 8. Handle worker request errors.
        final code = workerResponse['code'];

        if (code == 'NETWORK_ERROR' ||
            code == 'HTTP_ERROR' ||
            code == 'INVALID_RESPONSE') {
          showServerDown();
          return;
        }
      }

      // 9. No valid session remains.
      await userProvider.logout();

      if (!mounted) return;

      goToPortal();
    } catch (e, stackTrace) {
      debugPrint('Bridge error: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      showServerDown();
    } finally {
      if (mounted) {
        setState(() {
          _checking = false;
        });
      }
    }
  }

  void showServerDown() {
    if (!mounted) return;

    setState(() {
      _checking = false;
      _serverDown = true;
    });
  }

  void goToPortal() {
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(builder: (_) => const Portal()),
    );
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
