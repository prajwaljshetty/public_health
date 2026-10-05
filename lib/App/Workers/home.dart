import 'package:flutter/cupertino.dart';

// Theme
import 'package:public_health/Theme/theme.dart';
import 'package:public_health/Theme/profileicon.dart';

// Assets
import 'package:public_health/assetmaper.dart';

// Language :
import 'package:public_health/l10n/app_localizations.dart';
import 'package:public_health/Language/language_switcher.dart';

// Pickup Card :
import 'package:public_health/App/Workers/pickupcard.dart';

// Lottie :
import 'package:lottie/lottie.dart';

// Map :
import 'package:public_health/App/Workers/map.dart';

// Locations :
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestLocation();
    });
  }

  Future<void> _requestLocation() async {
    final Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
    if (!mounted) return;
    setState(() {});
  }

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
                  const SizedBox(width: 8),

                  Lottie.asset(
                    AssetMapper.coins,
                    width: 160,
                    height: 160,
                    fit: BoxFit.contain,
                  ),

                  Expanded(
                    child: Container(
                      height: 160,
                      decoration: BoxDecoration(
                        color: AppColors.textPrimary.withAlpha(20),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '28',
                            style: AppText.title.copyWith(
                              color: AppColors.yellow,
                              fontSize: 80,
                              fontWeight: FontWeight.w600,
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
