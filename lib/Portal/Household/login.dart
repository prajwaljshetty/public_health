import 'package:flutter/cupertino.dart';

// Theme
import 'package:public_health/Theme/theme.dart';

// Language
import 'package:public_health/l10n/app_localizations.dart';

// Home
import 'package:public_health/App/Household/home.dart';

// Services :
import 'package:public_health/Services/api_service.dart';

// Validator
import 'package:public_health/validator/fieldvalidator.dart';

// Provider :
import 'package:provider/provider.dart';
import 'package:public_health/Providers/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  String? phoneError;
  String? passwordError;

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool validateForm() {
    final l10n = AppLocalizations.of(context)!;

    final phoneValidation = FieldValidators.phoneNumber(
      phoneController.text,
      l10n,
    );

    final passwordValidation = FieldValidators.password(
      passwordController.text,
      l10n,
    );

    setState(() {
      phoneError = phoneValidation;
      passwordError = passwordValidation;
    });

    if (phoneValidation == null && passwordValidation == null) {
      return true;
    }
    return false;
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

          if (phoneError != null) ...[
            const SizedBox(height: 6),
            Text(
              phoneError!,
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
          AppPrimaryButton(
            text: l10n.login,
            onPressed: () async {
              if (validateForm()) {
                final response = await ApiService.login(
                  phoneno: phoneController.text.trim(),
                  password: passwordController.text,
                  role: 'household',
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
                        phoneError = l10n.phoneNumberNotRegistered;
                        break;

                      case 'INCORRECT_PASSWORD':
                        passwordError = l10n.incorrectPassword;
                        break;

                      default:
                        phoneError = response['message'];
                    }
                  });
                }
              }
            },
          ),

          const SizedBox(height: 18),
        ],
      ),
    );
  }
}
