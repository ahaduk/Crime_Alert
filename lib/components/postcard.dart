import 'package:crime_alert/components/upvote_downvote.dart';
import 'package:crime_alert/pages/post%20description/post_description_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utility/dimensions.dart';
import '../widget/big_text.dart';
import '../widget/small_text.dart';

class PostCard extends StatefulWidget {
  final String? picUrl;
  final String postDescription, id;
  const PostCard(
      {Key? key, this.picUrl, required this.postDescription, required this.id})
      : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  //Also pass a user object or user id to identify profile of poster
  @override
  Widget build(BuildContext context) {
    double screenHeight = Get.context!.height;
    //double screenWidth = Get.context!.width;
    return GestureDetector(
      onTap: (() {
        Get.to(() => PostDescriptionScreen(
            picUrl: widget.picUrl,
            postDescription: widget.postDescription,
            id: widget.id));
      }),
      child: Container(
        margin: EdgeInsets.only(
            left: Dimensions.width20,
            right: Dimensions.width20,
            bottom: Dimensions.height20),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            offset: const Offset(10, 10),
            blurRadius: 10,
          )
        ]),
        child: Row(
          children: [
            widget.picUrl != null
                ? SizedBox(
                    width: Dimensions.screenWidth * 0.3,
                    child: Hero(
                        tag: widget.id + "photo",
                        child: Image.asset(widget.picUrl!)))
                : Container(),
            // text section
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(Dimensions.radius10),
                    bottomRight: Radius.circular(Dimensions.radius10),
                  ),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: FirebaseAuth.instance.currentUser != null
                      ? EdgeInsets.all(Dimensions.width10)
                      : const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: widget.id,
                        child: BigText(
                          text: widget.postDescription,
                          size: screenHeight <= 825 ? 12 : Dimensions.font14,
                        ),
                      ),
                      SizedBox(
                        height: Dimensions.height7,
                      ),
                      SizedBox(
                        height: screenHeight <= 825 ? 8 : 8,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  backgroundImage:
                                      AssetImage("assets/user3.jpg"),
                                  radius: 10,
                                ),
                                SizedBox(width: Dimensions.width5),
                                SmallText(
                                  text: "johonnes milke",
                                  color: const Color.fromARGB(255, 75, 60, 60),
                                  size: screenHeight <= 825
                                      ? 11
                                      : Dimensions.font13,
                                ),
                              ],
                            ),
                            Container(
                              padding:
                                  EdgeInsets.only(right: Dimensions.width15),
                              child: SmallText(
                                text: "1h ago",
                                color: const Color.fromARGB(255, 129, 127, 127),
                                size: screenHeight <= 825
                                    ? 11
                                    : Dimensions.font13,
                              ),
                            )
                          ]),
                      //Pass object to upvote down vote to make changes to database
                      const UpvoteDownvote()
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
