import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_kn.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('kn'),
  ];

  /// No description provided for @portalTitle.
  ///
  /// In en, this message translates to:
  /// **'Safe Medical Waste Pickup'**
  String get portalTitle;

  /// No description provided for @portalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A Purasabhe service connecting households with verified workers for the safe collection of medical waste.'**
  String get portalSubtitle;

  /// No description provided for @selectRole.
  ///
  /// In en, this message translates to:
  /// **'Choose your role to get started.'**
  String get selectRole;

  /// No description provided for @household.
  ///
  /// In en, this message translates to:
  /// **'Household'**
  String get household;

  /// No description provided for @householdSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Arrange a safe medical waste pickup from your home.'**
  String get householdSubtitle;

  /// No description provided for @worker.
  ///
  /// In en, this message translates to:
  /// **'Purasabhe Worker'**
  String get worker;

  /// No description provided for @workerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View, accept, and complete pickup requests.'**
  String get workerSubtitle;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @authSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Arrange a safe and convenient pickup for your household\'s medical waste.'**
  String get authSubtitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get login;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your registered phone number to request a pickup or track an existing request.'**
  String get loginSubtitle;

  /// No description provided for @loginCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Log in to continue.'**
  String get loginCardSubtitle;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Register your household to arrange safe medical waste pickups.'**
  String get createAccountSubtitle;

  /// No description provided for @createAccountCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'New to the service? Create an account to get started.'**
  String get createAccountCardSubtitle;

  /// No description provided for @createAccountNote.
  ///
  /// In en, this message translates to:
  /// **'Your details are used only to manage your account and coordinate pickups.'**
  String get createAccountNote;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @fullNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get fullNamePlaceholder;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @phonePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number'**
  String get phonePlaceholder;

  /// No description provided for @registeredPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter your registered mobile number'**
  String get registeredPlaceholder;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordPlaceholder;

  /// No description provided for @usernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name.'**
  String get usernameRequired;

  /// No description provided for @usernameMinLength.
  ///
  /// In en, this message translates to:
  /// **'Your name must contain at least 3 characters.'**
  String get usernameMinLength;

  /// No description provided for @invalidUsername.
  ///
  /// In en, this message translates to:
  /// **'Use only letters and spaces in your name.'**
  String get invalidUsername;

  /// No description provided for @phoneNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number.'**
  String get phoneNumberRequired;

  /// No description provided for @invalidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number.'**
  String get invalidPhoneNumber;

  /// No description provided for @phoneNumberAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'This phone number is already registered.'**
  String get phoneNumberAlreadyRegistered;

  /// No description provided for @phoneNumberNotRegistered.
  ///
  /// In en, this message translates to:
  /// **'No account was found for this phone number.'**
  String get phoneNumberNotRegistered;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password.'**
  String get passwordRequired;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Your password must contain at least 6 characters.'**
  String get passwordMinLength;

  /// No description provided for @incorrectPassword.
  ///
  /// In en, this message translates to:
  /// **'The password you entered is incorrect.'**
  String get incorrectPassword;

  /// No description provided for @loggingIn.
  ///
  /// In en, this message translates to:
  /// **'Logging in'**
  String get loggingIn;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait'**
  String get pleaseWait;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please try again.'**
  String get loginFailed;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Unable to connect to the server.'**
  String get networkError;

  /// No description provided for @invalidServerResponse.
  ///
  /// In en, this message translates to:
  /// **'Invalid response received from the server.'**
  String get invalidServerResponse;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please log in again.'**
  String get sessionExpired;

  /// No description provided for @unableToLoadAccount.
  ///
  /// In en, this message translates to:
  /// **'Unable to load your account.'**
  String get unableToLoadAccount;

  /// No description provided for @unableToLoadPickupDetails.
  ///
  /// In en, this message translates to:
  /// **'Unable to load pickup details.'**
  String get unableToLoadPickupDetails;

  /// No description provided for @accountCreationFailed.
  ///
  /// In en, this message translates to:
  /// **'Account creation failed.'**
  String get accountCreationFailed;

  /// No description provided for @workerLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Worker Login'**
  String get workerLoginTitle;

  /// No description provided for @workerLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your Purasabhe worker ID to view and accept pickup requests.'**
  String get workerLoginSubtitle;

  /// No description provided for @workerId.
  ///
  /// In en, this message translates to:
  /// **'Worker ID'**
  String get workerId;

  /// No description provided for @workerIdPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter your Purasabhe worker ID'**
  String get workerIdPlaceholder;

  /// No description provided for @workerIdRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your worker ID.'**
  String get workerIdRequired;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @workerNote.
  ///
  /// In en, this message translates to:
  /// **'Only verified Purasabhe workers can accept pickup requests. Contact your administrator if you need help accessing your account.'**
  String get workerNote;

  /// No description provided for @termsNote.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our Privacy Policy and Terms & Conditions.'**
  String get termsNote;

  /// No description provided for @householdHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to hand it over?'**
  String get householdHeroTitle;

  /// No description provided for @householdHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll take care of the rest.'**
  String get householdHeroSubtitle;

  /// No description provided for @householdPickups.
  ///
  /// In en, this message translates to:
  /// **'Your Pickups'**
  String get householdPickups;

  /// No description provided for @workerHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to collect?'**
  String get workerHeroTitle;

  /// No description provided for @workerHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your next pickup is waiting.'**
  String get workerHeroSubtitle;

  /// No description provided for @workerPickups.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Pending Pickups'**
  String get workerPickups;

  /// No description provided for @noPickupsYet.
  ///
  /// In en, this message translates to:
  /// **'No pickups yet. Your requests will appear here once you make one.'**
  String get noPickupsYet;

  /// No description provided for @requestPickup.
  ///
  /// In en, this message translates to:
  /// **'Request a Pickup'**
  String get requestPickup;

  /// No description provided for @wasteVerification.
  ///
  /// In en, this message translates to:
  /// **'Waste Verification'**
  String get wasteVerification;

  /// No description provided for @wasteVerificationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Help us understand the waste you\'re handing over.'**
  String get wasteVerificationSubtitle;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get addPhoto;

  /// No description provided for @quickCheck.
  ///
  /// In en, this message translates to:
  /// **'Quick Safety Check'**
  String get quickCheck;

  /// No description provided for @quickCheckSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Just a few quick questions to help us prepare for your pickup.\nYour answers help workers handle the waste safely.'**
  String get quickCheckSubtitle;

  /// No description provided for @sharpObjectsQuestion.
  ///
  /// In en, this message translates to:
  /// **'Does the waste contain any sharp objects, such as needles or blades?'**
  String get sharpObjectsQuestion;

  /// No description provided for @expiredMedicineQuestion.
  ///
  /// In en, this message translates to:
  /// **'Does the waste contain unused or expired medicines?'**
  String get expiredMedicineQuestion;

  /// No description provided for @bodyFluidsQuestion.
  ///
  /// In en, this message translates to:
  /// **'Does the waste include items that have come into contact with blood or other body fluids?'**
  String get bodyFluidsQuestion;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @confirmPickup.
  ///
  /// In en, this message translates to:
  /// **'Confirm Pickup'**
  String get confirmPickup;

  /// No description provided for @locationTitle.
  ///
  /// In en, this message translates to:
  /// **'Let us find you.'**
  String get locationTitle;

  /// No description provided for @locationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Allow location access so we can arrange your pickup at the right place.'**
  String get locationSubtitle;

  /// No description provided for @allowLocation.
  ///
  /// In en, this message translates to:
  /// **'Allow Location Access'**
  String get allowLocation;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @locationDeniedTitle.
  ///
  /// In en, this message translates to:
  /// **'Location Access Required'**
  String get locationDeniedTitle;

  /// No description provided for @locationDeniedMessage.
  ///
  /// In en, this message translates to:
  /// **'Enable location access in your device settings so we can arrange your pickup.'**
  String get locationDeniedMessage;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @confirmPickupRequest.
  ///
  /// In en, this message translates to:
  /// **'Confirm Your Pickup Request'**
  String get confirmPickupRequest;

  /// No description provided for @pickupConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'Review your request details before confirming your pickup.'**
  String get pickupConfirmationMessage;

  /// No description provided for @pickupConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Pickup Requested Successfully'**
  String get pickupConfirmed;

  /// No description provided for @pickupConfirmedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your pickup request has been submitted successfully.'**
  String get pickupConfirmedMessage;

  /// No description provided for @requesting.
  ///
  /// In en, this message translates to:
  /// **'Submitting Request'**
  String get requesting;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @availablePickups.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Pending Pickups'**
  String get availablePickups;

  /// No description provided for @pickupDetails.
  ///
  /// In en, this message translates to:
  /// **'Pickup Details'**
  String get pickupDetails;

  /// No description provided for @pickupAvailable.
  ///
  /// In en, this message translates to:
  /// **'Pickup Available'**
  String get pickupAvailable;

  /// No description provided for @noAvailablePickups.
  ///
  /// In en, this message translates to:
  /// **'No pickup requests are available right now.'**
  String get noAvailablePickups;

  /// No description provided for @acceptPickup.
  ///
  /// In en, this message translates to:
  /// **'Accept Pickup'**
  String get acceptPickup;

  /// No description provided for @workerNotFound.
  ///
  /// In en, this message translates to:
  /// **'Worker account not found.'**
  String get workerNotFound;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get points;

  /// No description provided for @walletTitle.
  ///
  /// In en, this message translates to:
  /// **'My Wallet'**
  String get walletTitle;

  /// No description provided for @walletSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your points and rewards, all in one place.'**
  String get walletSubtitle;

  /// No description provided for @walletTotalBalance.
  ///
  /// In en, this message translates to:
  /// **'Total Points'**
  String get walletTotalBalance;

  /// No description provided for @walletEarnPoints.
  ///
  /// In en, this message translates to:
  /// **'Earn Points'**
  String get walletEarnPoints;

  /// No description provided for @walletEarnPointsDescription.
  ///
  /// In en, this message translates to:
  /// **'Take part in safe medical waste collection and earn points as you contribute to a cleaner, healthier community. Rewards may be available in the future.'**
  String get walletEarnPointsDescription;

  /// No description provided for @pickupRequestedTitle.
  ///
  /// In en, this message translates to:
  /// **'Pickup Requested'**
  String get pickupRequestedTitle;

  /// No description provided for @pickupRequestedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your request has been submitted.'**
  String get pickupRequestedSubtitle;

  /// No description provided for @verifyYourPickup.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Pickup'**
  String get verifyYourPickup;

  /// No description provided for @pickupQrInstructions.
  ///
  /// In en, this message translates to:
  /// **'When your collection worker arrives, generate your QR code and show it to them to verify the pickup and confirm the handover.'**
  String get pickupQrInstructions;

  /// No description provided for @generateQrCode.
  ///
  /// In en, this message translates to:
  /// **'Generate QR Code'**
  String get generateQrCode;

  /// No description provided for @requestDetails.
  ///
  /// In en, this message translates to:
  /// **'Request Details'**
  String get requestDetails;

  /// No description provided for @recipientLabel.
  ///
  /// In en, this message translates to:
  /// **'Recipient'**
  String get recipientLabel;

  /// No description provided for @pickupIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Pickup ID'**
  String get pickupIdLabel;

  /// No description provided for @requestedTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Requested Time'**
  String get requestedTimeLabel;

  /// No description provided for @pickupIdCopied.
  ///
  /// In en, this message translates to:
  /// **'Pickup ID copied'**
  String get pickupIdCopied;

  /// No description provided for @okButton.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get okButton;

  /// No description provided for @householdRecipient.
  ///
  /// In en, this message translates to:
  /// **'Household'**
  String get householdRecipient;

  /// No description provided for @unavailableValue.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailableValue;

  /// No description provided for @notAvailableValue.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get notAvailableValue;

  /// No description provided for @pickupConfirmationPending.
  ///
  /// In en, this message translates to:
  /// **'You\'re All Set!'**
  String get pickupConfirmationPending;

  /// No description provided for @pickupConfirmationPendingMessage.
  ///
  /// In en, this message translates to:
  /// **'Your pickup is requested. We\'ll let you know when it\'s confirmed.'**
  String get pickupConfirmationPendingMessage;

  /// No description provided for @waitingForPickupConfirmation.
  ///
  /// In en, this message translates to:
  /// **'We\'ll keep you updated'**
  String get waitingForPickupConfirmation;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'kn'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'kn':
      return AppLocalizationsKn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
