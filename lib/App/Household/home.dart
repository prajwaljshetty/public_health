import 'dart:ui';

import 'package:flutter/cupertino.dart';

// Theme
import 'package:public_health/Theme/theme.dart';
import 'package:public_health/Language/language_switcher.dart';
import 'package:public_health/Theme/profileicon.dart';

// Assets
import 'package:public_health/assetmaper.dart';

// Lottie :
import 'package:lottie/lottie.dart';

// Language
import 'package:public_health/l10n/app_localizations.dart';

// Location Page
import 'package:public_health/App/Household/Pickup%20Request%20Flow/location.dart';

// Provider :
import 'package:provider/provider.dart';
import 'package:public_health/Providers/Household/requestpickup.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      showBack: false,
      trailing: const [
        LanguageSwitcher(),
        SizedBox(width: 10),
        ProfileIcon(role: 'household'),
      ],
      body: Column(
        children: [
          const SizedBox(height: 60),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            alignment: Alignment.bottomLeft,
            decoration: BoxDecoration(
              color: AppColors.yellow,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Lottie.asset(
                  AssetMapper.box,
                  width: 160,
                  height: 160,
                  fit: BoxFit.contain,
                ),
                Text(
                  l10n.homeHeroTitle,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                    height: 1.2,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.homeHeroSubtitle,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Container(
            width: double.infinity,
            height: 180,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color.fromARGB(255, 0, 0, 0),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.yourPickups, style: AppText.cardTitle),
                const Spacer(),
                Center(
                  child: Text(
                    l10n.noPickupsYet,
                    textAlign: TextAlign.center,
                    style: AppText.cardSubtitle,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
      bottom: Column(
        children: [
          AppPrimaryButton(
            text: l10n.requestPickup,
            onPressed: () {
              final pickuprequestdata = Provider.of<PickupRequestProvider>(
                context,
                listen: false,
              );
              if (pickuprequestdata.hasActivePickup) return;
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (_) => const LocationPage()),
              );
            },
          ),
          const SizedBox(height: 18),
        ],
      ),
    );
  }
}
