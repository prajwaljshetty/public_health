import 'package:flutter/cupertino.dart';

// Theme :
import 'package:public_health/Theme/theme.dart';

// Profile :
import 'package:public_health/App/Users/profile.dart';

class ProfileIcon extends StatelessWidget {
  const ProfileIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => const ProfilePage()),
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
