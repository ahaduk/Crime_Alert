import 'package:flutter/material.dart';

class Constants {
  static final cardBoxDecoration = BoxDecoration(
    color: Colors.white,
    border: Border.all(color: const Color.fromARGB(255, 225, 224, 224)),
    borderRadius: const BorderRadius.all(Radius.circular(10)),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.9),
        spreadRadius: 1,
        blurRadius: 4,
        offset: const Offset(0, 5), // changes position of shadow
      ),
    ],
  );
  static final RegExp ethiopianPhoneNumberRegexp = RegExp(r'^\9[0-9]{8}$');
  static const String phoneNumberEmptyError = "Please enter your phone number";
  static const String passwordEmptyError = "Please enter your password";
  static const String passwordTooShortError =
      "Password needs to be at least 6 characters";
  static const String invalidPhoneNumberError =
      "Please enter a valid phone number";
  static const String passwordsDontMatchError = "Passwords don't match";
}
