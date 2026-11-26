import 'package:flutter/cupertino.dart';

// Theme
import 'package:public_health/Theme/theme.dart';

// Language
import 'package:public_health/l10n/app_localizations.dart';
import 'package:public_health/Language/language_switcher.dart';

class ServerDownPage extends StatelessWidget {
  final VoidCallback onReload;
  final bool isLoading;

  const ServerDownPage({
    super.key,
    required this.onReload,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      showBack: false,
      trailing: [LanguageSwitcher(), const Spacer()],
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Main server status card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 38),
                decoration: BoxDecoration(
                  color: AppColors.backgroundwhite,
                  border: Border.all(
                    color: AppColors.backgroundblack,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(36),
                ),
                child: Column(
                  children: [
                    // Server illustration
                    Container(
                      width: 104,
                      height: 104,
                      decoration: BoxDecoration(
                        color: CupertinoColors.white,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: AppColors.backgroundblack,
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        CupertinoIcons.wrench,
                        color: AppColors.accent,
                        size: 52,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Title
                    Text(
                      l10n.serverDownTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accent,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Description
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Text(
                        l10n.serverDownDescription,
                        textAlign: TextAlign.center,
                        style: AppText.subtitle,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // What you can do
              Align(
                alignment: Alignment.centerLeft,
                child: Text(l10n.serverDownWhatCanYouDo, style: AppText.title),
              ),

              const SizedBox(height: 14),

              // Instructions
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.serverDownInstructions,
                  style: AppText.subtitle,
                ),
              ),

              const SizedBox(height: 32),

              // Retry
              AppPrimaryButton(
                text: l10n.serverDownRetry,
                onPressed: onReload,
                isLoading: isLoading,
                loadingText: 'Checking...',
              ),

              const SizedBox(height: 18),

              // Footer
              Text(
                l10n.serverDownFooter,
                style: AppText.caption,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
