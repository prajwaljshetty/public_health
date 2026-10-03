import 'package:flutter/cupertino.dart';

// Theme
import 'package:public_health/Theme/theme.dart';
import 'package:public_health/Theme/language_switcher.dart';
import 'package:public_health/Theme/profileicon.dart';

// Language
import 'package:public_health/l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      showBack: false,
      trailing: const [LanguageSwitcher(), SizedBox(width: 10), ProfileIcon()],

      body: Column(children: [const SizedBox(height: 60)]),

      bottom: const SizedBox(height: 18),
    );
  }
}
