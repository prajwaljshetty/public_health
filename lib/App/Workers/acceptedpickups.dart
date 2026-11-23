import 'package:flutter/cupertino.dart';

// Provider
import 'package:provider/provider.dart';
import 'package:public_health/Providers/User/user.dart';

// Theme
import 'package:public_health/Theme/theme.dart';
import 'package:public_health/Language/language_switcher.dart';

// Profile
import 'package:public_health/App/Workers/profile.dart';

// Assets
import 'package:public_health/assetmaper.dart';

// Lottie
import 'package:lottie/lottie.dart';

// Language
import 'package:public_health/l10n/app_localizations.dart';

// Pickup Card
import 'package:public_health/App/Workers/pickupcard.dart';

// Map
import 'package:public_health/App/Workers/map.dart';

// Geolocator
import 'package:geolocator/geolocator.dart';

// Provider
import 'package:public_health/Providers/Navigation/location.dart';

// Services
import 'package:public_health/Services/API/Workers/api_service.dart';

class AcceptedPickupsPage extends StatefulWidget {
  const AcceptedPickupsPage({super.key});

  @override
  State<AcceptedPickupsPage> createState() => _AcceptedPickupsPageState();
}

class _AcceptedPickupsPageState extends State<AcceptedPickupsPage> {
  List<PickupCard> pickups = [];

  bool _isLoading = true;
  String? _errorMessage;

