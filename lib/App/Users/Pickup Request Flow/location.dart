import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

// Theme
import 'package:public_health/Theme/theme.dart';

// Language
import 'package:public_health/l10n/app_localizations.dart';

// Page :
import 'package:public_health/App/Users/Pickup Request Flow/photo.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  bool _loading = false;

  Future<void> _allowLocation() async {
    setState(() => _loading = true);

    try {
      final serviceOn = await Geolocator.isLocationServiceEnabled();
      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      final denied =
          permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever;

      if (!serviceOn || denied) {
        if (mounted) _showDeniedDialog();
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      if (mounted) {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (_) => PhotoPage()),
        );
      }
    } catch (_) {
      if (mounted) _showDeniedDialog();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showDeniedDialog() {
    final l10n = AppLocalizations.of(context)!;
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(l10n.locationDeniedTitle),
        content: Text(l10n.locationDeniedMessage),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(ctx);
              Geolocator.openAppSettings();
            },
            child: Text(l10n.openSettings),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      showBack: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          // Hero card with target rings
          Container(
            width: double.infinity,
            height: 320,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.hero,
              border: BoxBorder.all(color: AppColors.textPrimary),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: const Alignment(0, 0),
                  child: Container(
                    width: 190,
                    height: 190,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.background, width: 1),
                    ),
                  ),
                ),
                Align(
                  alignment: const Alignment(0, 0.0),
                  child: Container(
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.accent.withValues(alpha: 0.35),
                    ),
                  ),
                ),
                Align(
                  alignment: const Alignment(0, 0),
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.accent,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    l10n.locationTitle,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          Text(
            l10n.locationSubtitle,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              height: 1.4,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
      bottom: Column(
        children: [
          _loading
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  child: CupertinoActivityIndicator(radius: 14),
                )
              : AppPrimaryButton(
                  text: l10n.allowLocation,
                  onPressed: _allowLocation,
                ),
          const SizedBox(height: 12),
          AppSecondaryButton(
            text: l10n.cancel,
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
