import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crime_alert/pages/post%20alert/post_alert.dart';
import 'package:crime_alert/utility/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.data != null) {
          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot?> usersnap) {
                var userDocument = usersnap.data;
                if (usersnap.hasData && userDocument!["isAgent"]) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 30),
                    child: FloatingActionButton(
                      heroTag: null,
                      onPressed: () {
                        Get.to(() => const PostAlertPage());
                      },
                      backgroundColor: AppColors.mainColor,
                      foregroundColor: Colors.black,
                      child: const Icon(Icons.add, size: 30),
                    ),
                  );
                }
                return Container();
              });
        }
        return Container();
      },
    );
  }
}
