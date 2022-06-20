import 'package:crime_alert/model/flutter_user.dart';
import 'package:crime_alert/pages/profile_view/profile_view.dart';
import 'package:crime_alert/resources/firestore_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserInkwell extends StatelessWidget {
  final FlutterUser posterUser;
  final String postId;
  final String? postUrl;
  const UserInkwell(
      {Key? key, required this.posterUser, required this.postId, this.postUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
          .copyWith(right: 0),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: GestureDetector(
                onTap: () {
                  Get.to(() => ProfileView(fuser: posterUser));
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    posterUser.photoUrl != null
                        ? CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(posterUser.photoUrl!),
                          )
                        : const CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage("assets/profile.png"),
                            backgroundColor: Colors.white,
                          ),
                    const SizedBox(width: 10),
                    InkWell(
                      child: posterUser.fullName != null
                          ? Text(
                              posterUser.fullName!,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            )
                          : const Text(
                              "Unknown User",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          FirebaseAuth.instance.currentUser != null &&
                  FirebaseAuth.instance.currentUser!.uid == posterUser.uid
              ? IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shrinkWrap: true,
                          children: ['Delete']
                              .map((e) => InkWell(
                                    onTap: () async {
                                      await FireStoreMethods().deletePost(
                                          postId.substring(
                                              0, postId.length - 2),
                                          postUrl,
                                          context);
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 16),
                                      child: Text(e),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.more_vert),
                )
              : Container(),
        ],
      ),
      // Image section
    );
  }
}