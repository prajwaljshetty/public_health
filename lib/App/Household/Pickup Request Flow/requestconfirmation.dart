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

  late final AnimationController _controller;

  static const _animationDuration = Duration(milliseconds: 350);

  // Shared with the worker pickup page so both animate identically.
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

  // ---------------------------------------------------------------------------
  // UI building blocks
  // ---------------------------------------------------------------------------

  Widget _buildIcon() {
    return SizedBox(
      width: 96,
      height: 96,
      child: AnimatedSwitcher(
        duration: _animationDuration,
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.9, end: 1).animate(animation),
              child: child,
            ),
          );
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
                // Yellow rounded tile, same language as the option cards.
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.yellow,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Icon(
                    CupertinoIcons.cube_box,
                    size: 36,
                    color: AppColors.accent,
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
    // AnimatedSize prevents a height "jump" when the text changes.
    return AnimatedSize(
      duration: _animationDuration,
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            _buildAnimatedText(
              text: _confirmed
                  ? l10n.pickupConfirmed
                  : l10n.confirmPickupRequest,
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
      ),
    );
  }

  Widget _buildErrorMessage() {
    return AnimatedSize(
      duration: _animationDuration,
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: double.infinity,
        child: _errorMessage == null
            ? const SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  _errorMessage!,
                  style: AppText.error,
                  textAlign: TextAlign.center,
                ),
              ),
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildIcon(),

        const SizedBox(height: 14),

        _buildHeading(l10n),

        _buildErrorMessage(),
      ],
    );
  }

  Widget _buildBottomActions(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(_pagePadding, 8, _pagePadding, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // One primary button for both states, so it never jumps position.
          AppPrimaryButton(
            isLoading: _loading,
            text: _confirmed ? l10n.done : l10n.confirmPickup,
            loadingText: l10n.requesting,
            onPressed: _confirmed
                ? _goHome
                : () {
                    if (!_loading) {
                      _confirmPickup();
                    }
                  },
          ),

          const SizedBox(height: 10),

          // Fades out but keeps its space, so nothing shifts.
          IgnorePointer(
            ignoring: _confirmed,
            child: AnimatedOpacity(
              opacity: _confirmed ? 0 : 1,
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
                      // Sits slightly above true center, which reads as
                      // optically centered on tall phones.
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
