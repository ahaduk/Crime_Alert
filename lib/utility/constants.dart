import 'package:flutter/material.dart';

class Constants {
  static LinearGradient defaultGradient() {
    return LinearGradient(
      colors: [Colors.blue.shade300, Colors.blue.shade800],
      begin: FractionalOffset.centerLeft,
      end: FractionalOffset.centerRight,
    );
  }

  static final RegExp ethiopianPhoneNumberRegexp = RegExp(r'^\+2519[0-9]{8}$');
  static const String phoneNumberEmptyError = "Please enter your phone number";
  static const String passwordEmptyError = "Please enter your password";
  static const String passwordTooShortError =
      "Password needs to be at least 6 characters";
  static const String invalidPhoneNumberError =
      "Please enter phone number in international format";
  static const String passwordsDontMatchError = "Passwords don't match";
}
