import 'package:crime_alert/components/default_button.dart';
import 'package:crime_alert/utility/colors.dart';
import 'package:crime_alert/utility/constants.dart';
import 'package:crime_alert/utility/dimensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utility/utils.dart';
import '../widget/form_error.dart';
import 'otp/body.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late String phoneNumber;
  late String password;
  final List<String> errors = [];
  bool isSending = false;
  bool codeSent = false;
  String verificationId = "";
  final TextEditingController _phoneController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _phoneController.dispose();
  }

  Widget conditionalWrapper() {
    if (isSending && !codeSent) {
      return Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Please use the link to verify you are not a robot",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: Dimensions.font16,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ),
            const CircularProgressIndicator(),
          ],
        ),
      );
    }
    if (!codeSent && !isSending) {
      return SizedBox(
        width: double.infinity,
        child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: Dimensions.screenWidth / 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: Dimensions.screenHeight * 0.2,
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
                          SizedBox(
                            width: Dimensions.screenWidth * 0.9,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: buildPhoneNumberField(),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: Dimensions.screenHeight / 40,
                          ),
                          SizedBox(height: Dimensions.screenHeight / 45),
                          FormError(errors: errors),
                          SizedBox(height: Dimensions.screenHeight / 45),
                          DefaultButton(
                              press: () {
                                if (_formKey.currentState!.validate() &&
                                    _phoneController.text.length == 9) {
                                  // _formKey.currentState!.save();
                                  showDialog(
                                      context: context,
                                      builder: (context) =>
                                          buildPhoneConfirmationPopup(context));
                                }
                              },
                              text: "Login"),
                          SizedBox(
                            height: Dimensions.height40,
                          ),
                        ],
                      ))
                ],
              ),
            )),
      );
    }
    if (codeSent) {
      return OtpBody(
          phone: "+251" + _phoneController.text,
          verificationId: verificationId);
    }
    return Container();
  }

  void sendOtp() async {
    setState(() {
      isSending = true;
    });
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.verifyPhoneNumber(
      timeout: const Duration(seconds: 60),
      phoneNumber: "+251" + _phoneController.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // ANDROID ONLY!

        // Sign the user in (or link) with the auto-generated credential
        await auth.signInWithCredential(credential);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      codeSent: (String verificationId, int? forceResendingToken) async {
        //Update the UI for user to enter SMS Code and store verificationID on variable
        setState(() {
          this.verificationId = verificationId;
          isSending = false;
          codeSent = true;
        });
      },
      verificationFailed: (FirebaseAuthException error) {
        setState(() {
          isSending = false;
        });
        showSnackbar(error.message.toString(), context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.iconColor2,
        elevation: 0,
        title: Text(
          codeSent ? "Verify Phone Number" : "Sign In With Phone Number",
          style: TextStyle(
            color: Colors.black,
            fontSize: Dimensions.font16,
          ),
        ),
        centerTitle: true,
      ),
      body: conditionalWrapper(),
    );
  }

  SimpleDialog buildPhoneConfirmationPopup(BuildContext context) {
    return SimpleDialog(
      backgroundColor: AppColors.iconColor4,
      title: Text(
        "Confirm Phone Number",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: Dimensions.font16),
      ),
      contentPadding: const EdgeInsets.all(20).copyWith(top: 5),
      children: [
        const Text("We are going to send confimation code to ",
            textAlign: TextAlign.center),
        Text(
          "+251" + _phoneController.text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const Text("Would you like to continue?", textAlign: TextAlign.center),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                  foregroundColor:
                      MaterialStateProperty.all(AppColors.iconColor3)),
            ),
            ElevatedButton(
              onPressed: () {
                //Continue to verification page after continue
                Navigator.of(context).pop();
                setState(() {
                  isSending = true;
                });
                sendOtp();
              },
              child: const Text('Continue'),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                          side: const BorderSide(color: Colors.black))),
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                  foregroundColor: MaterialStateProperty.all(Colors.black)),
            ),
          ],
        ),
      ],
    );
  }

  TextFormField buildPhoneNumberField() {
    return TextFormField(
      maxLength: 9,
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => phoneNumber = newValue!,
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
          return "";
        } else if (!Constants.ethiopianPhoneNumberRegexp.hasMatch(value) &&
            !errors.contains(Constants.invalidPhoneNumberError)) {
          setState(() {
            errors.add(Constants.invalidPhoneNumberError);
          });
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        prefixText: '+251',
        labelText: "Phone Number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.phone),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.black),
          gapPadding: 10,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          gapPadding: 10,
        ),
      ),
    );
  }
}
