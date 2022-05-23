class Constants {
  static final RegExp ethiopianPhoneNumberRegexp = RegExp(r'^\9[0-9]{8}$');
  static const String phoneNumberEmptyError = "Please enter your phone number";
  static const String passwordEmptyError = "Please enter your password";
  static const String passwordTooShortError =
      "Password needs to be at least 6 characters";
  static const String invalidPhoneNumberError =
      "Please enter a valid phone number";
  static const String passwordsDontMatchError = "Passwords don't match";
}
