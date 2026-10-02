import 'package:flutter/cupertino.dart';

// Theme :
import 'package:public_health/Theme/theme.dart';

// Language :
import 'package:public_health/Theme/language_switcher.dart';
import 'package:public_health/l10n/app_localizations.dart';

// User :
import 'package:public_health/Portal/Users/authgate.dart';

// Worker :
import 'package:public_health/Portal/Workers/login.dart';

class Portal extends StatelessWidget {
  const Portal({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      trailing: const LanguageSwitcher(),
      showBack: false,
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.16),
          Text(
            l10n.portalTitle,
            textAlign: TextAlign.center,
            style: AppText.title,
          ),
          const SizedBox(height: 10),
          Text(
            l10n.portalSubtitle,
            textAlign: TextAlign.center,
            style: AppText.subtitle,
          ),
        ],
      ),
      bottom: Column(
        children: [
          AppOptionCard(
            title: l10n.household,
            subtitle: l10n.householdSubtitle,
            icon: CupertinoIcons.house,
            onPressed: () => Navigator.push(
              context,
              CupertinoPageRoute(builder: (_) => const AuthGate()),
            ),
          ),
          const SizedBox(height: 12),
          AppOptionCard(
            title: l10n.worker,
            subtitle: l10n.workerSubtitle,
            icon: CupertinoIcons.briefcase,
            onPressed: () => Navigator.push(
              context,
              CupertinoPageRoute(builder: (_) => const WorkerLogin()),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.selectRole,
            textAlign: TextAlign.center,
            style: AppText.caption,
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
