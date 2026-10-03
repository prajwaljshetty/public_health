import 'package:flutter/cupertino.dart';

// Theme :
import 'package:public_health/Theme/theme.dart';

// Assets
import 'package:public_health/assetmaper.dart';

// Language :
import 'package:public_health/l10n/app_localizations.dart';

// Home :
import 'package:public_health/App/Household/home.dart';

class PickupConfirmationPage extends StatefulWidget {
  const PickupConfirmationPage({super.key});

  @override
  State<PickupConfirmationPage> createState() => _PickupConfirmationPageState();
}

class _PickupConfirmationPageState extends State<PickupConfirmationPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            children: [
              const Spacer(),

              ShaderMask(
                shaderCallback: (bounds) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      CupertinoColors.black,
                      CupertinoColors.black,
                      CupertinoColors.transparent,
                    ],
                    stops: [0.0, 0.82, 1.0],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: Image.asset(
                  AssetMapper.confirmtick,
                  width: 120,
                  height: 120,
                ),
              ),

              const SizedBox(height: 24),

              Text(
                l10n.pickupRequested,
                style: AppText.title,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              Text(
                l10n.pickupConfirmationMessage,
                style: AppText.subtitle,
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute(builder: (context) => const HomePage()),
                    (route) => false,
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: Text(l10n.done, style: AppText.button),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
