import 'package:flutter/cupertino.dart';

import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// Theme :
import 'package:public_health/Theme/theme.dart';

// Assets
import 'package:public_health/assetmaper.dart';

// Language :
import 'package:public_health/l10n/app_localizations.dart';

// Home
import 'package:public_health/App/Workers/home.dart';

// Lottie :
import 'package:lottie/lottie.dart';

// Services :
//import 'package:public_health/Services/API/Household/api_service.dart';

class PickupConfirmationPage extends StatefulWidget {
  final String pickupId;
  final String username;
  final String time;
  final double distance;
  final List<int> qna;
  final double latitude;
  final double longitude;

  const PickupConfirmationPage({
    super.key,
    required this.pickupId,
    required this.username,
    required this.time,
    required this.distance,
    required this.qna,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<PickupConfirmationPage> createState() => _PickupConfirmationPageState();
}

class _PickupConfirmationPageState extends State<PickupConfirmationPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool _accepted = false;
  bool _loading = false;
  bool _animationLoaded = false;

  static const _animationDuration = Duration(milliseconds: 350);
  static const _pagePadding = 22.0;

  // Shared with the household confirmation page so both animate identically.
  static const _animationEnd = 0.88;

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

  void _acceptPickup() {
    if (_loading || _accepted) return;

    setState(() => _loading = true);

    // TODO: Call pickup acceptance API.
    // Only confirm after a successful backend response.

    setState(() {
      _loading = false;
      _accepted = true;
    });

    if (_animationLoaded) {
      _playAnimation();
    }
  }

  Future<void> _copyPickupId() async {
    await Clipboard.setData(ClipboardData(text: widget.pickupId));

    if (!mounted) return;

    final l10n = AppLocalizations.of(context)!;

    showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        content: Text(l10n.pickupIdCopied),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.okButton),
          ),
        ],
      ),
    );
  }

  void _onAnimationLoaded(LottieComposition composition) {
    _controller.duration = composition.duration;
    _animationLoaded = true;

    if (_accepted) {
      _playAnimation();
    }
  }

  void _playAnimation() {
    _controller.value = 0;
    _controller.animateTo(_animationEnd, curve: Curves.linear);
  }

  void _goHome() {
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(builder: (_) => HomePage()),
      (route) => false,
    );
  }

  String get _pickupTime {
    return DateFormat('dd MMM yyyy, hh:mm a')
        .format(DateTime.parse(widget.time));
  }

  String get _shortPickupId {
    final id = widget.pickupId;
    return id.length > 12 ? '${id.substring(0, 12)}...' : id;
  }

  Widget _detail({required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: AppText.cardSubtitle.copyWith(
              fontSize: 14,
              color: AppColors.accent,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppText.label.copyWith(fontSize: 15, height: 1.3),
          ),
        ),
      ],
    );
  }

  Widget _divider({double spacing = 12}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing),
      child: const AppDashedDivider(),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title, style: AppText.cardTitle.copyWith(fontSize: 17));
  }

  Widget _pickupIdDetail(AppLocalizations l10n) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            l10n.pickupIdLabel,
            style: AppText.cardSubtitle.copyWith(
              fontSize: 14,
              color: AppColors.accent,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          flex: 3,
          child: Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _copyPickupId,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: AppColors.backgroundblack.withAlpha(12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        _shortPickupId,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.label.copyWith(fontSize: 13),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      CupertinoIcons.doc_on_doc,
                      size: 15,
                      color: AppColors.textPrimary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _questionnaire(AppLocalizations l10n) {
    if (widget.qna.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _divider(),

        _sectionTitle(l10n.pickupQuestionnaire),

        const SizedBox(height: 12),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(
            widget.qna.length,
            (index) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.backgroundwhite.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${index + 1}. ${widget.qna[index]}',
                style: AppText.label.copyWith(fontSize: 12.5),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _pickupDetails(AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.backgroundwhite,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
        decoration: BoxDecoration(
          color: AppColors.yellow,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle(l10n.requestDetails),

            const SizedBox(height: 18),

            _detail(label: l10n.recipientLabel, value: widget.username),

            _divider(),

            _pickupIdDetail(l10n),

            _divider(),

            _detail(label: l10n.requestedTimeLabel, value: _pickupTime),

            _divider(),

            _detail(
              label: l10n.distanceLabel,
              value: '${widget.distance.toStringAsFixed(2)} km',
            ),

            if (widget.qna.isNotEmpty) _questionnaire(l10n),
          ],
        ),
      ),
    );
  }

  Widget _headerIcon() {
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
        child: _accepted
            ? Lottie.asset(
                AssetMapper.pickupConfirmed,
                key: const ValueKey('lottie'),
                controller: _controller,
                onLoaded: _onAnimationLoaded,
                repeat: false,
                width: 96,
                height: 96,
              )
            : Center(
                key: const ValueKey('tile'),
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

  Widget _header(AppLocalizations l10n) {
    return Column(
      children: [
        _headerIcon(),

        const SizedBox(height: 14),

        AnimatedSize(
          duration: _animationDuration,
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                _animatedText(
                  text: _accepted
                      ? l10n.acceptPickup
                      : l10n.reviewPickupRequest,
                  style: AppText.title.copyWith(fontSize: 26),
                ),

                const SizedBox(height: 8),

                _animatedText(
                  text: _accepted
                      ? l10n.pickupAcceptedSubtitle(widget.username)
                      : l10n.reviewPickupRequestSubtitle,
                  style: AppText.subtitle.copyWith(fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _animatedText({required String text, required TextStyle style}) {
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

  Widget _bottomActions(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(_pagePadding, 8, _pagePadding, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppPrimaryButton(
            isLoading: _loading,
            text: _accepted ? l10n.done : l10n.acceptPickup,
            loadingText: l10n.pleaseWait,
            onPressed: _accepted ? _goHome : _acceptPickup,
          ),

          const SizedBox(height: 10),

          IgnorePointer(
            ignoring: _accepted,
            child: AnimatedOpacity(
              opacity: _accepted ? 0 : 1,
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
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      _pagePadding,
                      12,
                      _pagePadding,
                      32,
                    ),
                    child: Column(
                      children: [
                        _header(l10n),

                        const SizedBox(height: 22),

                        _pickupDetails(l10n),
                      ],
                    ),
                  ),

                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 28,
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.backgroundwhite.withValues(alpha: 0),
                              AppColors.backgroundwhite,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            _bottomActions(l10n),
          ],
        ),
      ),
    );
  }
}
