import 'package:flutter/cupertino.dart';

import 'dart:convert';

// Theme
import 'package:public_health/Theme/theme.dart';
import 'package:public_health/Theme/profileicon.dart';

// Assets
import 'package:public_health/assetmaper.dart';

// Language
import 'package:public_health/l10n/app_localizations.dart';
import 'package:public_health/Language/language_switcher.dart';

// Pickup Card
import 'package:public_health/App/Workers/pickupcard.dart';

// Lottie
import 'package:lottie/lottie.dart';

// API
import 'package:public_health/Services/API/Workers/api_service.dart';

// Map
import 'package:public_health/App/Workers/map.dart';

// Geolocator
import 'package:geolocator/geolocator.dart';

// Provider
import 'package:provider/provider.dart';
import 'package:public_health/Providers/User/user.dart';
import 'package:public_health/Providers/Location/location.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream? _pickupStream;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final userid = context.read<UserProvider>().userid;

      if (userid != null) {
        _pickupStream = ApiService.pickupsStream(userid).stream;
      }

      context.read<LocationProvider>().startStreaming();

      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    ApiService.disconnectPickups();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final userid = Provider.of<UserProvider>(context).userid;

    // Get current location from Provider
    final position = context.watch<LocationProvider>().position;

    if (userid == null) {
      return const Center(child: CupertinoActivityIndicator());
    }

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
                  l10n.workerHeroTitle,
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
                  l10n.workerHeroSubtitle,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 60),

          Text(l10n.availablePickups, style: AppText.label),

          const SizedBox(height: 0),

          ClipRRect(
            borderRadius: BorderRadius.circular(24),

            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 390,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundwhite,
                    borderRadius: BorderRadius.circular(24),
                  ),

                  child: SingleChildScrollView(
                    child: StreamBuilder(
                      stream: _pickupStream,

                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return SizedBox(
                            height: 200,

                            child: Center(
                              child: Text(
                                l10n.noAvailablePickups,
                                style: AppText.indicator,
                              ),
                            ),
                          );
                        }

                        final pickups =
                            jsonDecode(snapshot.data as String) as List;

                        if (position == null) {
                          return const SizedBox(
                            height: 200,

                            child: Center(child: Text('Getting location...')),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,

                          physics: const NeverScrollableScrollPhysics(),

                          itemCount: pickups.length + 1,

                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return const SizedBox(height: 20);
                            }

                            final pickup = pickups[index - 1];

                            final distance = Geolocator.distanceBetween(
                              position.latitude,
                              position.longitude,

                              (pickup['coordinates']['latitude'] as num)
                                  .toDouble(),

                              (pickup['coordinates']['longitude'] as num)
                                  .toDouble(),
                            );

                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),

                              child: PickupCard(
                                key: ValueKey(pickup['pickupid']),
                                pickupId: pickup['pickupid'],
                                username: pickup['user_name'],
                                time: pickup['time'],
                                distance: distance,
                                qna: List<int>.from(pickup['qna']),
                                imageUrl: '',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (_) => PickupMapPage(
                                        latitude:
                                            (pickup['coordinates']['latitude']
                                                    as num)
                                                .toDouble(),
                                        longitude:
                                            (pickup['coordinates']['longitude']
                                                    as num)
                                                .toDouble(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),

                // Top fade
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
                          AppColors.backgroundwhite,
                          AppColors.backgroundwhite.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom fade
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
                          AppColors.backgroundwhite,
                          AppColors.backgroundwhite.withValues(alpha: 0),
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
