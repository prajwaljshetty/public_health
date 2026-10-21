import 'package:flutter/cupertino.dart';

// Theme
import 'package:public_health/Theme/theme.dart';
import 'package:public_health/Language/language_switcher.dart';
import 'package:public_health/Theme/profileicon.dart';

// Assets
import 'package:public_health/assetmaper.dart';

// Lottie
import 'package:lottie/lottie.dart';

// Language
import 'package:public_health/l10n/app_localizations.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      showBack: true,
      trailing: const [
        LanguageSwitcher(),
        SizedBox(width: 10),
        ProfileIcon(role: 'household'),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),

          Text(
            l10n.walletTitle,
            style: AppText.title.copyWith(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 6),

          Text(l10n.walletSubtitle, style: AppText.cardSubtitle),

          const SizedBox(height: 24),

          // Wallet balance
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      CupertinoIcons.creditcard,
                      color: AppColors.yellow,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      l10n.walletTotalBalance,
                      style: AppText.title.copyWith(
                        color: AppColors.yellow,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '0',
                            style: AppText.title.copyWith(
                              color: AppColors.yellow,
                              fontSize: 52,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            l10n.points,
                            style: AppText.title.copyWith(
                              color: AppColors.yellow,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Lottie.asset(
                      AssetMapper.coins,
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // How points work
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.yellow,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withAlpha(20),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    CupertinoIcons.gift,
                    size: 28,
                    color: AppColors.accent,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.walletEarnPoints, style: AppText.cardTitle),
                      const SizedBox(height: 6),
                      Text(
                        l10n.walletEarnPointsDescription,
                        style: AppText.cardSubtitle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
