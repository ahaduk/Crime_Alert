import 'package:crime_alert/resources/firestore_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UnfollowButton extends StatefulWidget {
  final String userId;
  const UnfollowButton({Key? key, required this.userId}) : super(key: key);

  @override
  State<UnfollowButton> createState() => _UnfollowButtonState();
}

class _UnfollowButtonState extends State<UnfollowButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        await FireStoreMethods().unfollowUser(
            FirebaseAuth.instance.currentUser!.uid, widget.userId);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        alignment: Alignment.center,
        child: const Text(
          "Unfollow",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        width: 150,
        height: 27,
      ),
    );
  }
}
