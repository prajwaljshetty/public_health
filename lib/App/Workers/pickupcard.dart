import 'package:flutter/cupertino.dart';

// Theme :
import 'package:public_health/Theme/theme.dart';

class PickupCard extends StatelessWidget {
  final String pickupId;
  final String time;
  final String distance;
  final VoidCallback onTap;

  const PickupCard({
    super.key,
    required this.pickupId,
    required this.time,
    required this.distance,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 110,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.layering,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            // Pickup icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.yellow,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                CupertinoIcons.map,
                color: AppColors.accent,
                size: 28,
              ),
            ),

            const SizedBox(width: 14),

            // Pickup information
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pickup Request',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                ],
              ),
            ),

            // Distance
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  distance,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                const Icon(
                  CupertinoIcons.chevron_right,
                  size: 18,
                  color: CupertinoColors.systemGrey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
