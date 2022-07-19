import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crime_alert/components/police_inkwell.dart';
import 'package:crime_alert/components/upvote_downvote.dart';
import 'package:crime_alert/components/user_inkwell.dart';
import 'package:crime_alert/model/flutter_user.dart';
import 'package:crime_alert/model/police_station.dart';
import 'package:crime_alert/pages/post%20description/post_description_screen.dart';
import 'package:crime_alert/resources/firestore_methods.dart';
import 'package:crime_alert/utility/constants.dart';
import 'package:crime_alert/utility/utils.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../widget/big_text.dart';
import 'Skeleton.dart';

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
  FlutterUser? _posterUser;
  bool _userSet = false, _policeSet = false;
  late final PoliceStation _policeStation;
  //Also pass a user object or user id to identify profile of poster
  getPoliceStation() async {
    _policeStation = await FireStoreMethods().getPoliceInfo(widget.snap['uid']);
    if (super.mounted) {
      setState(() {
        _policeSet = true;
      });
    }
  }

  getPoster() async {
    _posterUser = await FireStoreMethods().getUserDetails(widget.snap['uid']);
    if (_posterUser == null) {
      //If post is not from agent it is from police station
      await getPoliceStation();
    }
    if (super.mounted) {
      setState(() {
        _userSet = true;
      });
    }
  }

  @override
  void initState() {
    getPoster();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime dateTimeOfPost =
        (widget.snap['datePublished'] as Timestamp).toDate();
    GeoPoint reportLocation =
        (widget.snap['reportLocation']['geopoint'] as GeoPoint);
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
        if (_posterUser != null) {
          Get.to(() => PostDescriptionScreen(
                picUrl: widget.snap['imgUrl'],
                postDescription: widget.snap['description'],
                id: widget.docId,
                snap: widget.snap,
                distance: distance,
                posterUser: _posterUser,
              ));
        } else if (_policeSet) {
          Get.to(() => PostDescriptionScreen(
                picUrl: widget.snap['imgUrl'],
                postDescription: widget.snap['description'],
                id: widget.docId,
                snap: widget.snap,
                distance: distance,
                policeStation: _policeStation,
              ));
        }
      }),
      child: Container(
        decoration: Constants.cardBoxDecoration,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          children: [
            buildConditionalInkwell(),

            widget.snap['imgUrl'] != null
                ? Hero(
                    tag: widget.docId + "photo",
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.55,
                      width: double.infinity,
                      child: Image.network(
                        widget.snap['imgUrl'],
                        fit: BoxFit.fitWidth,
                        errorBuilder: (context, url, error) => SizedBox(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        timeago.format(dateTimeOfPost),
                        style: const TextStyle(
                          color: Color.fromARGB(255, 111, 111, 111),
                        ),
                      ),

                      Text(distance.toStringAsFixed(2) + "KM away"),
                      //Pass object to upvote down vote to make changes to database
                      //Visible if post not from police station
                      !_policeSet
                          ? UpvoteDownvote(
                              postId: widget.docId, snap: widget.snap)
                          : Container()
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

  Widget buildConditionalInkwell() {
    if (_userSet && _posterUser != null) {
      return UserInkwell(
        posterUser: _posterUser!,
        postId: widget.docId,
        postUrl: widget.snap['imgUrl'],
      );
    } else if (_policeSet) {
      return PoliceInkwell(policeStation: _policeStation);
    }
    //Show skeleton during user data fetch
    return Padding(
      padding: const EdgeInsets.only(left: 25, bottom: 10),
      child: Row(
        children: const [
          Skeleton(height: 40, width: 40),
          SizedBox(width: 10),
          Skeleton(width: 120),
        ],
      ),
    );
  }
}
