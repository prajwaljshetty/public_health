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
  /// **'A Purasabhe service connecting households with verified workers to safely collect medical waste.'**
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
  /// **'Schedule a safe medical waste pickup from your home.'**
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

  /// No description provided for @termsNote.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to the Privacy Policy and Terms & Conditions.'**
  String get termsNote;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @authSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Schedule a safe, convenient pickup for your household\'s medical waste.'**
  String get authSubtitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get login;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your registered mobile number to request a pickup or track an existing one.'**
  String get loginSubtitle;

  /// No description provided for @loginCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in to continue.'**
  String get loginCardSubtitle;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Register your household to schedule safe medical waste pickups.'**
  String get createAccountSubtitle;

  /// No description provided for @createAccountCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'New here? Create an account to get started.'**
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

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @loggingIn.
  ///
  /// In en, this message translates to:
  /// **'Signing in…'**
  String get loggingIn;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait…'**
  String get pleaseWait;

  /// No description provided for @usernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name.'**
  String get usernameRequired;

  /// No description provided for @usernameMinLength.
  ///
  /// In en, this message translates to:
  /// **'Use at least 3 characters for your name.'**
  String get usernameMinLength;

  /// No description provided for @invalidUsername.
  ///
  /// In en, this message translates to:
  /// **'Use only letters and spaces in your name.'**
  String get invalidUsername;

  /// No description provided for @phoneNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number.'**
  String get phoneNumberRequired;

  /// No description provided for @invalidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid mobile number.'**
  String get invalidPhoneNumber;

  /// No description provided for @phoneNumberAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'That phone number is already registered.'**
  String get phoneNumberAlreadyRegistered;

  /// No description provided for @phoneNumberNotRegistered.
  ///
  /// In en, this message translates to:
  /// **'No account matches this phone number.'**
  String get phoneNumberNotRegistered;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your password.'**
  String get passwordRequired;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Use at least 6 characters for your password.'**
  String get passwordMinLength;

  /// No description provided for @incorrectPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password. Try again.'**
  String get incorrectPassword;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t sign you in. Try again.'**
  String get loginFailed;

  /// No description provided for @accountCreationFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t create your account.'**
  String get accountCreationFailed;

  /// No description provided for @workerLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Worker Sign In'**
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
  /// **'Enter your worker ID.'**
  String get workerIdRequired;

  /// No description provided for @workerNote.
  ///
  /// In en, this message translates to:
  /// **'Only verified Purasabhe workers can accept pickup requests. Contact your administrator if you need help accessing your account.'**
  String get workerNote;

  /// No description provided for @workerNotFound.
  ///
  /// In en, this message translates to:
  /// **'Worker account not found.'**
  String get workerNotFound;

  /// No description provided for @workerIdentification.
  ///
  /// In en, this message translates to:
  /// **'WORKER IDENTIFICATION'**
  String get workerIdentification;

  /// No description provided for @workerIdLabel.
  ///
  /// In en, this message translates to:
  /// **'WORKER ID'**
  String get workerIdLabel;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'NAME'**
  String get nameLabel;

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
  /// **'Sign Out'**
  String get logOut;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get points;

  /// No description provided for @unableToLoadAccount.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your account.'**
  String get unableToLoadAccount;

  /// No description provided for @walletTitle.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get walletTitle;

  /// No description provided for @walletSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your points and rewards in one place.'**
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
  /// **'Take part in safe medical waste collection to earn points toward a cleaner, healthier community. Rewards may be introduced later.'**
  String get walletEarnPointsDescription;

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

  /// No description provided for @noPickupsYet.
  ///
  /// In en, this message translates to:
  /// **'No pickups yet. Requests you submit will appear here.'**
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
  /// **'Share a few details about the waste you\'re handing over.'**
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
  /// **'Answer a few quick questions so workers can handle the waste safely.'**
  String get quickCheckSubtitle;

  /// No description provided for @sharpObjectsQuestion.
  ///
  /// In en, this message translates to:
  /// **'Does the waste contain sharp objects, such as needles or blades?'**
  String get sharpObjectsQuestion;

  /// No description provided for @expiredMedicineQuestion.
  ///
  /// In en, this message translates to:
  /// **'Does the waste contain unused or expired medicines?'**
  String get expiredMedicineQuestion;

  /// No description provided for @bodyFluidsQuestion.
  ///
  /// In en, this message translates to:
  /// **'Does the waste include items that have contacted blood or other body fluids?'**
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

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirmPickup.
  ///
  /// In en, this message translates to:
  /// **'Confirm Pickup'**
  String get confirmPickup;

  /// No description provided for @locationTitle.
  ///
  /// In en, this message translates to:
  /// **'Find Your Location'**
  String get locationTitle;

  /// No description provided for @locationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Allow location access so we can schedule your pickup at the right address.'**
  String get locationSubtitle;

  /// No description provided for @allowLocation.
  ///
  /// In en, this message translates to:
  /// **'Allow Location Access'**
  String get allowLocation;

  /// No description provided for @locationDeniedTitle.
  ///
  /// In en, this message translates to:
  /// **'Location Access Required'**
  String get locationDeniedTitle;

  /// No description provided for @locationDeniedMessage.
  ///
  /// In en, this message translates to:
  /// **'Turn on location access in Settings so we can schedule your pickup.'**
  String get locationDeniedMessage;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @locationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Location Unavailable'**
  String get locationUnavailable;

  /// No description provided for @currentLocationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Your current location isn\'t available yet.'**
  String get currentLocationUnavailable;

  /// No description provided for @confirmPickupRequest.
  ///
  /// In en, this message translates to:
  /// **'Confirm Pickup Request'**
  String get confirmPickupRequest;

  /// No description provided for @pickupConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'Review your details before confirming the pickup.'**
  String get pickupConfirmationMessage;

  /// No description provided for @requesting.
  ///
  /// In en, this message translates to:
  /// **'Submitting…'**
  String get requesting;

  /// No description provided for @pickupConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Pickup Requested'**
  String get pickupConfirmed;

  /// No description provided for @pickupConfirmedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your pickup request has been submitted.'**
  String get pickupConfirmedMessage;

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

  /// No description provided for @pickupConfirmationPending.
  ///
  /// In en, this message translates to:
  /// **'You\'re All Set'**
  String get pickupConfirmationPending;

  /// No description provided for @pickupConfirmationPendingMessage.
  ///
  /// In en, this message translates to:
  /// **'Your request is submitted. We\'ll notify you once it\'s confirmed.'**
  String get pickupConfirmationPendingMessage;

  /// No description provided for @waitingForPickupConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Updates will appear here'**
  String get waitingForPickupConfirmation;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @okButton.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get okButton;

  /// No description provided for @pickupDetails.
  ///
  /// In en, this message translates to:
  /// **'Pickup Details'**
  String get pickupDetails;

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

  /// No description provided for @householdRecipient.
  ///
  /// In en, this message translates to:
  /// **'Household'**
  String get householdRecipient;

  /// No description provided for @pickupIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Pickup ID'**
  String get pickupIdLabel;

  /// No description provided for @pickupCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Pickup Code'**
  String get pickupCodeLabel;

  /// No description provided for @requestedTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Requested'**
  String get requestedTimeLabel;

  /// No description provided for @pickupIdCopied.
  ///
  /// In en, this message translates to:
  /// **'Pickup ID copied'**
  String get pickupIdCopied;

  /// No description provided for @pickupCodeCopied.
  ///
  /// In en, this message translates to:
  /// **'Pickup Code copied'**
  String get pickupCodeCopied;

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

  /// No description provided for @unableToLoadPickupDetails.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load pickup details.'**
  String get unableToLoadPickupDetails;

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

  /// No description provided for @availablePickups.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Pending Pickups'**
  String get availablePickups;

  /// No description provided for @pickupAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get pickupAvailable;

  /// No description provided for @noAvailablePickups.
  ///
  /// In en, this message translates to:
  /// **'No pickup requests available right now.'**
  String get noAvailablePickups;

  /// No description provided for @reviewPickupRequest.
  ///
  /// In en, this message translates to:
  /// **'Review Request'**
  String get reviewPickupRequest;

  /// No description provided for @reviewPickupRequestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review the details before accepting this pickup.'**
  String get reviewPickupRequestSubtitle;

  /// No description provided for @distanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distanceLabel;

  /// No description provided for @pickupQuestionnaire.
  ///
  /// In en, this message translates to:
  /// **'Safety Checklist'**
  String get pickupQuestionnaire;

  /// No description provided for @acceptPickup.
  ///
  /// In en, this message translates to:
  /// **'Accept Pickup'**
  String get acceptPickup;

  /// No description provided for @pickupAcceptedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You accepted the pickup request from {username}.'**
  String pickupAcceptedSubtitle(String username);

  /// No description provided for @myPickups.
  ///
  /// In en, this message translates to:
  /// **'My Pickups'**
  String get myPickups;

  /// No description provided for @manageAcceptedPickups.
  ///
  /// In en, this message translates to:
  /// **'Manage accepted pickup requests.'**
  String get manageAcceptedPickups;

  /// No description provided for @acceptedPickups.
  ///
  /// In en, this message translates to:
  /// **'Accepted Pickups'**
  String get acceptedPickups;

  /// No description provided for @activePickups.
  ///
  /// In en, this message translates to:
  /// **'Active Pickups'**
  String get activePickups;

  /// No description provided for @yourAcceptedPickups.
  ///
  /// In en, this message translates to:
  /// **'Your Accepted Pickups'**
  String get yourAcceptedPickups;

  /// No description provided for @noAcceptedPickups.
  ///
  /// In en, this message translates to:
  /// **'No accepted pickups yet.'**
  String get noAcceptedPickups;

  /// No description provided for @unableToLoadAcceptedPickups.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load accepted pickups.'**
  String get unableToLoadAcceptedPickups;

  /// No description provided for @preparingMap.
  ///
  /// In en, this message translates to:
  /// **'Preparing Map'**
  String get preparingMap;

  /// No description provided for @loadingMapDescription.
  ///
  /// In en, this message translates to:
  /// **'Finding your location and loading pickup details…'**
  String get loadingMapDescription;

  /// No description provided for @routeDetails.
  ///
  /// In en, this message translates to:
  /// **'Route Details'**
  String get routeDetails;

  /// No description provided for @pickupRouteReady.
  ///
  /// In en, this message translates to:
  /// **'Your route is ready.'**
  String get pickupRouteReady;

  /// No description provided for @estimatedArrival.
  ///
  /// In en, this message translates to:
  /// **'Estimated arrival'**
  String get estimatedArrival;

  /// No description provided for @roadDistance.
  ///
  /// In en, this message translates to:
  /// **'Road distance'**
  String get roadDistance;

  /// No description provided for @startNavigation.
  ///
  /// In en, this message translates to:
  /// **'Start Navigation'**
  String get startNavigation;

  /// No description provided for @unableToStartNavigation.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t start navigation.'**
  String get unableToStartNavigation;

  /// No description provided for @rerouting.
  ///
  /// In en, this message translates to:
  /// **'Rerouting…'**
  String get rerouting;

  /// No description provided for @arrivedAtDestination.
  ///
  /// In en, this message translates to:
  /// **'You have arrived at your destination'**
  String get arrivedAtDestination;

  /// No description provided for @continueOnRoute.
  ///
  /// In en, this message translates to:
  /// **'Continue on route'**
  String get continueOnRoute;

  /// No description provided for @findingNewRoute.
  ///
  /// In en, this message translates to:
  /// **'Finding a new route'**
  String get findingNewRoute;

  /// No description provided for @destinationReached.
  ///
  /// In en, this message translates to:
  /// **'Destination reached'**
  String get destinationReached;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @arrival.
  ///
  /// In en, this message translates to:
  /// **'Arrival'**
  String get arrival;

  /// No description provided for @endNavigation.
  ///
  /// In en, this message translates to:
  /// **'End Navigation'**
  String get endNavigation;

  /// No description provided for @verifyYourPickup.
  ///
  /// In en, this message translates to:
  /// **'Verify Pickup'**
  String get verifyYourPickup;

  /// No description provided for @pickupQrInstructions.
  ///
  /// In en, this message translates to:
  /// **'Generate your QR code when the worker arrives and show it to confirm the handover.'**
  String get pickupQrInstructions;

  /// No description provided for @generateQrCode.
  ///
  /// In en, this message translates to:
  /// **'Generate QR Code'**
  String get generateQrCode;

  /// No description provided for @verifyPickup.
  ///
  /// In en, this message translates to:
  /// **'Verify Pickup'**
  String get verifyPickup;

  /// No description provided for @scanHouseholdQrCode.
  ///
  /// In en, this message translates to:
  /// **'Scan Household QR Code'**
  String get scanHouseholdQrCode;

  /// No description provided for @scanHouseholdQrInstructions.
  ///
  /// In en, this message translates to:
  /// **'Ask the household to show their pickup QR code, then scan it to verify the handover.'**
  String get scanHouseholdQrInstructions;

  /// No description provided for @scanQrCode.
  ///
  /// In en, this message translates to:
  /// **'Scan QR'**
  String get scanQrCode;

  /// No description provided for @positionQrCode.
  ///
  /// In en, this message translates to:
  /// **'Align the QR code within the frame.'**
  String get positionQrCode;

  /// No description provided for @cameraUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Camera Unavailable'**
  String get cameraUnavailable;

  /// No description provided for @unableToAccessCamera.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t access the camera.'**
  String get unableToAccessCamera;

  /// No description provided for @orLabel.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get orLabel;

  /// No description provided for @cantScanQr.
  ///
  /// In en, this message translates to:
  /// **'Can\'t scan the QR code?'**
  String get cantScanQr;

  /// No description provided for @enterPickupVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit verification code.'**
  String get enterPickupVerificationCode;

  /// No description provided for @verifyCode.
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get verifyCode;

  /// No description provided for @tryAnotherWay.
  ///
  /// In en, this message translates to:
  /// **'Try Another Way'**
  String get tryAnotherWay;

  /// No description provided for @verifyingCollection.
  ///
  /// In en, this message translates to:
  /// **'Verifying collection…'**
  String get verifyingCollection;

  /// No description provided for @verifyingCodeMessage.
  ///
  /// In en, this message translates to:
  /// **'Verifying code…'**
  String get verifyingCodeMessage;

  /// No description provided for @collectionAlreadyProcessing.
  ///
  /// In en, this message translates to:
  /// **'Collection is already in progress.'**
  String get collectionAlreadyProcessing;

  /// No description provided for @incorrectVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Incorrect code. Try again.'**
  String get incorrectVerificationCode;

  /// No description provided for @verificationCodeUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Verification code unavailable.'**
  String get verificationCodeUnavailable;

  /// No description provided for @pickupNoLongerAvailable.
  ///
  /// In en, this message translates to:
  /// **'This pickup is no longer available.'**
  String get pickupNoLongerAvailable;

  /// No description provided for @unauthorizedCollection.
  ///
  /// In en, this message translates to:
  /// **'You aren\'t authorized to collect this pickup.'**
  String get unauthorizedCollection;

  /// No description provided for @collectionVerificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t verify collection. Try again.'**
  String get collectionVerificationFailed;

  /// No description provided for @collectionConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Collection Confirmed'**
  String get collectionConfirmed;

  /// No description provided for @pickupCollectedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Pickup Collected'**
  String get pickupCollectedSuccessfully;

  /// No description provided for @collectionVerifiedMessage.
  ///
  /// In en, this message translates to:
  /// **'Collection verified.'**
  String get collectionVerifiedMessage;

  /// No description provided for @serverDownTitle.
  ///
  /// In en, this message translates to:
  /// **'Service Temporarily Unavailable'**
  String get serverDownTitle;

  /// No description provided for @serverDownDescription.
  ///
  /// In en, this message translates to:
  /// **'Our servers are down right now. We\'re working to restore everything quickly.'**
  String get serverDownDescription;

  /// No description provided for @serverDownWhatCanYouDo.
  ///
  /// In en, this message translates to:
  /// **'What You Can Do'**
  String get serverDownWhatCanYouDo;

  /// No description provided for @serverDownInstructions.
  ///
  /// In en, this message translates to:
  /// **'Nothing needs to be changed on your device. Wait a moment and try again.'**
  String get serverDownInstructions;

  /// No description provided for @serverDownRetry.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get serverDownRetry;

  /// No description provided for @serverDownFooter.
  ///
  /// In en, this message translates to:
  /// **'Thanks for your patience.'**
  String get serverDownFooter;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Can\'t connect to the server.'**
  String get networkError;

  /// No description provided for @serverConnectionError.
  ///
  /// In en, this message translates to:
  /// **'Can\'t connect to the server.'**
  String get serverConnectionError;

  /// No description provided for @invalidServerResponse.
  ///
  /// In en, this message translates to:
  /// **'Received an invalid response from the server.'**
  String get invalidServerResponse;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session expired. Sign in again to continue.'**
  String get sessionExpired;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong.'**
  String get somethingWentWrong;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;
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
