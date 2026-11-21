import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// Theme :
import 'package:public_health/Theme/theme.dart';

// Language :
import 'package:public_health/l10n/app_localizations.dart';

class PickupCard extends StatelessWidget {
  final String pickupId;
  final String username;
  final String time;
  final double distance;
  final List<int> qna;
  final VoidCallback onTap;

  const PickupCard({
    super.key,
    required this.pickupId,
    required this.username,
    required this.time,
    required this.distance,
    required this.qna,
    required this.onTap,
  });

  String get formattedTime {
    final dateTime = DateTime.parse(time);
    return DateFormat('dd MMM · h:mm a').format(dateTime);
  }

  String get formattedDistance {
    if (distance < 1000) {
      return '${distance.round()} m';
    }

    return '${(distance / 1000).toStringAsFixed(1)} km';
  }

  String get shortPickupId {
    if (pickupId.length <= 16) {
      return pickupId;
    }

    return pickupId.substring(0, 16);
  }

  void copyPickupId() {
    Clipboard.setData(ClipboardData(text: pickupId));
    HapticFeedback.lightImpact();
  }

  Widget _header() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.backgroundwhite,
            border: Border.all(width: 1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(
            CupertinoIcons.cube_box,
            size: 24,
            color: AppColors.accent,
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.cardTitle,
              ),

              const SizedBox(height: 4),

              Row(
                children: [
                  const Icon(
                    CupertinoIcons.clock,
                    size: 13,
                    color: AppColors.textSecondary,
                  ),

                  const SizedBox(width: 5),

                  Flexible(
                    child: Text(
                      formattedTime,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.cardSubtitle,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        const Icon(
          CupertinoIcons.chevron_right,
          size: 18,
          color: AppColors.textSecondary,
        ),
      ],
    );
  }

  Widget _stat({required String label, required Widget value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppText.cardSubtitle.copyWith(
            fontSize: 12,
            color: AppColors.accent,
          ),
        ),

        const SizedBox(height: 6),

        SizedBox(
          height: 20,
          child: Align(alignment: Alignment.centerLeft, child: value),
        ),
      ],
    );
  }

  Widget _distanceStat(AppLocalizations l10n) {
    return _stat(
      label: l10n.distanceLabel,
      value: Text(
        formattedDistance,
        style: AppText.label.copyWith(fontSize: 14),
      ),
    );
  }

  Widget _qnaStat(AppLocalizations l10n) {
    return _stat(
      label: "Q&N",
      value: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < qna.length; i++) ...[
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: qna[i] == 1
                    ? AppColors.activegreen
                    : AppColors.textSecondary.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
            ),

            if (i != qna.length - 1) const SizedBox(width: 5),
          ],
        ],
      ),
    );
  }

  Widget _idStat(AppLocalizations l10n) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: copyPickupId,
      child: _stat(
        label: l10n.pickupIdLabel,
        value: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                shortPickupId,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.label.copyWith(fontSize: 13),
              ),
            ),

            const SizedBox(width: 6),

            const Icon(
              CupertinoIcons.doc_on_doc,
              size: 14,
              color: AppColors.textPrimary,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.backgroundwhite,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            _header(),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: AppDashedDivider(),
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: _distanceStat(l10n)),
                Expanded(flex: 3, child: _qnaStat(l10n)),
                Expanded(flex: 5, child: _idStat(l10n)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
