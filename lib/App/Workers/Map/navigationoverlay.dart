import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

// Services
import 'package:public_health/Services/Navigation/custom_navigation.dart';

// Theme ;
import 'package:public_health/Theme/theme.dart';

// Language
import 'package:public_health/l10n/app_localizations.dart';

String formatManeuverDistance(double meters) {
  if (meters < 1000) {
    return '${(meters / 10).round() * 10} m';
  }

  return '${(meters / 1000).toStringAsFixed(1)} km';
}

String formatTotalDistance(double meters) {
  if (meters < 1000) {
    return '${meters.round()} m';
  }

  return '${(meters / 1000).toStringAsFixed(1)} km';
}

String formatDuration(double seconds) {
  final minutes = (seconds / 60).ceil();

  if (minutes < 60) {
    return '$minutes min';
  }

  final hours = minutes ~/ 60;
  final remainingMinutes = minutes % 60;

  return remainingMinutes == 0 ? '${hours}h' : '${hours}h ${remainingMinutes}m';
}

IconData maneuverIcon(String type, String? modifier) {
  if (type == 'arrive') return CupertinoIcons.flag_fill;
  if (type == 'depart') return CupertinoIcons.location_north_fill;

  if (type == 'roundabout' || type == 'rotary') {
    return CupertinoIcons.arrow_2_circlepath;
  }

  if (type == 'uturn' || modifier == 'uturn') {
    return CupertinoIcons.arrow_uturn_left;
  }

  if (modifier == 'left' ||
      modifier == 'sharp left' ||
      modifier == 'slight left') {
    return CupertinoIcons.arrow_turn_up_left;
  }

  if (modifier == 'right' ||
      modifier == 'sharp right' ||
      modifier == 'slight right') {
    return CupertinoIcons.arrow_turn_up_right;
  }

  if (type == 'merge' ||
      type == 'fork' ||
      type == 'on ramp' ||
      type == 'off ramp') {
    return CupertinoIcons.arrow_turn_up_right;
  }

  return CupertinoIcons.arrow_up;
}

class NavigationBanner extends StatelessWidget {
  const NavigationBanner({
    super.key,
    required this.step,
    required this.distanceToManeuver,
    required this.status,
  });

  final NavStep? step;
  final double distanceToManeuver;
  final NavStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isRerouting = status == NavStatus.rerouting;
    final isArrived = status == NavStatus.arrived;

    final instruction = isRerouting
        ? l10n.rerouting
        : isArrived
        ? l10n.arrivedAtDestination
        : (step?.instruction.isNotEmpty == true
              ? step!.instruction
              : l10n.continueOnRoute);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.black.withAlpha(35),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: CupertinoColors.white.withAlpha(28),
              borderRadius: BorderRadius.circular(15),
            ),
            child: isRerouting
                ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                : Icon(
                    isArrived
                        ? CupertinoIcons.flag_fill
                        : maneuverIcon(
                            step?.type ?? 'continue',
                            step?.modifier,
                          ),
                    color: CupertinoColors.white,
                    size: 29,
                  ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isRerouting
                      ? l10n.findingNewRoute
                      : isArrived
                      ? l10n.destinationReached
                      : formatManeuverDistance(distanceToManeuver),
                  style: const TextStyle(
                    color: CupertinoColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  instruction,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: CupertinoColors.white,
                    fontSize: 17,
                    height: 1.2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (!isArrived && (step?.roadName ?? '').isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    step!.roadName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: CupertinoColors.white.withAlpha(205),
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NavigationBottomBar extends StatelessWidget {
  const NavigationBottomBar({
    super.key,
    required this.remainingDuration,
    required this.remainingDistance,
    required this.onEnd,
  });

  final double remainingDuration;
  final double remainingDistance;
  final VoidCallback onEnd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final eta = DateTime.now().add(Duration(seconds: remainingDuration.ceil()));

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 17, 18, 14),
      decoration: BoxDecoration(
        color: AppColors.backgroundwhite,
        borderRadius: BorderRadius.circular(25),

        boxShadow: [
          BoxShadow(
            color: CupertinoColors.black.withAlpha(22),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppColors.backgroundwhite,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.backgroundblack, width: 1.1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _Metric(
                    value: formatDuration(remainingDuration),
                    label: l10n.remaining,
                  ),
                ),
                Container(
                  width: 1,
                  height: 42,
                  color: AppColors.backgroundblack,
                ),
                Expanded(
                  child: _Metric(
                    value: formatTotalDistance(remainingDistance),
                    label: l10n.distanceLabel,
                  ),
                ),
                Container(
                  width: 1,
                  height: 42,
                  color: AppColors.backgroundblack,
                ),
                Expanded(
                  child: _Metric(
                    value: DateFormat('h:mm a').format(eta),
                    label: l10n.arrival,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: CupertinoButton(
              padding: const EdgeInsets.symmetric(vertical: 13),
              color: CupertinoColors.destructiveRed,
              borderRadius: BorderRadius.circular(14),
              onPressed: onEnd,
              child: Text(
                l10n.endNavigation,
                style: const TextStyle(
                  color: CupertinoColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppText.title.copyWith(fontSize: 18)),
        const SizedBox(height: 4),
        Text(label, style: AppText.cardSubtitle.copyWith(fontSize: 11)),
      ],
    );
  }
}

class RecenterButton extends StatelessWidget {
  const RecenterButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: AppColors.backgroundwhite,
          border: BoxBorder.all(width: 1),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.black.withAlpha(28),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Icon(
          CupertinoIcons.map_pin_ellipse,
          color: AppColors.accent,
          size: 20,
        ),
      ),
    );
  }
}
