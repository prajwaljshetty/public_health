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
import 'package:public_health/services/api_service.dart';

// Provider :
import 'package:provider/provider.dart';
import 'package:public_health/Providers/user.dart';

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

    final uid = prefs.getString('uid');

    if (uid == null) {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (_) => const Portal()),
      );

      return;
    }

    final dataResponse = await ApiService.getdata(uid: uid);

    if (dataResponse['status'] == true) {
      final userdata = dataResponse['userdata'];

      await userProvider.setUser(
        userid: userdata['userid'],
        username: userdata['username'],
        phoneno: userdata['phoneno'],
        role: userdata['role'],
      );

      if (!mounted) return;

      if (userdata['role'] == 'household') {
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (_) => const householdhome.HomePage()),
        );

        return;
      }

      if (userdata['role'] == 'worker') {
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (_) => const workerhome.HomePage()),
        );

        return;
      }
    }

    // UID exists locally but user is not valid anymore.
    await prefs.remove('uid');

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
