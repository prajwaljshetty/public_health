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
      'A Purasabhe service connecting households with verified workers for the safe collection of medical waste.';

  @override
  String get selectRole => 'Choose your role to get started.';

  @override
  String get household => 'Household';

  @override
  String get householdSubtitle =>
      'Arrange a safe medical waste pickup from your home.';

  @override
  String get worker => 'Purasabhe Worker';

  @override
  String get workerSubtitle => 'View, accept, and complete pickup requests.';

  @override
  String get welcome => 'Welcome';

  @override
  String get authSubtitle =>
      'Arrange a safe and convenient pickup for your household\'s medical waste.';

  @override
  String get login => 'Log In';

  @override
  String get loginSubtitle =>
      'Enter your registered phone number to request a pickup or track an existing request.';

  @override
  String get loginCardSubtitle =>
      'Already have an account? Log in to continue.';

  @override
  String get createAccount => 'Create Account';

  @override
  String get createAccountSubtitle =>
      'Register your household to arrange safe medical waste pickups.';

  @override
  String get createAccountCardSubtitle =>
      'New to the service? Create an account to get started.';

  @override
  String get createAccountNote =>
      'Your details are used only to manage your account and coordinate pickups.';

  @override
  String get fullName => 'Full Name';

  @override
  String get fullNamePlaceholder => 'Enter your full name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get phonePlaceholder => 'Enter your mobile number';

  @override
  String get registeredPlaceholder => 'Enter your registered mobile number';

  @override
  String get password => 'Password';

  @override
  String get passwordPlaceholder => 'Enter your password';

  @override
  String get usernameRequired => 'Please enter your full name.';

  @override
  String get usernameMinLength =>
      'Your name must contain at least 3 characters.';

  @override
  String get invalidUsername => 'Use only letters and spaces in your name.';

  @override
  String get phoneNumberRequired => 'Please enter your phone number.';

  @override
  String get invalidPhoneNumber => 'Please enter a valid phone number.';

  @override
  String get phoneNumberAlreadyRegistered =>
      'This phone number is already registered.';

  @override
  String get phoneNumberNotRegistered =>
      'No account was found for this phone number.';

  @override
  String get passwordRequired => 'Please enter your password.';

  @override
  String get passwordMinLength =>
      'Your password must contain at least 6 characters.';

  @override
  String get incorrectPassword => 'The password you entered is incorrect.';

  @override
  String get loggingIn => 'Logging in';

  @override
  String get pleaseWait => 'Please wait';

  @override
  String get loginFailed => 'Login failed. Please try again.';

  @override
  String get networkError => 'Unable to connect to the server.';

  @override
  String get invalidServerResponse =>
      'Invalid response received from the server.';

  @override
  String get sessionExpired => 'Your session has expired. Please log in again.';

  @override
  String get unableToLoadAccount => 'Unable to load your account.';

  @override
  String get unableToLoadPickupDetails => 'Unable to load pickup details.';

  @override
  String get accountCreationFailed => 'Account creation failed.';

  @override
  String get workerLoginTitle => 'Worker Login';

  @override
  String get workerLoginSubtitle =>
      'Sign in with your Purasabhe worker ID to view and accept pickup requests.';

  @override
  String get workerId => 'Worker ID';

  @override
  String get workerIdPlaceholder => 'Enter your Purasabhe worker ID';

  @override
  String get workerIdRequired => 'Please enter your worker ID.';

  @override
  String get signIn => 'Sign In';

  @override
  String get workerNote =>
      'Only verified Purasabhe workers can accept pickup requests. Contact your administrator if you need help accessing your account.';

  @override
  String get termsNote =>
      'By continuing, you agree to our Privacy Policy and Terms & Conditions.';

  @override
  String get householdHeroTitle => 'Ready to hand it over?';

  @override
  String get householdHeroSubtitle => 'We\'ll take care of the rest.';

  @override
  String get householdPickups => 'Your Pickups';

  @override
  String get workerHeroTitle => 'Ready to collect?';

  @override
  String get workerHeroSubtitle => 'Your next pickup is waiting.';

  @override
  String get workerPickups => 'Today\'s Pending Pickups';

  @override
  String get noPickupsYet =>
      'No pickups yet. Your requests will appear here once you make one.';

  @override
  String get requestPickup => 'Request a Pickup';

  @override
  String get wasteVerification => 'Waste Verification';

  @override
  String get wasteVerificationSubtitle =>
      'Help us understand the waste you\'re handing over.';

  @override
  String get addPhoto => 'Add Photo';

  @override
  String get quickCheck => 'Quick Safety Check';

  @override
  String get quickCheckSubtitle =>
      'Just a few quick questions to help us prepare for your pickup.\nYour answers help workers handle the waste safely.';

  @override
  String get sharpObjectsQuestion =>
      'Does the waste contain any sharp objects, such as needles or blades?';

  @override
  String get expiredMedicineQuestion =>
      'Does the waste contain unused or expired medicines?';

  @override
  String get bodyFluidsQuestion =>
      'Does the waste include items that have come into contact with blood or other body fluids?';

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
      'Allow location access so we can arrange your pickup at the right place.';

  @override
  String get allowLocation => 'Allow Location Access';

  @override
  String get cancel => 'Cancel';

  @override
  String get locationDeniedTitle => 'Location Access Required';

  @override
  String get locationDeniedMessage =>
      'Enable location access in your device settings so we can arrange your pickup.';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get confirmPickupRequest => 'Confirm Your Pickup Request';

  @override
  String get pickupConfirmationMessage =>
      'Review your request details before confirming your pickup.';

  @override
  String get pickupConfirmed => 'Pickup Requested Successfully';

  @override
  String get pickupConfirmedMessage =>
      'Your pickup request has been submitted successfully.';

  @override
  String get requesting => 'Submitting Request';

  @override
  String get done => 'Done';

  @override
  String get availablePickups => 'Today\'s Pending Pickups';

  @override
  String get pickupDetails => 'Pickup Details';

  @override
  String get pickupAvailable => 'Pickup Available';

  @override
  String get noAvailablePickups =>
      'No pickup requests are available right now.';

  @override
  String get acceptPickup => 'Accept Pickup';

  @override
  String get workerNotFound => 'Worker account not found.';

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
  String get walletTitle => 'My Wallet';

  @override
  String get walletSubtitle => 'Your points and rewards, all in one place.';

  @override
  String get walletTotalBalance => 'Total Points';

  @override
  String get walletEarnPoints => 'Earn Points';

  @override
  String get walletEarnPointsDescription =>
      'Take part in safe medical waste collection and earn points as you contribute to a cleaner, healthier community. Rewards may be available in the future.';

  @override
  String get pickupRequestedTitle => 'Pickup Requested';

  @override
  String get pickupRequestedSubtitle => 'Your request has been submitted.';

  @override
  String get verifyYourPickup => 'Verify Your Pickup';

  @override
  String get pickupQrInstructions =>
      'When your collection worker arrives, generate your QR code and show it to them to verify the pickup and confirm the handover.';

  @override
  String get generateQrCode => 'Generate QR Code';

  @override
  String get requestDetails => 'Request Details';

  @override
  String get recipientLabel => 'Recipient';

  @override
  String get pickupIdLabel => 'Pickup ID';

  @override
  String get requestedTimeLabel => 'Requested Time';

  @override
  String get pickupIdCopied => 'Pickup ID copied';

  @override
  String get okButton => 'OK';

  @override
  String get householdRecipient => 'Household';

  @override
  String get unavailableValue => 'Unavailable';

  @override
  String get notAvailableValue => 'Not available';
}
