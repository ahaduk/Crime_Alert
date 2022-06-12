import 'package:crime_alert/pages/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProfileAvatar extends StatefulWidget {
  const UserProfileAvatar({Key? key}) : super(key: key);

  @override
  State<UserProfileAvatar> createState() => _UserProfileAvatarState();
}

class _UserProfileAvatarState extends State<UserProfileAvatar> {
  @override
  void initState() {
    super.initState();
    //Get user data
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (FirebaseAuth.instance.currentUser == null) {
            //If not logged in to sign up/in page
            Get.to(() => const LoginScreen());
          } else {
            //If logged in
            //to profile screen
          }
        },
        child: const CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: AssetImage("assets/profile.png"),
        ));
  }
}
