import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crime_alert/resources/firestore_methods.dart';
import 'package:crime_alert/utility/colors.dart';
import 'package:crime_alert/utility/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../widget/small_text.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../utility/dimensions.dart';
import '../widget/big_text.dart';

class PostPreview extends StatelessWidget {
  final bool locationEnabled;
  final String? picUrl;
  final String postDescription, id;
  final DateTime dateTimeOfPost;
  final String userId;
  final Position? currentLocation;
  // ignore: prefer_typing_uninitialized_variables
  final snap;
  final GeoPoint reportLocation;
  const PostPreview(
      {Key? key,
      this.picUrl,
      required this.postDescription,
      required this.id,
      required this.dateTimeOfPost,
      required this.userId,
      required this.snap,
      this.currentLocation,
      required this.reportLocation,
      required this.locationEnabled})
      : super(key: key);
  //Also pass a user object or user id to identify profile of poster
  @override
  Widget build(BuildContext context) {
    double screenHeight = Get.context!.height;
    double distance = 0;
    locationEnabled
        ? distance = calculateDistance(
            currentLocation!.latitude,
            currentLocation!.longitude,
            reportLocation.latitude,
            reportLocation.longitude)
        : 0;

    return GestureDetector(
        onTap: () {
          // Get.to(() => PostDescriptionScreen(
          //     postDescription: postDescription,
          //     picUrl: picUrl,
          //     id: id,
          //     snap: snap,
          //     distance: distance,
          //     posterUser: posterUser));
        },
        child: Container(
          margin: EdgeInsets.only(
              left: Dimensions.width10,
              right: Dimensions.width10,
              bottom: Dimensions.height20),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  offset: const Offset(10, 10),
                  blurRadius: 10,
                )
              ],
              border: Border.all(color: Colors.grey.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              picUrl != null
                  ? Container(
                      width: Dimensions.listViewImgSize,
                      height: Dimensions.listViewImgSize,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(Dimensions.radius10),
                            bottomLeft: Radius.circular(Dimensions.radius10),
                          ),
                          color: Colors.white38,
                          image: DecorationImage(
                              fit: BoxFit.cover, image: NetworkImage(picUrl!))),
                    )
                  : Container(),
              // text section
              Flexible(
                child: Stack(
                  children: [
                    Container(
                      height: picUrl != null
                          ? Dimensions.listViewImgSize
                          : Dimensions.listViewImgSize * 0.7,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(Dimensions.radius10),
                          bottomRight: Radius.circular(Dimensions.radius10),
                        ),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: Dimensions.width10,
                            left: picUrl != null
                                ? Dimensions.width10
                                : Dimensions.width30,
                            right: Dimensions.width10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BigText(
                              text: postDescription,
                              size:
                                  screenHeight <= 825 ? 12 : Dimensions.font14,
                            ),
                            SizedBox(
                              height: Dimensions.height7,
                            ),
                            SizedBox(
                              height: screenHeight <= 825 ? 8 : 8,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        right: Dimensions.width15),
                                    child: SmallText(
                                      text: timeago.format(dateTimeOfPost),
                                      color: const Color.fromARGB(
                                          255, 129, 127, 127),
                                      size: screenHeight <= 825
                                          ? 12
                                          : Dimensions.font20,
                                    ),
                                  )
                                ]),
                            const Spacer(),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                distance != 0
                                    ? distance.toStringAsFixed(2) + "KM away"
                                    : "Unknown KM away",
                                textAlign: TextAlign.end,
                                style: TextStyle(fontSize: Dimensions.font13),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    FirebaseAuth.instance.currentUser != null &&
                            FirebaseAuth.instance.currentUser!.uid == userId
                        ? Positioned(
                            top: -5,
                            right: -12,
                            child: IconButton(
                              onPressed: () async {
                                await buildOptions(context);
                              },
                              icon: const Icon(Icons.more_vert),
                            ),
                          )
                        : Container(),
                  ],
                ),
              )
            ],
          ),
        ));
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
                                          await FireStoreMethods()
                                              .deletePost(id, picUrl, context);
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
