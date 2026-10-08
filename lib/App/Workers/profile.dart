import 'package:flutter/cupertino.dart';

// Language
import 'package:public_health/l10n/app_localizations.dart';

// Theme :
import 'package:public_health/Theme/theme.dart';

// Provider :
import 'package:provider/provider.dart';
import 'package:public_health/Providers/User/user.dart';

// Portal :
import 'package:public_health/Portal/portal.dart';

// API
import 'package:public_health/Services/API/Workers/api_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userProvider = Provider.of<UserProvider>(context);

    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),

          Center(
            child: Column(
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: AppColors.yellow,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    CupertinoIcons.person_fill,
                    size: 45,
                    color: AppColors.accent,
                  ),
                ),

                const SizedBox(height: 10),

                Text(userProvider.username ?? '', style: AppText.cardTitle),

                const SizedBox(height: 4),

                Text(
                  '+91 ${userProvider.phoneno ?? ''}',
                  style: AppText.cardSubtitle,
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          Text(l10n.account, style: AppText.label),

          const SizedBox(height: 12),

          _ProfileOption(
            icon: CupertinoIcons.person,
            title: l10n.personalInformation,
            onPressed: () {},
          ),

          const SizedBox(height: 6),

          _ProfileOption(
            icon: CupertinoIcons.lock,
            title: l10n.changePassword,
            onPressed: () {},
          ),

          const SizedBox(height: 30),

          _ProfileOption(
            icon: CupertinoIcons.square_arrow_right,
            title: l10n.logOut,
            onPressed: () async {
              ApiService.disconnectPickups();
              await userProvider.logout();

              if (!context.mounted) return;

              Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(builder: (_) => const Portal()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onPressed;

  const _ProfileOption({
    required this.icon,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: AppColors.accent),

            const SizedBox(width: 14),

            Expanded(child: Text(title, style: AppText.label)),

            const Icon(
              CupertinoIcons.chevron_right,
              size: 18,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
