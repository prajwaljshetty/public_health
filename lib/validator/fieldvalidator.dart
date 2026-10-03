import 'package:public_health/l10n/app_localizations.dart';

class FieldValidators {
  static String? username(String value, AppLocalizations l10n) {
    if (value.trim().isEmpty) {
      return l10n.usernameRequired;
    }

    if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value.trim())) {
      return l10n.invalidUsername;
    }

    if (value.trim().length < 3) {
      return l10n.usernameMinLength;
    }

    return null;
  }

  static String? workerId(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.workerIdRequired;
    }

    return null;
  }

  static String? phoneNumber(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.phoneNumberRequired;
    }

    if (!RegExp(r'^[0-9]{10}$').hasMatch(value.trim())) {
      return l10n.invalidPhoneNumber;
    }

    return null;
  }

  static String? password(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.passwordRequired;
    }

    if (value.length < 6) {
      return l10n.passwordMinLength;
    }

    return null;
  }
}
