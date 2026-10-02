import 'package:flutter/cupertino.dart';

// Theme
import 'package:public_health/Theme/theme.dart';

// Language
import 'package:public_health/l10n/app_localizations.dart';

class WorkerLogin extends StatefulWidget {
  const WorkerLogin({super.key});

  @override
  State<WorkerLogin> createState() => _WorkerLoginState();
}

class _WorkerLoginState extends State<WorkerLogin> {
  final workerIdController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    workerIdController.dispose();
    passwordController.dispose();
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
          Text(l10n.workerLoginTitle, style: AppText.title),
          const SizedBox(height: 10),
          Text(l10n.workerLoginSubtitle, style: AppText.subtitle),
          const SizedBox(height: 45),
          AppTextField(
            label: l10n.workerId,
            placeholder: l10n.workerIdPlaceholder,
            controller: workerIdController,
          ),
          const SizedBox(height: 22),
          AppTextField(
            label: l10n.password,
            placeholder: l10n.passwordPlaceholder,
            controller: passwordController,
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
          ),
          const SizedBox(height: 24),
        ],
      ),
      bottom: Column(
        children: [
          SizedBox(height: 10),
          AppPrimaryButton(
            text: l10n.signIn,
            onPressed: () {
              // Worker login
            },
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
