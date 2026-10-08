import 'package:flutter/cupertino.dart';

// Portal :
import 'package:public_health/Portal/portal.dart';

// User Home :
import 'package:public_health/App/Household/home.dart' as householdhome;

// Worker Home :
import 'package:public_health/App/Workers/home.dart' as workerhome;

// Local Storage :
import 'package:shared_preferences/shared_preferences.dart';

// Services :
import 'package:public_health/Services/API/Household/api_service.dart'
    as household;
import 'package:public_health/Services/API/Workers/api_service.dart' as worker;

// Provider :
import 'package:provider/provider.dart';
import 'package:public_health/Providers/User/user.dart';
import 'package:public_health/Providers/Household/requestpickup.dart';

class Bridge extends StatefulWidget {
  const Bridge({super.key});

  @override
  State<Bridge> createState() => _BridgeState();
}

class _BridgeState extends State<Bridge> {
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final pickupRequestProvider = Provider.of<PickupRequestProvider>(
      context,
      listen: false,
    );

    final uid = prefs.getString('uid');

    if (uid == null) {
      goToPortal();
      return;
    }

    final householdResponse = await household.ApiService.getdata(uid: uid);

    if (householdResponse['status'] == true) {
      final householdData = householdResponse['userdata'];

      await userProvider.setUser(
        userid: householdData['userid'],
        username: householdData['username'],
        phoneno: householdData['phoneno'],
        role: householdData['role'],
      );

      pickupRequestProvider.sethasActivePickup(
        hasActivePickup: householdData['hasActivePickup'],
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (_) => const householdhome.HomePage()),
      );

      return;
    }

    final workerResponse = await worker.ApiService.getdata(uid: uid);

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

    await prefs.remove('uid');

    goToPortal();
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
    return const CupertinoPageScaffold(
      child: Center(child: CupertinoActivityIndicator()),
    );
  }
}
