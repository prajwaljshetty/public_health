import 'package:flutter/cupertino.dart';

// Theme
import 'package:public_health/Theme/theme.dart';

// Assets
import 'package:public_health/assetmaper.dart';

// Language
import 'package:public_health/l10n/app_localizations.dart';

// Home
import 'package:public_health/App/Household/home.dart';

// Providers
import 'package:provider/provider.dart';
import 'package:public_health/Providers/User/user.dart';
import 'package:public_health/Providers/Household/requestpickup.dart';

// Lottie
import 'package:lottie/lottie.dart';

// Services
import 'package:public_health/Services/API/Household/api_service.dart';

class RequestConfirmationPage extends StatefulWidget {
  const RequestConfirmationPage({super.key});

  @override
  State<RequestConfirmationPage> createState() =>
      _RequestConfirmationPageState();
}

class _RequestConfirmationPageState extends State<RequestConfirmationPage>
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
    if (_loading) return;

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      final pickupProvider = Provider.of<PickupRequestProvider>(
        context,
        listen: false,
      );

      pickupProvider.setTime(DateTime.now().toIso8601String());

      final pickupResponse = await ApiService.requestpickup(
        userprovider: userProvider,
        pickupRequestProvider: pickupProvider,
        time: pickupProvider.time!,
        coordinates: pickupProvider.coordinates!,
        qna: pickupProvider.qna,
      );

      if (!mounted) return;

      if (pickupResponse['status'] != true) {
        setState(() {
          _loading = false;
          _errorMessage =
              pickupResponse['message'] ??
              'Unable to request pickup. Please try again.';
        });
        return;
      }

      pickupProvider.setpickupid(pickupid: pickupResponse['pickupid']);

      final dataResponse = await ApiService.getdata(
        userprovider: userProvider,
        pickuprequestprovider: pickupProvider,
      );

      await ApiService.pickupstatusstream(
        userprovider: userProvider,
        pickuprequestprovider: pickupProvider,
      );

      if (!mounted) return;

      if (dataResponse['status'] != true) {
        setState(() {
          _loading = false;
          _errorMessage =
              'Pickup requested, but refreshing your account failed. '
              'Please return home and refresh your data.';
        });
        return;
      }

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

  Widget _buildAnimation() {
    if (_confirmed) {
      return SizedBox(
        width: 120,
        height: 120,
        child: Lottie.asset(
          AssetMapper.pickupConfirmed,
          controller: _controller,
          onLoaded: (composition) {
            _controller.duration = composition.duration;
            _controller.animateTo(0.88, curve: Curves.linear);
          },
        ),
      );
    }

    return const SizedBox(height: 120);
  }

  Widget _buildAnimatedText({
    required String text,
    required Key key,
    required TextStyle style,
  }) {
    return AnimatedSwitcher(
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
      child: Text(text, key: key, style: style, textAlign: TextAlign.center),
    );
  }

  Widget _buildHeading(AppLocalizations l10n) {
    return Column(
      children: [
        _buildAnimatedText(
          text: _confirmed ? l10n.pickupConfirmed : l10n.confirmPickupRequest,
          key: ValueKey(_confirmed),
          style: AppText.title,
        ),

        const SizedBox(height: 12),

        _buildAnimatedText(
          text: _confirmed
              ? l10n.pickupConfirmedMessage
              : l10n.pickupConfirmationMessage,
          key: ValueKey(_confirmed),
          style: AppText.subtitle,
        ),
      ],
    );
  }

  Widget _buildErrorMessage() {
    if (_errorMessage == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
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
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    return Column(
      children: [
        const SizedBox(height: 200),

        _buildAnimation(),

        const SizedBox(height: 24),

        _buildHeading(l10n),

        _buildErrorMessage(),
      ],
    );
  }

  Widget _buildBottomActions(AppLocalizations l10n) {
    return Column(
      children: [
        if (!_confirmed) ...[
          AppPrimaryButton(
            isLoading: _loading,
            text: l10n.confirmPickup,
            loadingText: l10n.requesting,
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

          const SizedBox(height: 70),
        ],

        const SizedBox(height: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      showBack: false,
      body: _buildBody(l10n),
      bottom: _buildBottomActions(l10n),
    );
  }
}
