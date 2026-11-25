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
      'A Purasabhe service connecting households with verified workers to safely collect medical waste.';

  @override
  String get selectRole => 'Choose your role to get started.';

  @override
  String get household => 'Household';

  @override
  String get householdSubtitle =>
      'Schedule a safe medical waste pickup from your home.';

  @override
  String get worker => 'Purasabhe Worker';

  @override
  String get workerSubtitle => 'View, accept, and complete pickup requests.';

  @override
  String get termsNote =>
      'By continuing, you agree to the Privacy Policy and Terms & Conditions.';

  @override
  String get welcome => 'Welcome';

  @override
  String get authSubtitle =>
      'Schedule a safe, convenient pickup for your household\'s medical waste.';

  @override
  String get login => 'Sign In';

  @override
  String get loginSubtitle =>
      'Enter your registered mobile number to request a pickup or track an existing one.';

  @override
  String get loginCardSubtitle =>
      'Already have an account? Sign in to continue.';

  @override
  String get createAccount => 'Create Account';

  @override
  String get createAccountSubtitle =>
      'Register your household to schedule safe medical waste pickups.';

  @override
  String get createAccountCardSubtitle =>
      'New here? Create an account to get started.';

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
  String get signIn => 'Sign In';

  @override
  String get loggingIn => 'Signing in…';

  @override
  String get pleaseWait => 'Please wait…';

  @override
  String get usernameRequired => 'Enter your full name.';

  @override
  String get usernameMinLength => 'Use at least 3 characters for your name.';

  @override
  String get invalidUsername => 'Use only letters and spaces in your name.';

  @override
  String get phoneNumberRequired => 'Enter your phone number.';

  @override
  String get invalidPhoneNumber => 'Enter a valid mobile number.';

  @override
  String get phoneNumberAlreadyRegistered =>
      'That phone number is already registered.';

  @override
  String get phoneNumberNotRegistered =>
      'No account matches this phone number.';

  @override
  String get passwordRequired => 'Enter your password.';

  @override
  String get passwordMinLength =>
      'Use at least 6 characters for your password.';

  @override
  String get incorrectPassword => 'Incorrect password. Try again.';

  @override
  String get loginFailed => 'Couldn\'t sign you in. Try again.';

  @override
  String get accountCreationFailed => 'Couldn\'t create your account.';

  @override
  String get workerLoginTitle => 'Worker Sign In';

  @override
  String get workerLoginSubtitle =>
      'Sign in with your Purasabhe worker ID to view and accept pickup requests.';

  @override
  String get workerId => 'Worker ID';

  @override
  String get workerIdPlaceholder => 'Enter your Purasabhe worker ID';

  @override
  String get workerIdRequired => 'Enter your worker ID.';

  @override
  String get workerNote =>
      'Only verified Purasabhe workers can accept pickup requests. Contact your administrator if you need help accessing your account.';

  @override
  String get workerNotFound => 'Worker account not found.';

  @override
  String get workerIdentification => 'WORKER IDENTIFICATION';

  @override
  String get workerIdLabel => 'WORKER ID';

  @override
  String get nameLabel => 'NAME';

  @override
  String get profile => 'Profile';

  @override
  String get account => 'Account';

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get changePassword => 'Change Password';

  @override
  String get logOut => 'Sign Out';

  @override
  String get points => 'Points';

  @override
  String get unableToLoadAccount => 'Couldn\'t load your account.';

  @override
  String get walletTitle => 'Wallet';

  @override
  String get walletSubtitle => 'Your points and rewards in one place.';

  @override
  String get walletTotalBalance => 'Total Points';

  @override
  String get walletEarnPoints => 'Earn Points';

  @override
  String get walletEarnPointsDescription =>
      'Take part in safe medical waste collection to earn points toward a cleaner, healthier community. Rewards may be introduced later.';

  @override
  String get householdHeroTitle => 'Ready to hand it over?';

  @override
  String get householdHeroSubtitle => 'We\'ll take care of the rest.';

  @override
  String get householdPickups => 'Your Pickups';

  @override
  String get noPickupsYet =>
      'No pickups yet. Requests you submit will appear here.';

  @override
  String get requestPickup => 'Request Pickup';

  @override
  String get wasteVerification => 'Waste Verification';

  @override
  String get wasteVerificationSubtitle =>
      'Share a few details about the waste you\'re handing over.';

  @override
  String get addPhoto => 'Add Photo';

  @override
  String get quickCheck => 'Quick Safety Check';

  @override
  String get quickCheckSubtitle =>
      'Answer a few quick questions so workers can handle the waste safely.';

  @override
  String get sharpObjectsQuestion =>
      'Does the waste contain sharp objects, such as needles or blades?';

  @override
  String get expiredMedicineQuestion =>
      'Does the waste contain unused or expired medicines?';

  @override
  String get bodyFluidsQuestion =>
      'Does the waste include items that have contacted blood or other body fluids?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get next => 'Next';

  @override
  String get continueButton => 'Continue';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirmPickup => 'Confirm Pickup';

  @override
  String get locationTitle => 'Find Your Location';

  @override
  String get locationSubtitle =>
      'Allow location access so we can schedule your pickup at the right address.';

  @override
  String get allowLocation => 'Allow Location Access';

  @override
  String get locationDeniedTitle => 'Location Access Required';

  @override
  String get locationDeniedMessage =>
      'Turn on location access in Settings so we can schedule your pickup.';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get locationUnavailable => 'Location Unavailable';

  @override
  String get currentLocationUnavailable =>
      'Your current location isn\'t available yet.';

  @override
  String get confirmPickupRequest => 'Confirm Pickup Request';

  @override
  String get pickupConfirmationMessage =>
      'Review your details before confirming the pickup.';

  @override
  String get requesting => 'Submitting…';

  @override
  String get pickupConfirmed => 'Pickup Requested';

  @override
  String get pickupConfirmedMessage =>
      'Your pickup request has been submitted.';

  @override
  String get pickupRequestedTitle => 'Pickup Requested';

  @override
  String get pickupRequestedSubtitle => 'Your request has been submitted.';

  @override
  String get pickupConfirmationPending => 'You\'re All Set';

  @override
  String get pickupConfirmationPendingMessage =>
      'Your request is submitted. We\'ll notify you once it\'s confirmed.';

  @override
  String get waitingForPickupConfirmation => 'Updates will appear here';

  @override
  String get done => 'Done';

  @override
  String get okButton => 'OK';

  @override
  String get pickupDetails => 'Pickup Details';

  @override
  String get requestDetails => 'Request Details';

  @override
  String get recipientLabel => 'Recipient';

  @override
  String get householdRecipient => 'Household';

  @override
  String get pickupIdLabel => 'Pickup ID';

  @override
  String get pickupCodeLabel => 'Pickup Code';

  @override
  String get requestedTimeLabel => 'Requested';

  @override
  String get pickupIdCopied => 'Pickup ID copied';

  @override
  String get pickupCodeCopied => 'Pickup Code copied';

  @override
  String get unavailableValue => 'Unavailable';

  @override
  String get notAvailableValue => 'Not available';

  @override
  String get unableToLoadPickupDetails => 'Couldn\'t load pickup details.';

  @override
  String get workerHeroTitle => 'Ready to collect?';

  @override
  String get workerHeroSubtitle => 'Your next pickup is waiting.';

  @override
  String get workerPickups => 'Today\'s Pending Pickups';

  @override
  String get availablePickups => 'Today\'s Pending Pickups';

  @override
  String get pickupAvailable => 'Available';

  @override
  String get noAvailablePickups => 'No pickup requests available right now.';

  @override
  String get reviewPickupRequest => 'Review Request';

  @override
  String get reviewPickupRequestSubtitle =>
      'Review the details before accepting this pickup.';

  @override
  String get distanceLabel => 'Distance';

  @override
  String get pickupQuestionnaire => 'Safety Checklist';

  @override
  String get acceptPickup => 'Accept Pickup';

  @override
  String pickupAcceptedSubtitle(String username) {
    return 'You accepted the pickup request from $username.';
  }

  @override
  String get myPickups => 'My Pickups';

  @override
  String get manageAcceptedPickups => 'Manage accepted pickup requests.';

  @override
  String get acceptedPickups => 'Accepted Pickups';

  @override
  String get activePickups => 'Active Pickups';

  @override
  String get yourAcceptedPickups => 'Your Accepted Pickups';

  @override
  String get noAcceptedPickups => 'No accepted pickups yet.';

  @override
  String get unableToLoadAcceptedPickups => 'Couldn\'t load accepted pickups.';

  @override
  String get preparingMap => 'Preparing Map';

  @override
  String get loadingMapDescription =>
      'Finding your location and loading pickup details…';

  @override
  String get routeDetails => 'Route Details';

  @override
  String get pickupRouteReady => 'Your route is ready.';

  @override
  String get estimatedArrival => 'Estimated arrival';

  @override
  String get roadDistance => 'Road distance';

  @override
  String get startNavigation => 'Start Navigation';

  @override
  String get unableToStartNavigation => 'Couldn\'t start navigation.';

  @override
  String get rerouting => 'Rerouting…';

  @override
  String get arrivedAtDestination => 'You have arrived at your destination';

  @override
  String get continueOnRoute => 'Continue on route';

  @override
  String get findingNewRoute => 'Finding a new route';

  @override
  String get destinationReached => 'Destination reached';

  @override
  String get remaining => 'Remaining';

  @override
  String get arrival => 'Arrival';

  @override
  String get endNavigation => 'End Navigation';

  @override
  String get verifyYourPickup => 'Verify Pickup';

  @override
  String get pickupQrInstructions =>
      'Generate your QR code when the worker arrives and show it to confirm the handover.';

  @override
  String get generateQrCode => 'Generate QR Code';

  @override
  String get verifyPickup => 'Verify Pickup';

  @override
  String get scanHouseholdQrCode => 'Scan Household QR Code';

  @override
  String get scanHouseholdQrInstructions =>
      'Ask the household to show their pickup QR code, then scan it to verify the handover.';

  @override
  String get scanQrCode => 'Scan QR';

  @override
  String get positionQrCode => 'Align the QR code within the frame.';

  @override
  String get cameraUnavailable => 'Camera Unavailable';

  @override
  String get unableToAccessCamera => 'Couldn\'t access the camera.';

  @override
  String get orLabel => 'OR';

  @override
  String get cantScanQr => 'Can\'t scan the QR code?';

  @override
  String get enterPickupVerificationCode =>
      'Enter the 6-digit verification code.';

  @override
  String get verifyCode => 'Verify Code';

  @override
  String get tryAnotherWay => 'Try Another Way';

  @override
  String get verifyingCollection => 'Verifying collection…';

  @override
  String get verifyingCodeMessage => 'Verifying code…';

  @override
  String get collectionAlreadyProcessing =>
      'Collection is already in progress.';

  @override
  String get incorrectVerificationCode => 'Incorrect code. Try again.';

  @override
  String get verificationCodeUnavailable => 'Verification code unavailable.';

  @override
  String get pickupNoLongerAvailable => 'This pickup is no longer available.';

  @override
  String get unauthorizedCollection =>
      'You aren\'t authorized to collect this pickup.';

  @override
  String get collectionVerificationFailed =>
      'Couldn\'t verify collection. Try again.';

  @override
  String get collectionConfirmed => 'Collection Confirmed';

  @override
  String get pickupCollectedSuccessfully => 'Pickup Collected';

  @override
  String get collectionVerifiedMessage => 'Collection verified.';

  @override
  String get serverDownTitle => 'Service Temporarily Unavailable';

  @override
  String get serverDownDescription =>
      'Our servers are down right now. We\'re working to restore everything quickly.';

  @override
  String get serverDownWhatCanYouDo => 'What You Can Do';

  @override
  String get serverDownInstructions =>
      'Nothing needs to be changed on your device. Wait a moment and try again.';

  @override
  String get serverDownRetry => 'Try Again';

  @override
  String get serverDownFooter => 'Thanks for your patience.';

  @override
  String get networkError => 'Can\'t connect to the server.';

  @override
  String get serverConnectionError => 'Can\'t connect to the server.';

  @override
  String get invalidServerResponse =>
      'Received an invalid response from the server.';

  @override
  String get sessionExpired =>
      'Your session expired. Sign in again to continue.';

  @override
  String get somethingWentWrong => 'Something went wrong.';

  @override
  String get tryAgain => 'Try Again';
}
