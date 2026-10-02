import 'package:flutter/cupertino.dart';

// Theme
import 'package:public_health/Theme/theme.dart';

// Language
import 'package:public_health/l10n/app_localizations.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final phoneController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 70),
          Text(l10n.login, style: AppText.title),
          const SizedBox(height: 10),
          Text(l10n.loginSubtitle, style: AppText.subtitle),
          const SizedBox(height: 45),
          AppTextField(
            label: l10n.phoneNumber,
            placeholder: l10n.registeredPlaceholder,
            controller: phoneController,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 24),
        ],
      ),
      bottom: Column(
        children: [
          AppPrimaryButton(
            text: l10n.login,
            onPressed: () {
              // Login
            },
          ),
          const SizedBox(height: 18),
        ],
      ),
    );
  }
}
