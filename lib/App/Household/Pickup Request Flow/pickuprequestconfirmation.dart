import 'dart:async';

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

class PickupRequestConfirmationPage extends StatefulWidget {
  const PickupRequestConfirmationPage({super.key});

  @override
  State<PickupRequestConfirmationPage> createState() =>
      _PickupRequestConfirmationPageState();
}

class _PickupRequestConfirmationPageState
    extends State<PickupRequestConfirmationPage>
    with SingleTickerProviderStateMixin {
  bool _confirmed = false;
  bool _loading = false;

  late final AnimationController _controller;

  static const _animationDuration = Duration(milliseconds: 350);

  static const _animationEnd = 0.88;
  static const _pagePadding = 22.0;

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

  void _showErrorDialog(String message) {
    showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: const Text('Unable to request pickup'),
        content: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(message),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(AppLocalizations.of(context)!.okButton),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmPickup() async {
    if (_loading || _confirmed) return;

    setState(() => _loading = true);

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
      ).timeout(const Duration(seconds: 15));

      if (!mounted) return;

      if (pickupResponse['status'] != true) {
        setState(() => _loading = false);

        _showErrorDialog(
          pickupResponse['message']?.toString() ??
              'Unable to request pickup. Please try again.',
        );

        return;
      }

      pickupProvider.setpickupid(
        pickupid: pickupResponse['pickup_id'] as String,
      );

      final dataResponse = await ApiService.getdata(
        userprovider: userProvider,
        pickuprequestprovider: pickupProvider,
      ).timeout(const Duration(seconds: 15));

      if (!mounted) return;

      if (dataResponse['status'] != true) {
        setState(() => _loading = false);

        _showErrorDialog(
          'Pickup requested, but refreshing your account failed. '
          'Please return home and refresh your data.',
        );

        return;
      }

      await ApiService.pickupstatusstream(
        userprovider: userProvider,
        pickuprequestprovider: pickupProvider,
      ).timeout(const Duration(seconds: 15));

      if (!mounted) return;

      setState(() {
        _loading = false;
        _confirmed = true;
      });
    } on TimeoutException {
      if (!mounted) return;

      setState(() => _loading = false);

      _showErrorDialog(
        'The request timed out. Please check your internet connection and try again.',
      );
    } catch (e) {
      if (!mounted) return;

      setState(() => _loading = false);

      debugPrint('Pickup request error: $e');

      _showErrorDialog('Unable to request pickup. Please try again later.');
    }
  }

  void _onAnimationLoaded(LottieComposition composition) {
    _controller.duration = composition.duration;
    _controller.value = 0;
    _controller.animateTo(_animationEnd, curve: Curves.linear);
  }

  void _goHome() {
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(builder: (_) => const HomePage()),
      (route) => false,
    );
  }

  Widget _buildIcon() {
    return SizedBox(
      width: 96,
      height: 96,
      child: AnimatedSwitcher(
        duration: _animationDuration,
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: _confirmed
            ? Lottie.asset(
                AssetMapper.pickupConfirmed,
                key: const ValueKey('lottie'),
                controller: _controller,
                onLoaded: _onAnimationLoaded,
                width: 96,
                height: 96,
              )
            : Center(
                key: const ValueKey('tile'),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Container(
                    width: 96,
                    height: 96,
                    color: AppColors.backgroundwhite,
                    child: Image.asset(
                      AssetMapper.running,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildAnimatedText({required String text, required TextStyle style}) {
    return AnimatedSwitcher(
      duration: _animationDuration,
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
        text,
        key: ValueKey(text),
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildHeading(AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      height: 110,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildAnimatedText(
            text: _confirmed ? l10n.pickupConfirmed : l10n.confirmPickupRequest,
            style: AppText.title.copyWith(fontSize: 26),
          ),
          const SizedBox(height: 8),
          _buildAnimatedText(
            text: _confirmed
                ? l10n.pickupConfirmedMessage
                : l10n.pickupConfirmationMessage,
            style: AppText.subtitle.copyWith(fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [_buildIcon(), const SizedBox(height: 14), _buildHeading(l10n)],
    );
  }

  Widget _buildBottomActions(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(_pagePadding, 8, _pagePadding, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppPrimaryButton(
            isLoading: _loading,
            text: _confirmed ? l10n.done : l10n.confirmPickup,
            loadingText: l10n.requesting,
            onPressed: _confirmed ? _goHome : _confirmPickup,
          ),

          const SizedBox(height: 10),

          IgnorePointer(
            ignoring: _confirmed,
            child: AnimatedOpacity(
              opacity: _confirmed || _loading ? 0 : 1,
              duration: _animationDuration,
              child: AppSecondaryButton(
                text: l10n.cancel,
                onPressed: () {
                  if (!_loading) {
                    Navigator.pop(context);
                  }
                },
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

    return CupertinoPageScaffold(
      backgroundColor: AppColors.backgroundwhite,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: _pagePadding,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Align(
                        alignment: const Alignment(0, -0.2),
                        child: _buildBody(l10n),
                      ),
                    ),
                  );
                },
              ),
            ),
            _buildBottomActions(l10n),
          ],
        ),
      ),
    );
  }
}
