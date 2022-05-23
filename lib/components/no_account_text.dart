import 'package:crime_alert/pages/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Sign In to Get Notified",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextButton(
            onPressed: () {
              Get.to(() => const LoginScreen());
            },
            child: const Text("Sign In")),
      ],
    );
  }
}
