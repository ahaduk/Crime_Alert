import 'package:crime_alert/model/flutter_user.dart';
import 'package:crime_alert/pages/login_screen.dart';
import 'package:crime_alert/pages/profile_view/profile_view.dart';
import 'package:crime_alert/resources/auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProfileAvatar extends StatefulWidget {
  const UserProfileAvatar({Key? key}) : super(key: key);

  @override
  State<UserProfileAvatar> createState() => _UserProfileAvatarState();
}

class _UserProfileAvatarState extends State<UserProfileAvatar> {
  FlutterUser? _fuser;
  Future<void> getUser() async {
    try {
      FlutterUser fuser = await AuthMethods().getUserDetails();
      setState(() {
        _fuser = fuser;
      });
    } catch (e) {
      setState(() {
        _fuser = null;
      });
    }
  }

  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser != null) {
      getUser();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          if (FirebaseAuth.instance.currentUser == null) {
            //If not logged in to sign up/in page
            Get.to(() => const LoginScreen());
          } else if (_fuser != null) {
            //If logged in
            //to profile screen
            Get.to(() => ProfileView(fuser: _fuser!));
          }
        },
        child: _fuser != null && _fuser!.photoUrl != null
            ? CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(_fuser!.photoUrl!))
            : const CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: AssetImage("assets/profile.png"),
              ));
  }
}
