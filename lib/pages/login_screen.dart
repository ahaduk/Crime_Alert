import 'package:crime_alert/components/default_button.dart';
import 'package:crime_alert/utility/constants.dart';
import 'package:crime_alert/utility/dimensions.dart';
import 'package:flutter/material.dart';

import '../widget/form_error.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Sign In",
          style: TextStyle(
            color: Colors.grey,
            fontSize: Dimensions.font16,
          ),
        ),
        centerTitle: true,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: Dimensions.screenWidth / 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: Dimensions.screenHeight / 20,
                  ),
                  Text(
                    "Welcome, Sign In to stay alert.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: Dimensions.font20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: Dimensions.screenHeight / 20,
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          buildPhoneFormField(),
                          SizedBox(
                            height: Dimensions.screenHeight / 20,
                          ),
                          buildPasswordField(),
                          SizedBox(height: Dimensions.screenHeight / 30),
                          Row(
                            children: [
                              const Spacer(),
                              GestureDetector(
                                onTap: (() {}), //Go to forgot password page
                                child: const Text(
                                  "Forgot Password",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ],
                          ),
                          FormError(errors: errors),
                          SizedBox(height: Dimensions.screenHeight / 30),
                          DefaultButton(
                              press: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                }
                              },
                              text: "Login")
                        ],
                      ))
                ],
              ),
            )),
      ),
    );
  }

  TextFormField buildPasswordField() {
    return TextFormField(
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty && !errors.contains(Constants.passwordEmptyError)) {
          setState(() {
            errors.add(Constants.passwordEmptyError);
          });
        } else if (value.length < 6 &&
            !errors.contains(Constants.passwordTooShortError)) {
          setState(() {
            errors.add(Constants.passwordTooShortError);
          });
        }
        return null;
      },
      onChanged: (value) {
        if (value.isNotEmpty && errors.contains(Constants.passwordEmptyError)) {
          setState(() {
            errors.remove(Constants.passwordEmptyError);
          });
        } else if (value.length >= 6 &&
            errors.contains(Constants.passwordTooShortError)) {
          setState(() {
            errors.remove(Constants.passwordTooShortError);
          });
        }
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "******",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: const Icon(Icons.lock),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 42,
          vertical: 20,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.black),
          gapPadding: 10,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.black),
          gapPadding: 10,
        ),
      ),
    );
  }

  TextFormField buildPhoneFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onChanged: (value) {
        if (value.isNotEmpty &&
            errors.contains(Constants.phoneNumberEmptyError)) {
          setState(() {
            errors.remove(Constants.phoneNumberEmptyError);
          });
        } else if (Constants.ethiopianPhoneNumberRegexp
            .hasMatch(value.toString())) {
          setState(() {
            errors.remove(Constants.invalidPhoneNumberError);
          });
        }
      },
      validator: (value) {
        if (value!.isEmpty &&
            !errors.contains(Constants.phoneNumberEmptyError)) {
          setState(() {
            errors.add(Constants.phoneNumberEmptyError);
          });
        } else if (!Constants.ethiopianPhoneNumberRegexp.hasMatch(value) &&
            !errors.contains(Constants.invalidPhoneNumberError)) {
          setState(() {
            errors.add(Constants.invalidPhoneNumberError);
          });
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Phone Number",
        hintText: "+2519...",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: const Icon(Icons.phone),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 42,
          vertical: 20,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.black),
          gapPadding: 10,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.black),
          gapPadding: 10,
        ),
      ),
    );
  }
}
