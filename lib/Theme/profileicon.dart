import 'package:flutter/cupertino.dart';

// Theme :
import 'package:public_health/Theme/theme.dart';

// Profile :
import 'package:public_health/App/Household/profile.dart' as household;
import 'package:public_health/App/Workers/profile.dart' as worker;

class ProfileIcon extends StatelessWidget {
  final String? role;
  const ProfileIcon({super.key, required String this.role});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => role == 'household'
                ? const household.ProfilePage()
                : worker.ProfilePage(),
          ),
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(
            CupertinoIcons.circle_fill,
            size: 38,
            color: AppColors.yellow,
          ),
          const Icon(
            CupertinoIcons.person_fill,
            size: 22,
            color: AppColors.accent,
          ),
        ],
      ),
    );
  }
}
