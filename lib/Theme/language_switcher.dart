import 'package:flutter/cupertino.dart';

// Theme :
import 'package:public_health/Theme/theme.dart';

// Language switcher :
import 'package:public_health/locale_controller.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  static const _languages = {'en': 'English', 'kn': 'ಕನ್ನಡ'};

  @override
  Widget build(BuildContext context) {
    final current = Localizations.localeOf(context).languageCode;
    final currentName = _languages[current] ?? 'English';

    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      onPressed: () => showCupertinoModalPopup(
        context: context,
        builder: (ctx) => CupertinoActionSheet(
          actions: _languages.entries.map((e) {
            return CupertinoActionSheetAction(
              isDefaultAction: e.key == current,
              onPressed: () {
                localeController.setLocale(Locale(e.key));
                Navigator.pop(ctx);
              },
              child: Text(e.value),
            );
          }).toList(),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(CupertinoIcons.globe, size: 16, color: AppColors.accent),
            const SizedBox(width: 6),
            Text(
              currentName,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              CupertinoIcons.chevron_down,
              size: 12,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
