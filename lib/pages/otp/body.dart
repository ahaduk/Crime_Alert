import 'package:crime_alert/components/default_button.dart';
import 'package:crime_alert/pages/login_screen.dart';
import 'package:crime_alert/utility/colors.dart';
import 'package:crime_alert/utility/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'otp_form.dart';

class OtpBody extends StatefulWidget {
  final String phone;
  final String verificationId;
  const OtpBody({Key? key, required this.phone, required this.verificationId})
      : super(key: key);

  @override
  State<OtpBody> createState() => _OtpBodyState();
}

class _OtpBodyState extends State<OtpBody> {
  bool showForm = true;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: Dimensions.height15),
              Text(
                "SMS Verification",
                style: TextStyle(
                  fontSize: Dimensions.font20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: Dimensions.height15),
              Text(
                "We have sent an SMS code to " +
                    widget.phone.replaceRange(7, 11, "****"),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: Dimensions.height40),
              showForm == true
                  ? buildTimer()
                  : const Text(
                      "The code has expired",
                      textAlign: TextAlign.center,
                    ),
              SizedBox(height: Dimensions.height20),
              showForm
                  ? OtpForm(verificationId: widget.verificationId)
                  : DefaultButton(
                      press: () {
                        Get.back();
                        Get.to(() => const LoginScreen());
                      },
                      text: "Resend OTP"),
            ],
          ),
        ),
      ),
    );
  }

  Row buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "The code will expire in ",
        ),
        TweenAnimationBuilder(
          tween: Tween(begin: 60.0, end: 0.0),
          duration: const Duration(seconds: 60),
          builder: (context, value, child) => Text(
            "00:${(value as double).toInt()}",
            style: TextStyle(
              color: AppColors.primaryColor,
            ),
          ),
          onEnd: () {
            setState(() {
              showForm = false;
            });
          },
        ),
      ],
    );
  }
}
