import 'package:flutter/cupertino.dart';

// Theme
import 'package:public_health/Theme/theme.dart';

// Language
import 'package:public_health/l10n/app_localizations.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
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
          const SizedBox(height: 22),
          AppTextField(
            label: l10n.phoneNumber,
            placeholder: l10n.phonePlaceholder,
            controller: phoneController,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 24),
        ],
      ),
      bottom: Column(
        children: [
          SizedBox(height: 10),
          AppPrimaryButton(
            text: l10n.createAccount,
            onPressed: () {
              // Create account
            },
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
