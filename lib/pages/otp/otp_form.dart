import 'package:crime_alert/resources/auth_methods.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/default_button.dart';
import '../../utility/dimensions.dart';
import '../../utility/utils.dart';

class OtpForm extends StatefulWidget {
  final String verificationId;
  const OtpForm({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpCodeController = TextEditingController();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _otpCodeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: Dimensions.screenWidth * 0.5,
                child: TextFormField(
                  autofocus: true,
                  controller: _otpCodeController,
                  maxLength: 6,
                  //focusNode: pin6FocusNode,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: Dimensions.font26),
                  decoration: InputDecoration(
                    counterText: "",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty || value.length < 6) {
                      return "";
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.height45),
          DefaultButton(
            text: "Verify",
            press: () async {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  isLoading = true;
                });
                String? res = await AuthMethods().verifyUser(
                    verificationId: widget.verificationId,
                    otpCode: _otpCodeController.text);
                Utils.showSnackbar(res.toString(), context);
                setState(() {
                  isLoading = false;
                });
                if (res == "Successfully signed in") {
                  Get.back();
                }
              }
            },
          )
        ],
      ),
    );
  }
}
