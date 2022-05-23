import 'package:crime_alert/pages/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utility/dimensions.dart';

class UserProfileAvatar extends StatelessWidget {
  const UserProfileAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => const LoginScreen());
      },
      child: Container(
        width: Dimensions.height40,
        height: Dimensions.height40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius30),
          color: Colors.black,
          image: const DecorationImage(
              image: AssetImage("assets/user1.jpg"), fit: BoxFit.fill),
        ),
      ),
    );
  }
}
