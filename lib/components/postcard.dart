import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crime_alert/components/upvote_downvote.dart';
import 'package:crime_alert/pages/post%20description/post_description_screen.dart';
import 'package:crime_alert/resources/firestore_methods.dart';
import 'package:crime_alert/utility/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../widget/big_text.dart';

class PostCard extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final snap;
  final String docId;
  final Position? currentLocation;
  const PostCard(
      {Key? key, required this.snap, required this.docId, this.currentLocation})
      : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  //Also pass a user object or user id to identify profile of poster
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime dateTimeOfPost =
        (widget.snap['datePublished'] as Timestamp).toDate();
    GeoPoint reportLocation = (widget.snap['reportLocation'] as GeoPoint);
    double distance = 0;
    widget.currentLocation != null
        ? distance = calculateDistance(
            widget.currentLocation!.latitude,
            widget.currentLocation!.longitude,
            reportLocation.latitude,
            reportLocation.longitude)
        : 0;
    return GestureDetector(
      onTap: (() {
        Get.to(() => PostDescriptionScreen(
              picUrl: widget.snap['imgUrl'],
              postDescription: widget.snap['description'],
              id: widget.docId,
              snap: widget.snap,
              distance: distance,
            ));
      }),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                  .copyWith(right: 0),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage("assets/user1.jpg"),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {},
                            child: const Text(
                              "Username",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  FirebaseAuth.instance.currentUser != null &&
                          FirebaseAuth.instance.currentUser!.uid ==
                              widget.snap['uid']
                      ? IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                child: ListView(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shrinkWrap: true,
                                  children: ['Delete']
                                      .map((e) => InkWell(
                                            onTap: () async {
                                              await FireStoreMethods()
                                                  .deletePost(
                                                      widget.docId.substring(
                                                          0,
                                                          widget.docId.length -
                                                              2),
                                                      widget.snap['imgUrl'],
                                                      context);
                                              Navigator.of(context).pop();
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
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
            ),
            widget.snap['imgUrl'] != null
                ? Hero(
                    tag: widget.docId + "photo",
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.55,
                      width: double.infinity,
                      child: Image.network(
                        widget.snap['imgUrl'],
                        fit: BoxFit.fitWidth,
                        errorBuilder: (context, url, error) => Center(
                            child: Row(
                          children: const [
                            Icon(Icons.error),
                            Text('Unable to load image')
                          ],
                        )),
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    ))
                : Container(),
            // text section

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Hero(
                    tag: widget.docId + "description",
                    child: BigText(
                      text: widget.snap['description'],
                      size: 15,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        timeago.format(dateTimeOfPost),
                        style: const TextStyle(
                          color: Color.fromARGB(255, 111, 111, 111),
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(distance.toStringAsFixed(2) + "KM away"),
                      //Pass object to upvote down vote to make changes to database
                      UpvoteDownvote(postId: widget.docId, snap: widget.snap)
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
