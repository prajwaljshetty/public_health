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
  /// **'A Purasabhe service connecting households with verified workers for safe collection of medical waste'**
  String get portalSubtitle;

  /// No description provided for @selectRole.
  ///
  /// In en, this message translates to:
  /// **'Please select your role to continue'**
  String get selectRole;

  /// No description provided for @household.
  ///
  /// In en, this message translates to:
  /// **'Household'**
  String get household;

  /// No description provided for @householdSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Request a medical waste pickup'**
  String get householdSubtitle;

  /// No description provided for @worker.
  ///
  /// In en, this message translates to:
  /// **'Purasabhe Worker'**
  String get worker;

  /// No description provided for @workerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Accept and collect pickup requests'**
  String get workerSubtitle;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @authSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Request safe pickup of your household medical waste'**
  String get authSubtitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your registered phone number to request or track a pickup'**
  String get loginSubtitle;

  /// No description provided for @loginCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Already registered? Continue to your account'**
  String get loginCardSubtitle;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Register to request medical waste pickups from your home'**
  String get createAccountSubtitle;

  /// No description provided for @createAccountCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'New here? Register to request pickups'**
  String get createAccountCardSubtitle;

  /// No description provided for @createAccountNote.
  ///
  /// In en, this message translates to:
  /// **'Your details are used only to manage your account and coordinate pickups.'**
  String get createAccountNote;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @fullNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get fullNamePlaceholder;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @phonePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number'**
  String get phonePlaceholder;

  /// No description provided for @registeredPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter your registered number'**
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
  /// **'Full name is required'**
  String get usernameRequired;

  /// No description provided for @usernameMinLength.
  ///
  /// In en, this message translates to:
  /// **'Full name must be at least 3 characters'**
  String get usernameMinLength;

  /// No description provided for @invalidUsername.
  ///
  /// In en, this message translates to:
  /// **'Name can contain only letters and spaces'**
  String get invalidUsername;

  /// No description provided for @phoneNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneNumberRequired;

  /// No description provided for @invalidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get invalidPhoneNumber;

  /// No description provided for @phoneNumberAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'Phone number already registered'**
  String get phoneNumberAlreadyRegistered;

  /// No description provided for @phoneNumberNotRegistered.
  ///
  /// In en, this message translates to:
  /// **'Phone number is not registered'**
  String get phoneNumberNotRegistered;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @incorrectPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password'**
  String get incorrectPassword;

  /// No description provided for @workerLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Worker login'**
  String get workerLoginTitle;

  /// No description provided for @workerLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your Purasabhe worker ID to view and accept pickup requests'**
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
  /// **'Worker ID is required'**
  String get workerIdRequired;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @workerNote.
  ///
  /// In en, this message translates to:
  /// **'Only workers verified by Purasabhe can accept pickups. Contact your administrator if your account is pending.'**
  String get workerNote;

  /// No description provided for @termsNote.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our Privacy Policy and Terms & Conditions'**
  String get termsNote;

  /// No description provided for @homeHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to hand it over?'**
  String get homeHeroTitle;

  /// No description provided for @homeHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll take it from here.'**
  String get homeHeroSubtitle;

  /// No description provided for @yourPickups.
  ///
  /// In en, this message translates to:
  /// **'Your pickups'**
  String get yourPickups;

  /// No description provided for @noPickupsYet.
  ///
  /// In en, this message translates to:
  /// **'No pickups yet. Your requests will show up here.'**
  String get noPickupsYet;

  /// No description provided for @requestPickup.
  ///
  /// In en, this message translates to:
  /// **'Request Pickup'**
  String get requestPickup;

  /// No description provided for @wasteVerification.
  ///
  /// In en, this message translates to:
  /// **'Waste Verification'**
  String get wasteVerification;

  /// No description provided for @wasteVerificationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show us what you\'re handing over'**
  String get wasteVerificationSubtitle;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get addPhoto;

  /// No description provided for @quickCheck.
  ///
  /// In en, this message translates to:
  /// **'Quick Check'**
  String get quickCheck;

  /// No description provided for @quickCheckSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A quick safety check.\nHelp us prepare for your pickup.'**
  String get quickCheckSubtitle;

  /// No description provided for @sharpObjectsQuestion.
  ///
  /// In en, this message translates to:
  /// **'Does the waste contain any sharp objects?'**
  String get sharpObjectsQuestion;

  /// No description provided for @expiredMedicineQuestion.
  ///
  /// In en, this message translates to:
  /// **'Does the waste include unused or expired medicine?'**
  String get expiredMedicineQuestion;

  /// No description provided for @bodyFluidsQuestion.
  ///
  /// In en, this message translates to:
  /// **'Does the waste include items that have been in contact with blood or other body fluids?'**
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
  /// **'Enable your location so we can arrange your pickup.'**
  String get locationSubtitle;

  /// No description provided for @allowLocation.
  ///
  /// In en, this message translates to:
  /// **'Allow Location'**
  String get allowLocation;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @locationDeniedTitle.
  ///
  /// In en, this message translates to:
  /// **'Location access needed'**
  String get locationDeniedTitle;

  /// No description provided for @locationDeniedMessage.
  ///
  /// In en, this message translates to:
  /// **'Please allow location access in Settings so we can arrange your pickup.'**
  String get locationDeniedMessage;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @confirmPickupRequest.
  ///
  /// In en, this message translates to:
  /// **'Confirm Your Request'**
  String get confirmPickupRequest;

  /// No description provided for @pickupConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'Please review the details and confirm your pickup request.'**
  String get pickupConfirmationMessage;

  /// No description provided for @pickupConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Pickup Confirmed'**
  String get pickupConfirmed;

  /// No description provided for @pickupConfirmedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your pickup request has been confirmed successfully.'**
  String get pickupConfirmedMessage;

  /// No description provided for @requesting.
  ///
  /// In en, this message translates to:
  /// **'Requesting...'**
  String get requesting;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

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

  /// No description provided for @availablePickups.
  ///
  /// In en, this message translates to:
  /// **'Available Pickups'**
  String get availablePickups;
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
