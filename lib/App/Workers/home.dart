import 'dart:ui';

import 'package:flutter/cupertino.dart';

// Theme
import 'package:public_health/Theme/theme.dart';
import 'package:public_health/Language/language_switcher.dart';
import 'package:public_health/Theme/profileicon.dart';

// Language :
import 'package:public_health/l10n/app_localizations.dart';

// Pickup Card :
import 'package:public_health/App/Workers/pickupcard.dart';

// Map :
import 'package:public_health/App/Workers/map.dart';

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
        ProfileIcon(role: 'worker'),
      ],

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          // Points
          GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 160,
                      decoration: BoxDecoration(
                        color: AppColors.textPrimary.withAlpha(20),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.primarycoin,
                      borderRadius: BorderRadius.circular(100),
                      border: BoxBorder.all(
                        width: 10,
                        color: AppColors.secondarycoin,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '25',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w500,
                            height: 1,
                            color: AppColors.textPrimary,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          l10n.points,
                          style: AppText.title.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 40),

          Text(l10n.availablePickups, style: AppText.label),

          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                // Your container
                Container(
                  width: double.infinity,
                  height: 460,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (int i = 0; i <= 15; i++)
                          if (i == 0)
                            SizedBox(height: 20)
                          else
                            PickupCard(
                              pickupId: '$i',
                              time: 'Today, 2:30 PM',
                              distance: '2.4 km',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (_) => PickupMapPage(
                                      latitude: 12.9141,
                                      longitude: 74.8560,
                                    ),
                                  ),
                                );
                              },
                            ),
                      ],
                    ),
                  ),
                ),

                // Soft top edge
                Positioned(
                  top: -2,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 20,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.background,
                          AppColors.background.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),

                // Soft bottom edge
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 20,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          AppColors.background,
                          AppColors.background.withValues(alpha: 0),
                        ],
                      ),
                    ),
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
