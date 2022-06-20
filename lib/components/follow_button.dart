import 'package:crime_alert/resources/firestore_methods.dart';
import 'package:crime_alert/utility/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FollowButton extends StatefulWidget {
  final String userId;
  const FollowButton({Key? key, required this.userId}) : super(key: key);

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        await FireStoreMethods()
            .followUser(FirebaseAuth.instance.currentUser!.uid, widget.userId);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.iconColor2,
          borderRadius: BorderRadius.circular(5),
        ),
        alignment: Alignment.center,
        child: const Text(
          "Follow",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        width: 150,
        height: 27,
      ),
    );
  }
}
