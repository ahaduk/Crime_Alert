import 'package:crime_alert/components/upvote_downvote.dart';
import 'package:flutter/material.dart';

import '../../utility/dimensions.dart';
import '../../widget/big_text.dart';

import '../../widget/small_text.dart';

class PostDescriptionScreen extends StatefulWidget {
  final String? picUrl;
  final String postDescription;
  final String id;
  const PostDescriptionScreen(
      {Key? key, required this.postDescription, required this.id, this.picUrl})
      : super(key: key);

  @override
  State<PostDescriptionScreen> createState() => _PostDescriptionScreenState();
}

class _PostDescriptionScreenState extends State<PostDescriptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Post Description",
          style: TextStyle(
            color: Colors.grey,
            fontSize: Dimensions.font16,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Hero(
                tag: widget.id,
                child: BigText(
                  text: widget.postDescription,
                  size: Dimensions.screenHeight <= 825 ? 12 : Dimensions.font14,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: AssetImage("assets/user3.jpg"),
                        radius: 15,
                      ),
                      SizedBox(width: Dimensions.width5),
                      SmallText(
                        text: "johonnes milke",
                        color: const Color.fromARGB(255, 75, 60, 60),
                        size: Dimensions.screenHeight <= 825
                            ? 11
                            : Dimensions.font13,
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(right: Dimensions.width15),
                    child: SmallText(
                      text: "1h ago",
                      color: const Color.fromARGB(255, 129, 127, 127),
                      size: Dimensions.screenHeight <= 825
                          ? 11
                          : Dimensions.font13,
                    ),
                  )
                ],
              ),
            ),
            widget.picUrl != null
                ? SizedBox(
                    height: Dimensions.screenHeight * 0.3,
                    child: Hero(
                      tag: widget.id + "photo",
                      child: Image.asset(widget.picUrl!),
                    ),
                  )
                : Container(),
            const SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.screenWidth * 0.07),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Reported Location"),
                  UpvoteDownvote(),
                ],
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              height: Dimensions.screenHeight * 0.4,
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
