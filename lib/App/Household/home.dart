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

// Request Flow Pages
import 'package:public_health/App/Household/Pickup%20Request%20Flow/location.dart';

// Wallet Page ;
import 'package:public_health/App/Household/wallet.dart';

// QR code Page ;
import 'package:public_health/App/Household/Pickupqr.dart';

// Provider :
import 'package:provider/provider.dart';
import 'package:public_health/Providers/Household/requestpickup.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pickuprequestdata = Provider.of<PickupRequestProvider>(
      context,
      listen: false,
    );
    return AppScaffold(
      showBack: false,
      trailing: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (_) => const WalletPage()),
            );
          },
          child: const Icon(
            CupertinoIcons.creditcard_fill,
            color: AppColors.accent,
            size: 26,
          ),
        ),
        const SizedBox(width: 10),
        const LanguageSwitcher(),
        const SizedBox(width: 10),
        const ProfileIcon(role: 'household'),
      ],
      body: Column(
        children: [
          const SizedBox(height: 60),

          SizedBox(height: 10),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 22),
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
                  l10n.householdHeroTitle,
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
                  l10n.householdHeroSubtitle,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.backgroundwhite,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color.fromARGB(255, 0, 0, 0),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                if (pickuprequestdata.hasActivePickup) ...[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Pickup status
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.accent.withAlpha(20),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                CupertinoIcons.checkmark_circle_fill,
                                color: AppColors.accent,
                                size: 24,
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.pickupRequestedTitle,
                                    style: AppText.cardTitle,
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    l10n.pickupRequestedSubtitle,
                                    style: AppText.cardSubtitle,
                                  ),
                                ],
                              ),
                            ),

                            const Icon(
                              CupertinoIcons.clock,
                              color: AppColors.accent,
                              size: 22,
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        // QR verification instructions
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withAlpha(12),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                CupertinoIcons.qrcode,
                                color: AppColors.accent,
                                size: 30,
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.verifyYourPickup,
                                      style: AppText.cardTitle,
                                    ),

                                    const SizedBox(height: 6),

                                    Text(
                                      l10n.pickupQrInstructions,
                                      style: AppText.cardSubtitle,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Generate QR button
                        SizedBox(
                          width: double.infinity,
                          child: CupertinoButton(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(16),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            onPressed: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) => PickupQrPage(),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  CupertinoIcons.qrcode,
                                  color: CupertinoColors.white,
                                  size: 20,
                                ),

                                const SizedBox(width: 8),

                                Text(
                                  l10n.generateQrCode,
                                  style: const TextStyle(
                                    color: CupertinoColors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Leading QR icon
                  const Icon(
                    CupertinoIcons.qrcode,
                    size: 64,
                    color: AppColors.textPrimary,
                  ),
                ] else ...[
                  // Title and subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(l10n.householdPickups, style: AppText.cardTitle),
                        const SizedBox(height: 8),
                        Text(l10n.noPickupsYet, style: AppText.cardSubtitle),
                      ],
                    ),
                  ),

                  // Leading QR icon
                  const Icon(
                    CupertinoIcons.qrcode,
                    size: 64,
                    color: AppColors.textPrimary,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
      bottom: Column(
        children: [
          AppPrimaryButton(
            text: l10n.requestPickup,
            onPressed: () {
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
