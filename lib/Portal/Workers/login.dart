import 'package:flutter/cupertino.dart';

// Theme
import 'package:public_health/Theme/theme.dart';

// Language
import 'package:public_health/l10n/app_localizations.dart';

// Services :
import 'package:public_health/Services/API/Workers/api_service.dart';

// Validator
import 'package:public_health/validator/fieldvalidator.dart';

// Worker Home :
import 'package:public_health/App/Workers/home.dart';

// Provider :
import 'package:provider/provider.dart';
import 'package:public_health/Providers/User/user.dart';

// Shared Preferences
import 'package:shared_preferences/shared_preferences.dart';

class WorkerLogin extends StatefulWidget {
  const WorkerLogin({super.key});

  @override
  State<WorkerLogin> createState() => _WorkerLoginState();
}

class _WorkerLoginState extends State<WorkerLogin> {
  final workerIdController = TextEditingController();
  final passwordController = TextEditingController();

  String? workerIdError;
  String? passwordError;

  @override
  void dispose() {
    workerIdController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool validateForm() {
    final l10n = AppLocalizations.of(context)!;

    final workerIdValidation = FieldValidators.workerId(
      workerIdController.text,
      l10n,
    );

    final passwordValidation = FieldValidators.password(
      passwordController.text,
      l10n,
    );

    setState(() {
      workerIdError = workerIdValidation;
      passwordError = passwordValidation;
    });

    return workerIdValidation == null && passwordValidation == null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userProvider = Provider.of<UserProvider>(context, listen: false);

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

          if (workerIdError != null) ...[
            const SizedBox(height: 6),
            Text(
              workerIdError!,
              style: const TextStyle(
                fontSize: 13,
                color: CupertinoColors.systemRed,
              ),
            ),
          ],

          const SizedBox(height: 22),

          AppTextField(
            label: l10n.password,
            placeholder: l10n.passwordPlaceholder,
            controller: passwordController,
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
          ),

          if (passwordError != null) ...[
            const SizedBox(height: 6),
            Text(
              passwordError!,
              style: const TextStyle(
                fontSize: 13,
                color: CupertinoColors.systemRed,
              ),
            ),
          ],

          const SizedBox(height: 24),
        ],
      ),

      bottom: Column(
        children: [
          const SizedBox(height: 10),

          AppPrimaryButton(
            text: l10n.signIn,
            onPressed: () async {
              if (validateForm()) {
                final response = await ApiService.login(
                  workerid: workerIdController.text.trim(),
                  password: passwordController.text,
                );
                if (response['status'] == true) {
                  final String uid = response['uid'];

                  final dataResponse = await ApiService.getdata(uid: uid);

                  if (dataResponse['status'] == true) {
                    final userdata = dataResponse['userdata'];

                    userProvider.setUser(
                      userid: userdata['userid'],
                      username: userdata['username'],
                      phoneno: userdata['phoneno'],
                      role: userdata['role'],
                    );

                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('uid', uid);

                    if (!mounted) return;

                    Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(builder: (_) => const HomePage()),
                    );
                  }
                } else {
                  setState(() {
                    switch (response['message']) {
                      case 'USER_NOT_FOUND':
                        workerIdError = l10n.workerNotFound;
                        break;

                      case 'INCORRECT_PASSWORD':
                        passwordError = l10n.incorrectPassword;
                        break;

                      default:
                        workerIdError = response['message'];
                    }
                  });
                }
              }
            },
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
