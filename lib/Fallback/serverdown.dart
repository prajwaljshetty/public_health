import 'package:flutter/cupertino.dart';
import 'package:public_health/Theme/theme.dart';

class ServerDownPage extends StatelessWidget {
  final VoidCallback onReload;

  const ServerDownPage({super.key, required this.onReload});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showBack: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 120),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.yellow,
                borderRadius: BorderRadius.circular(36),
              ),
              alignment: Alignment.center,
              child: const Icon(
                CupertinoIcons.gear_alt,
                size: 60,
                color: AppColors.accent,
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              'Server Unavailable',
              textAlign: TextAlign.center,
              style: AppText.title,
            ),

            const SizedBox(height: 12),

            const Text(
              'We couldn’t connect to our server right now. '
              'Please check your connection or try again in a moment.',
              textAlign: TextAlign.center,
              style: AppText.subtitle,
            ),

            const SizedBox(height: 32),

            AppPrimaryButton(text: 'Reload', onPressed: onReload),

            const SizedBox(height: 12),

            const Text(
              'We’ll be back as soon as possible.',
              textAlign: TextAlign.center,
              style: AppText.caption,
            ),
          ],
        ),
      ),
    );
  }
}
