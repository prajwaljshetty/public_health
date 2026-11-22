import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

// Theme :
import 'package:public_health/Theme/theme.dart';

// Language switcher :
import 'package:public_health/locale_controller.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  static const _languages = {'en': 'English', 'kn': 'ಕನ್ನಡ'};

  Widget _buildIOSSwitcher(
    BuildContext context,
    String current,
    String currentName,
  ) {
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
      child: _buildButtonContent(currentName),
    );
  }

  Widget _buildAndroidSwitcher(
    BuildContext context,
    String current,
    String currentName,
  ) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppColors.border),
        ),
      ),
      onPressed: () => showModalBottomSheet(
        context: context,
        builder: (ctx) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              const Text(
                'Select Language',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              ..._languages.entries.map((e) {
                return ListTile(
                  title: Text(e.value),
                  trailing: e.key == current ? const Icon(Icons.check) : null,
                  onTap: () {
                    localeController.setLocale(Locale(e.key));
                    Navigator.pop(ctx);
                  },
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      child: _buildButtonContent(currentName),
    );
  }

  Widget _buildButtonContent(String currentName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final current = Localizations.localeOf(context).languageCode;
    final currentName = _languages[current] ?? 'English';

    final isIOS = defaultTargetPlatform == TargetPlatform.iOS;

    return isIOS
        ? _buildIOSSwitcher(context, current, currentName)
        : _buildAndroidSwitcher(context, current, currentName);
  }
}
