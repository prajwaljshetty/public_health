import 'package:flutter/cupertino.dart';
import 'package:public_health/Providers/user.dart';

// Theme :
import 'package:public_health/Theme/theme.dart';

// Assets
import 'package:public_health/assetmaper.dart';

// Language :
import 'package:public_health/l10n/app_localizations.dart';

// Home :
import 'package:public_health/App/Household/home.dart';

// Provider :
import 'package:provider/provider.dart';
import 'package:public_health/Providers/Household/requestpickup.dart';

// Lottie :
import 'package:lottie/lottie.dart';

// Services :
import 'package:public_health/Services/API/api_service.dart';

class PickupConfirmationPage extends StatefulWidget {
  const PickupConfirmationPage({super.key});

  @override
  State<PickupConfirmationPage> createState() => _PickupConfirmationPageState();
}

class _PickupConfirmationPageState extends State<PickupConfirmationPage>
    with SingleTickerProviderStateMixin {
  bool _confirmed = false;
  bool _loading = false;

  String? _errorMessage;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _confirmPickup() async {
    try {
      setState(() {
        _loading = true;
        _errorMessage = null;
      });

      final uid = Provider.of<UserProvider>(context, listen: false).userid;

      final pickuprequestdata = Provider.of<PickupRequestProvider>(
        context,
        listen: false,
      );
      pickuprequestdata.setTime(DateTime.now().toString());
      final pickupResponse = await ApiService.requestpickup(
        uid: uid!,
        time: pickuprequestdata.time!,
        coordinates: pickuprequestdata.coordinates!,
        image: pickuprequestdata.image!,
        qna: pickuprequestdata.qna,
      );

      final dataResponse = await ApiService.getdata(uid: uid);

      pickuprequestdata.sethasActivePickup(
        hasActivePickup: dataResponse['userdata']['hasActivePickup'] as bool,
      );

      if (!mounted) return;

      setState(() {
        _loading = false;
        _confirmed = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _errorMessage = 'Unable to request pickup. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      showBack: false,

      body: Column(
        children: [
          const SizedBox(height: 100),

          if (_confirmed)
            SizedBox(
              width: 180,
              height: 180,
              child: Lottie.asset(
                AssetMapper.pickupConfirmed,
                controller: _controller,
                onLoaded: (composition) {
                  _controller.duration = composition.duration;
                  _controller.animateTo(0.88, curve: Curves.linear);
                },
              ),
            )
          else
            const SizedBox(height: 180),

          const SizedBox(height: 24),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.08),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: Text(
              _confirmed ? l10n.pickupConfirmed : l10n.confirmPickupRequest,
              key: ValueKey(_confirmed),
              style: AppText.title,
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 12),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.08),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: Text(
              _confirmed
                  ? l10n.pickupConfirmedMessage
                  : l10n.pickupConfirmationMessage,
              key: ValueKey(_confirmed),
              style: AppText.subtitle,
              textAlign: TextAlign.center,
            ),
          ),

          if (_errorMessage != null) ...[
            const SizedBox(height: 16),

            Text(
              _errorMessage!,
              style: const TextStyle(
                color: CupertinoColors.systemRed,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),

      bottom: Column(
        children: [
          if (!_confirmed) ...[
            AppPrimaryButton(
              text: _loading ? l10n.requesting : l10n.confirmPickup,
              onPressed: () {
                if (!_loading) {
                  _confirmPickup();
                }
              },
            ),

            const SizedBox(height: 12),

            AppSecondaryButton(
              text: l10n.cancel,
              onPressed: () {
                if (!_loading) {
                  Navigator.pop(context);
                }
              },
            ),
          ] else ...[
            AppPrimaryButton(
              text: l10n.done,
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(builder: (_) => const HomePage()),
                  (route) => false,
                );
              },
            ),
            SizedBox(height: 70),
          ],

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