  static const _animationDuration = Duration(milliseconds: 350);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAcceptedPickups();
    });
  }

  Future<void> _loadAcceptedPickups() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      final locationProvider = Provider.of<LocationProvider>(
        context,
        listen: false,
      );

      final position = locationProvider.position;

      if (position == null) {
        throw Exception('LOCATION_UNAVAILABLE');
      }

      final result = await ApiService.acceptedpickupdata(
        userprovider: userProvider,
      );

      if (!mounted) return;

      if (result['status'] != true) {
        throw Exception(
          result['message'] ?? 'Unable to load accepted pickups.',
        );
      }

      final fetchedPickups = result['pickups'] as List<dynamic>? ?? [];

      final List<PickupCard> fetchedPickupCards = [];

      for (final pickup in fetchedPickups) {
        final pickupData = pickup['pickup_data'] as Map<String, dynamic>;

        final coordinate = pickupData['coordinates'] as Map<String, dynamic>;

        final latitude = (coordinate['latitude'] as num).toDouble();

        final longitude = (coordinate['longitude'] as num).toDouble();

        final pickupId = pickup['pickup_id'] as String;
        final householdName = pickup['household_name'] as String;
        final time = pickupData['time'];
        final qna = List<int>.from(pickupData['qna'] ?? []);

        final distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          latitude,
          longitude,
        );

        fetchedPickupCards.add(
          PickupCard(
            key: ValueKey(pickupId),
            pickupId: pickupId,
            username: householdName,
            time: time,
            distance: distance,
            qna: qna,
            onTap: () async {
              final shouldRefresh = await Navigator.push<bool>(
                context,
                CupertinoPageRoute(
                  builder: (_) => MapPage(
                    pickupId: pickupId,
                    username: householdName,
                    time: time,
                    distance: distance,
                    qna: qna,
                    latitude: latitude,
                    longitude: longitude,
                    mode: MapViewMode.accepted,
                  ),
                ),
              );

              if (shouldRefresh == true && mounted) {
                await _refreshPickups();
              }
            },
          ),
        );
      }

      if (!mounted) return;

      setState(() {
        pickups = fetchedPickupCards;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      final l10n = AppLocalizations.of(context)!;

      setState(() {
        _errorMessage = e.toString().contains('LOCATION_UNAVAILABLE')
            ? l10n.locationUnavailable
            : e.toString().replaceFirst('Exception: ', '');

        _isLoading = false;
      });
    }
  }

  Future<void> _refreshPickups() async {
    await _loadAcceptedPickups();
  }

  Widget _buildLoadingState() {
    return const SizedBox(
      height: 400,
      child: Center(child: CupertinoActivityIndicator(radius: 14)),
    );
  }

  Widget _buildErrorState() {
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      height: 400,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                CupertinoIcons.exclamationmark_circle,
                size: 46,
                color: AppColors.textSecondary,
              ),

              const SizedBox(height: 16),

              Text(
                _errorMessage ?? l10n.somethingWentWrong,
                textAlign: TextAlign.center,
                style: AppText.cardSubtitle.copyWith(fontSize: 15),
              ),

              const SizedBox(height: 16),

              CupertinoButton(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 10,
                ),
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(20),
                onPressed: _refreshPickups,
                child: Text(
                  l10n.tryAgain,
                  style: const TextStyle(
                    color: CupertinoColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      height: 400,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              CupertinoIcons.cube_box,
              size: 48,
              color: AppColors.textSecondary,
            ),

            const SizedBox(height: 16),

            Text(
              l10n.noAcceptedPickups,
              textAlign: TextAlign.center,
              style: AppText.cardSubtitle.copyWith(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPickupList() {
    return Column(
      children: [
        const SizedBox(height: 20),
        ...pickups,
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildPickupContent() {
    Widget content;

    if (_isLoading && pickups.isEmpty) {
      content = _buildLoadingState();
    } else if (_errorMessage != null) {
      content = _buildErrorState();
    } else if (pickups.isEmpty) {
      content = _buildEmptyState();
    } else {
      content = _buildPickupList();
    }

    final contentKey = _isLoading && pickups.isEmpty
        ? 'loading'
        : _errorMessage != null
        ? 'error'
        : pickups.isEmpty
        ? 'empty'
        : 'list';

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(width: double.infinity, color: AppColors.backgroundwhite),

          SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: AnimatedSwitcher(
              duration: _animationDuration,
              reverseDuration: _animationDuration,
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,

              layoutBuilder: (currentChild, previousChildren) {
                return Stack(
                  alignment: Alignment.topCenter,
                  children: [...previousChildren, ?currentChild],
                );
              },

              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },

              child: KeyedSubtree(key: ValueKey(contentKey), child: content),
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
    );
  }

  Widget _buildPickupCounter() {
    return SizedBox(
      height: 62,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _isLoading && pickups.isEmpty ? 1 : 0,
              child: const SizedBox(
                width: 52,
                height: 52,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: CupertinoActivityIndicator(radius: 14),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _isLoading && pickups.isEmpty ? 0 : 1,
              child: Text(
                '${pickups.length}',
                style: AppText.title.copyWith(
                  color: AppColors.accent,
                  fontSize: 52,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      showBack: true,

      trailing: [
        LanguageSwitcher(),
        const Spacer(),
        AppIcon(
          icon: CupertinoIcons.person_fill,
          onClick: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (_) => const ProfilePage()),
            );
          },
        ),
      ],

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),

          // Page title
          Text(
            l10n.myPickups,
            style: AppText.title.copyWith(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 6),

          Text(l10n.manageAcceptedPickups, style: AppText.cardSubtitle),

          const SizedBox(height: 14),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.yellow,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      CupertinoIcons.cube_box,
                      color: AppColors.accent,
                      size: 24,
                    ),

                    const SizedBox(width: 10),

                    Text(
                      l10n.acceptedPickups,
                      style: AppText.title.copyWith(
                        color: AppColors.accent,
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
                          _buildPickupCounter(),

                          Text(
                            l10n.activePickups,
                            style: AppText.title.copyWith(
                              color: AppColors.accent,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Lottie.asset(
                      AssetMapper.box,
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Accepted pickups heading
          Text(
            l10n.yourAcceptedPickups,
            style: AppText.title.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 0),

          Expanded(child: _buildPickupContent()),
        ],
      ),
    );
  }
}
