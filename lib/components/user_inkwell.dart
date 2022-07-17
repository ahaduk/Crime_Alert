import 'package:crime_alert/model/flutter_user.dart';
import 'package:crime_alert/pages/profile_view/profile_view.dart';
import 'package:crime_alert/resources/firestore_methods.dart';
import 'package:crime_alert/utility/colors.dart';
import 'package:crime_alert/utility/dimensions.dart';
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
                  onPressed: () async {
                    await buildOptions(context);
                  },
                  icon: const Icon(Icons.more_vert),
                )
              : Container(),
        ],
      ),
    );
  }

  buildOptions(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shrinkWrap: true,
          children: ['Delete']
              .map((e) => InkWell(
                    onTap: () async {
                      //Confirm to delete
                      Navigator.of(context).pop();
                      showDialog(
                          context: context,
                          builder: (context) => SimpleDialog(
                                backgroundColor: AppColors.iconColor4,
                                title: Text(
                                  "Are You Sure You Want To Delete That Post?",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: Dimensions.font16),
                                ),
                                contentPadding:
                                    const EdgeInsets.all(20).copyWith(top: 5),
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel'),
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.black),
                                            foregroundColor:
                                                MaterialStateProperty.all(
                                                    AppColors.iconColor3)),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          //Continue to delete post
                                          Navigator.of(context).pop();
                                          await FireStoreMethods().deletePost(
                                              postId.substring(
                                                  0, postId.length - 2),
                                              postUrl,
                                              context);
                                        },
                                        child: const Text('Delete'),
                                        style: ButtonStyle(
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3),
                                                    side: const BorderSide(
                                                        color: Colors.black))),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.transparent),
                                            shadowColor:
                                                MaterialStateProperty.all(
                                                    Colors.transparent),
                                            foregroundColor:
                                                MaterialStateProperty.all(Colors.black)),
                                      ),
                                    ],
                                  ),
                                ],
                              ));
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
  }
}
