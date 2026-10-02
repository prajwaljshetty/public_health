import 'package:flutter/cupertino.dart';

// Theme
import 'package:public_health/Theme/theme.dart';
import 'package:public_health/Theme/language_switcher.dart';

// Language
import 'package:public_health/l10n/app_localizations.dart';

// Geolocator :
import 'package:geolocator/geolocator.dart';

// Map Confirmation :
import 'package:public_health/App/Users/Pickup%20Request%20Flow/location.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      showBack: false,
      trailing: const LanguageSwitcher(),
      body: Column(
        children: [
          const SizedBox(height: 60),

          // Hero card
          Container(
            width: double.infinity,
            height: 210,
            padding: const EdgeInsets.all(22),
            alignment: Alignment.bottomLeft,
            decoration: BoxDecoration(
              color: AppColors.hero,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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

          // Pickups card (empty state for now)
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
            onPressed: () async {
              final position = await Navigator.push<Position>(
                context,
                CupertinoPageRoute(builder: (_) => const LocationPage()),
              );
              if (position != null) {
                // Next: confirm pickup screen using
                // position.latitude and position.longitude
              }
            },
          ),
          const SizedBox(height: 18),
        ],
      ),
    );
  }
}
