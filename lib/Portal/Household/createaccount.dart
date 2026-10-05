import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

// Theme
import 'package:public_health/Theme/theme.dart';

// Language
import 'package:public_health/l10n/app_localizations.dart';

// Home
import 'package:public_health/App/Household/home.dart';

// Validator :
import 'package:public_health/validator/fieldvalidator.dart';

// Services :
import 'package:public_health/Services/API/api_service.dart';

// Provider :
import 'package:provider/provider.dart';
import 'package:public_health/Providers/user.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  // Field Controller :
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  // Feild Validator Message :
  String? nameError;
  String? phoneError;
  String? passwordError;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool validateForm() {
    final l10n = AppLocalizations.of(context)!;

    final nameValidation = FieldValidators.username(nameController.text, l10n);

    final phoneValidation = FieldValidators.phoneNumber(
      phoneController.text,
      l10n,
    );

    final passwordValidation = FieldValidators.password(
      passwordController.text,
      l10n,
    );

    setState(() {
      nameError = nameValidation;
      phoneError = phoneValidation;
      passwordError = passwordValidation;
    });

    if (nameValidation == null &&
        phoneValidation == null &&
        passwordValidation == null) {
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

          Text(l10n.createAccount, style: AppText.title),

          const SizedBox(height: 10),

          Text(l10n.createAccountSubtitle, style: AppText.subtitle),

          const SizedBox(height: 45),

          AppTextField(
            label: l10n.fullName,
            placeholder: l10n.fullNamePlaceholder,
            controller: nameController,
            keyboardType: TextInputType.name,
          ),

          if (nameError != null) ...[
            const SizedBox(height: 6),
            Text(
              nameError!,
              style: const TextStyle(
                fontSize: 13,
                color: CupertinoColors.systemRed,
              ),
            ),
          ],

          const SizedBox(height: 22),

          AppTextField(
            label: l10n.phoneNumber,
            placeholder: l10n.phonePlaceholder,
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
          const SizedBox(height: 10),

          AppPrimaryButton(
            text: l10n.createAccount,
            onPressed: () async {
              if (validateForm()) {
                final response = await ApiService.create(
                  username: nameController.text.trim(),
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

                    if (!mounted) return;

                    Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(builder: (_) => const HomePage()),
                    );
                  }
                } else {
                  setState(() {
                    switch (response['message']) {
                      case 'PHONE_NUMBER_ALREADY_REGISTERED':
                        phoneError = l10n.phoneNumberAlreadyRegistered;
                        break;

                      default:
                        phoneError = response['message'];
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
