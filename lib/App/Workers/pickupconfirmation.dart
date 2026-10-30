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
      _controller.forward(from: 0);
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
      _controller.forward(from: 0);
    }
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: AppText.cardSubtitle.copyWith(color: AppColors.accent),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppText.label.copyWith(fontSize: 14, height: 1.4),
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
    return Text(title, style: AppText.cardTitle.copyWith(fontSize: 16));
  }

  Widget _pickupIdDetail(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            l10n.pickupIdLabel,
            style: AppText.cardSubtitle.copyWith(color: AppColors.accent),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.backgroundblack.withAlpha(10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    _shortPickupId,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.cardSubtitle.copyWith(
                      fontSize: 12,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  minimumSize: ui.Size.zero,
                  onPressed: _copyPickupId,
                  child: const Icon(
                    CupertinoIcons.doc_on_doc,
                    size: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _questionnaire() {
    if (widget.qna.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _divider(spacing: 12),
        _sectionTitle('Pickup Questionnaire'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: List.generate(
            widget.qna.length,
            (index) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.backgroundwhite.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Text(
                '${index + 1}. ${widget.qna[index]}',
                style: AppText.label.copyWith(fontSize: 12),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.yellow,
        borderRadius: BorderRadius.circular(19),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(l10n.requestDetails),
          const SizedBox(height: 20),

          _detail(label: l10n.recipientLabel, value: widget.username),

          _divider(),

          _pickupIdDetail(l10n),

          _divider(),

          _detail(label: l10n.requestedTimeLabel, value: _pickupTime),

          _divider(),

          _detail(
            label: 'Distance',
            value: '${widget.distance.toStringAsFixed(2)} km',
          ),

          if (widget.qna.isNotEmpty) _questionnaire(),
        ],
      ),
    );
  }

  Widget _header() {
    return Column(
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: _accepted
              ? Lottie.asset(
                  AssetMapper.pickupConfirmed,
                  controller: _controller,
                  onLoaded: _onAnimationLoaded,
                  repeat: false,
                )
              : const Icon(
                  CupertinoIcons.cube_box,
                  size: 75,
                  color: AppColors.accent,
                ),
        ),

        const SizedBox(height: 24),

        _animatedText(
          text: _accepted ? 'Pickup Accepted!' : 'Review Pickup Request',
          style: AppText.title,
        ),

        const SizedBox(height: 12),

        _animatedText(
          text: _accepted
              ? 'You have successfully accepted the pickup '
                    'request from ${widget.username}.'
              : 'Review the pickup information before accepting '
                    'this request.',
          style: AppText.subtitle,
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
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!_accepted) ...[
            AppPrimaryButton(
              isLoading: _loading,
              text: 'Accept Pickup',
              loadingText: 'Accepting',
              onPressed: _acceptPickup,
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
          ] else
            AppPrimaryButton(
              text: l10n.done,
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(builder: (_) => HomePage()),
                  (route) => false,
                );
              },
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 24,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 28),
                    _header(),

                    const SizedBox(height: 28),

                    _pickupDetails(l10n),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            _bottomActions(l10n),
          ],
        ),
      ),
    );
  }
}
