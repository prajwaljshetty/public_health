import 'package:flutter/cupertino.dart';

// Theme
import 'package:public_health/Theme/theme.dart';

// Language
import 'package:public_health/l10n/app_localizations.dart';

// Pages
import 'createaccount.dart';
import 'login.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.16),
          Text(l10n.welcome, textAlign: TextAlign.center, style: AppText.title),
          const SizedBox(height: 10),
          Text(
            l10n.authSubtitle,
            textAlign: TextAlign.center,
            style: AppText.subtitle,
          ),
        ],
      ),
      bottom: Column(
        children: [
          AppOptionCard(
            title: l10n.createAccount,
            subtitle: l10n.createAccountCardSubtitle,
            icon: CupertinoIcons.person_add,
            onPressed: () => Navigator.push(
              context,
              CupertinoPageRoute(builder: (_) => const CreateAccount()),
            ),
          ),
          const SizedBox(height: 12),
          AppOptionCard(
            title: l10n.login,
            subtitle: l10n.loginCardSubtitle,
            icon: CupertinoIcons.arrow_right_circle,
            onPressed: () => Navigator.push(
              context,
              CupertinoPageRoute(builder: (_) => const Login()),
            ),
          ),
          const SizedBox(height: 25),
          Text(
            l10n.termsNote,
            textAlign: TextAlign.center,
            style: AppText.caption,
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
