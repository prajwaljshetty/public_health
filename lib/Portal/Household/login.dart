import 'package:flutter/cupertino.dart';

// Theme
import 'package:public_health/Theme/theme.dart';

// Language
import 'package:public_health/l10n/app_localizations.dart';

// Home
import 'package:public_health/App/Household/home.dart';

// Fallback :
import 'package:public_health/Fallback/serverdown.dart';

// Services :
import 'package:public_health/Services/API/Household/api_service.dart';

// Validator
import 'package:public_health/validator/fieldvalidator.dart';

// Provider :
import 'package:provider/provider.dart';
import 'package:public_health/Providers/User/user.dart';
import 'package:public_health/Providers/Household/requestpickup.dart';

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

  // Server Error handling :
  bool isServerDownPageOpen = false;

  // Loading :
  bool _isLoading = false;

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

  Future<void> requestLogin(AppLocalizations l10n) async {
    if (_isLoading || !validateForm()) return;

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final requestProvider = Provider.of<PickupRequestProvider>(
      context,
      listen: false,
    );

    setState(() {
      _isLoading = true;
    });

    try {
      final loginResponse = await ApiService.login(
        phoneno: phoneController.text.trim(),
        password: passwordController.text,
        userprovider: userProvider,
      );

      if (!mounted) return;

      if (loginResponse['status'] != true) {
        setState(() {
          switch (loginResponse['code']) {
            case 'USER_NOT_FOUND':
              phoneError = l10n.phoneNumberNotRegistered;
              break;

            case 'INCORRECT_PASSWORD':
              passwordError = l10n.incorrectPassword;
              break;

            case 'NETWORK_ERROR':
              phoneError = l10n.networkError;
              break;

            case 'INVALID_RESPONSE':
              phoneError = l10n.invalidServerResponse;
              break;

            default:
              phoneError = l10n.loginFailed;
          }
        });

        return;
      }

      final dataResponse = await ApiService.getdata(
        userprovider: userProvider,
        pickuprequestprovider: requestProvider,
      );

      if (!mounted) return;

      if (dataResponse['status'] != true) {
        final code = dataResponse['code'];

        setState(() {
          phoneError = switch (code) {
            'AUTH_REQUIRED' || 'REFRESH_FAILED' => l10n.sessionExpired,
            'NETWORK_ERROR' => l10n.networkError,
            'INVALID_RESPONSE' => l10n.invalidServerResponse,
            _ => l10n.unableToLoadAccount,
          };
        });

        return;
      }

      if (requestProvider.hasActivePickup) {
        final pickupResponse = await ApiService.getpickupdata(
          userprovider: userProvider,
          pickuprequestprovider: requestProvider,
        );

        if (!mounted) return;

        if (pickupResponse['status'] != true) {
          setState(() {
            phoneError = l10n.unableToLoadPickupDetails;
          });

          return;
        }
      }

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (_) => const HomePage()),
      );
    } catch (e) {
      if (!mounted || isServerDownPageOpen) return;

      isServerDownPageOpen = true;

      try {
        await Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (serverDownContext) => ServerDownPage(
              onReload: () {
                Navigator.of(serverDownContext).pop();
              },
            ),
          ),
        );
      } finally {
        isServerDownPageOpen = false;
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
            isLoading: _isLoading,
            loadingText: l10n.loggingIn,
            onPressed: () => requestLogin(l10n),
          ),

          const SizedBox(height: 18),
        ],
      ),
    );
  }
}
