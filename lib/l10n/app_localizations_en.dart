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
  String get selectRole => 'Please select your role to continue';

  @override
  String get household => 'Household';

  @override
  String get householdSubtitle => 'Request a medical waste pickup';

  @override
  String get worker => 'Purasabhe Worker';

  @override
  String get workerSubtitle => 'Accept and collect pickup requests';

  @override
  String get welcome => 'Welcome';

  @override
  String get authSubtitle =>
      'Request safe pickup of your household medical waste';

  @override
  String get login => 'Log in';

  @override
  String get loginSubtitle =>
      'Enter your registered phone number to request or track a pickup';

  @override
  String get loginCardSubtitle =>
      'Already registered? Continue to your account';

  @override
  String get createAccount => 'Create account';

  @override
  String get createAccountSubtitle =>
      'Register to request medical waste pickups from your home';

  @override
  String get createAccountCardSubtitle =>
      'New here? Register to request pickups';

  @override
  String get createAccountNote =>
      'Your details are used only to manage your account and coordinate pickups.';

  @override
  String get fullName => 'Full name';

  @override
  String get fullNamePlaceholder => 'Enter your full name';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get phonePlaceholder => 'Enter your mobile number';

  @override
  String get registeredPlaceholder => 'Enter your registered number';

  @override
  String get password => 'Password';

  @override
  String get passwordPlaceholder => 'Enter your password';

  @override
  String get usernameRequired => 'Full name is required';

  @override
  String get usernameMinLength => 'Full name must be at least 3 characters';

  @override
  String get invalidUsername => 'Name can contain only letters and spaces';

  @override
  String get phoneNumberRequired => 'Phone number is required';

  @override
  String get invalidPhoneNumber => 'Enter a valid phone number';

  @override
  String get phoneNumberAlreadyRegistered => 'Phone number already registered';

  @override
  String get phoneNumberNotRegistered => 'Phone number is not registered';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get incorrectPassword => 'Incorrect password';

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
  String get workerIdRequired => 'Worker ID is required';

  @override
  String get signIn => 'Sign in';

  @override
  String get workerNote =>
      'Only workers verified by Purasabhe can accept pickups. Contact your administrator if your account is pending.';

  @override
  String get termsNote =>
      'By continuing, you agree to our Privacy Policy and Terms & Conditions';

  @override
  String get homeHeroTitle => 'Ready to hand it over?';

  @override
  String get homeHeroSubtitle => 'We\'ll take it from here.';

  @override
  String get yourPickups => 'Your pickups';

  @override
  String get noPickupsYet => 'No pickups yet. Your requests will show up here.';

  @override
  String get requestPickup => 'Request Pickup';

  @override
  String get wasteVerification => 'Waste Verification';

  @override
  String get wasteVerificationSubtitle => 'Show us what you\'re handing over';

  @override
  String get addPhoto => 'Add Photo';

  @override
  String get quickCheck => 'Quick Check';

  @override
  String get quickCheckSubtitle =>
      'A quick safety check.\nHelp us prepare for your pickup.';

  @override
  String get sharpObjectsQuestion =>
      'Does the waste contain any sharp objects?';

  @override
  String get expiredMedicineQuestion =>
      'Does the waste include unused or expired medicine?';

  @override
  String get bodyFluidsQuestion =>
      'Does the waste include items that have been in contact with blood or other body fluids?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get next => 'Next';

  @override
  String get continueButton => 'Continue';

  @override
  String get confirmPickup => 'Confirm Pickup';

  @override
  String get locationTitle => 'Let us find you.';

  @override
  String get locationSubtitle =>
      'Enable your location so we can arrange your pickup.';

  @override
  String get allowLocation => 'Allow Location';

  @override
  String get cancel => 'Cancel';

  @override
  String get locationDeniedTitle => 'Location access needed';

  @override
  String get locationDeniedMessage =>
      'Please allow location access in Settings so we can arrange your pickup.';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get confirmPickupRequest => 'Confirm Your Request';

  @override
  String get pickupConfirmationMessage =>
      'Please review the details and confirm your pickup request.';

  @override
  String get pickupConfirmed => 'Pickup Confirmed';

  @override
  String get pickupConfirmedMessage =>
      'Your pickup request has been confirmed successfully.';

  @override
  String get requesting => 'Requesting...';

  @override
  String get done => 'Done';

  @override
  String get profile => 'Profile';

  @override
  String get account => 'Account';

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get changePassword => 'Change Password';

  @override
  String get logOut => 'Log Out';

  @override
  String get points => 'Points';

  @override
  String get availablePickups => 'Available Pickups';

  @override
  String get pickupDetails => 'Pickup Details';

  @override
  String get workerNotFound => 'Worker not found';
}
