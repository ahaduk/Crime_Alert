import 'package:crime_alert/pages/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Login To Continue",
            style: TextStyle(fontSize: 20),
          ),
          TextButton(
              onPressed: () {
                Get.to(const LoginScreen());
              },
              child: const Text("Login")),
          const Text(
            "Don't have an account?",
            style: TextStyle(fontSize: 20),
          ),
          TextButton(
              onPressed: () {
                Get.to(const LoginScreen());
              },
              child: const Text("Signup")),
        ],
      ),
    );
  }
}
