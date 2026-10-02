// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get portalTitle => 'Safe Medical Waste Pickup';

  @override
  String get portalSubtitle =>
      'A Purasabhe service connecting households with verified workers for safe collection of medical waste';

  @override
  String get household => 'Household';

  @override
  String get householdSubtitle => 'Request a medical waste pickup';

  @override
  String get worker => 'Purasabhe Worker';

  @override
  String get workerSubtitle => 'Accept and collect pickup requests';

  @override
  String get selectRole => 'Please select your role to continue';

  @override
  String get welcome => 'Welcome';

  @override
  String get authSubtitle =>
      'Request safe pickup of your household medical waste';

  @override
  String get createAccount => 'Create account';

  @override
  String get createAccountCardSubtitle =>
      'New here? Register to request pickups';

  @override
  String get login => 'Log in';

  @override
  String get loginCardSubtitle =>
      'Already registered? Continue to your account';

  @override
  String get termsNote =>
      'By continuing, you agree to our Privacy Policy and Terms & Conditions';

  @override
  String get createAccountSubtitle =>
      'Register to request medical waste pickups from your home';

  @override
  String get fullName => 'Full name';

  @override
  String get fullNamePlaceholder => 'Enter your full name';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get phonePlaceholder => 'Enter your mobile number';

  @override
  String get createAccountNote =>
      'Your details are used only to manage your account and coordinate pickups.';

  @override
  String get loginSubtitle =>
      'Enter your registered phone number to request or track a pickup';

  @override
  String get registeredPlaceholder => 'Enter your registered number';

  @override
  String get workerLoginTitle => 'Worker login';

  @override
  String get workerLoginSubtitle =>
      'Sign in with your Purasabhe worker ID to view and accept pickup requests';

  @override
  String get workerId => 'Worker ID';

  @override
  String get workerIdPlaceholder => 'Enter your Purasabhe worker ID';

  @override
  String get password => 'Password';

  @override
  String get passwordPlaceholder => 'Enter your password';

  @override
  String get signIn => 'Sign in';

  @override
  String get workerNote =>
      'Only workers verified by Purasabhe can accept pickups. Contact your administrator if your account is pending.';
}
