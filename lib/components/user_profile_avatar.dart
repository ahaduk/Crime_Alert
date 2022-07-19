import 'package:cloud_firestore/cloud_firestore.dart';
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
      FlutterUser? fuser = await AuthMethods().getUserDetails();
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
        child: FirebaseAuth.instance.currentUser != null
            ? StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
                  if (snapshot.data != null) {
                    return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<DocumentSnapshot?> usersnap) {
                          var userDocument = usersnap.data;
                          if (usersnap.hasData && userDocument!["isAgent"]) {
                            _fuser = FlutterUser.fromSnap(userDocument);
                            return CircleAvatar(
                                backgroundColor: Colors.white,
                                backgroundImage:
                                    NetworkImage(_fuser!.photoUrl!));
                          }
                          return Container();
                        });
                  }
                  return Container();
                },
              )
            : const CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: AssetImage("assets/profile.png"),
              ));
  }
}
