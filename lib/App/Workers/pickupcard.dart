import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:public_health/Theme/theme.dart';

class PickupCard extends StatelessWidget {
  final String pickupId;
  final String username;
  final String time;
  final double distance;
  final List<int> qna;
  final String imageUrl;
  final VoidCallback onTap;

  const PickupCard({
    super.key,
    required this.pickupId,
    required this.username,
    required this.time,
    required this.distance,
    required this.qna,
    required this.imageUrl,
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
    if (pickupId.length <= 8) {
      return pickupId;
    }

    return pickupId.substring(0, 16);
  }

  void copyPickupId() {
    Clipboard.setData(ClipboardData(text: pickupId));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.textPrimary, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    username,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.cardTitle.copyWith(
                      fontSize: 18,
                      color: AppColors.accent,
                    ),
                  ),
                ),

                const Icon(
                  CupertinoIcons.chevron_right,
                  size: 17,
                  color: AppColors.textSecondary,
                ),
              ],
            ),

            const SizedBox(height: 5),

            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'pickup id:',
                        style: AppText.cardSubtitle.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),

                      const SizedBox(width: 4),

                      Text(
                        shortPickupId,
                        style: AppText.cardSubtitle.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),

                      const SizedBox(width: 4),

                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        minSize: 18,
                        onPressed: copyPickupId,
                        child: const Icon(
                          CupertinoIcons.doc_on_doc,
                          size: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                const Icon(
                  CupertinoIcons.paperplane_fill,
                  size: 13,
                  color: AppColors.activeblue,
                ),

                const SizedBox(width: 8),

                Text(
                  formattedDistance,
                  style: AppText.cardSubtitle.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.activeblue,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                // TIME
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          CupertinoIcons.clock,
                          size: 15,
                          color: AppColors.textSecondary,
                        ),

                        const SizedBox(width: 7),

                        Expanded(
                          child: Text(
                            formattedTime,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.cardSubtitle.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 9),

                // Q&A
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Q&A',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),

                      const SizedBox(width: 8),

                      for (int i = 0; i < qna.length; i++) ...[
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: qna[i] == 1
                                ? AppColors.activegreen
                                : AppColors.yellow,
                            shape: BoxShape.circle,
                          ),
                        ),

                        if (i != qna.length - 1) const SizedBox(width: 4),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
