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
          const SizedBox(height: 60),

          Center(
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 380),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.yellow,
                borderRadius: BorderRadius.circular(18),
                //border: Border.all(width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.workerIdentification,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: AppColors.accent,
                          letterSpacing: 0.7,
                        ),
                      ),
                      const Icon(
                        CupertinoIcons.checkmark_seal_fill,
                        color: AppColors.accent,
                        size: 26,
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 110,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundwhite,
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          CupertinoIcons.person,
                          size: 55,
                          color: AppColors.accent,
                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.workerId.toUpperCase(),
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: AppColors.backgroundblack,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              userProvider.workerid ?? '',
                              style: AppText.cardTitle.copyWith(
                                fontSize: 17,
                                color: AppColors.accent,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              l10n.nameLabel,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: AppColors.backgroundblack,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              userProvider.username ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.cardTitle.copyWith(
                                fontSize: 17,
                                color: AppColors.accent,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              l10n.phoneNumber.toUpperCase(),
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: AppColors.backgroundblack,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '+91 ${userProvider.phoneno ?? ''}',
                              style: AppText.cardTitle.copyWith(
                                fontSize: 17,
                                color: AppColors.accent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
          color: AppColors.backgroundwhite,
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
