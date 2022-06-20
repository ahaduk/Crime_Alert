import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crime_alert/components/upvote_downvote.dart';
import 'package:crime_alert/model/flutter_user.dart';
import 'package:crime_alert/pages/profile_view/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../utility/dimensions.dart';
import '../../widget/big_text.dart';

import 'package:timeago/timeago.dart' as timeago;

class PostDescriptionScreen extends StatefulWidget {
  final String? picUrl;
  final String postDescription, id;
  final double distance;
  final FlutterUser posterUser;
  // ignore: prefer_typing_uninitialized_variables
  final snap;

  const PostDescriptionScreen(
      {Key? key,
      required this.postDescription,
      required this.id,
      this.picUrl,
      required this.snap,
      required this.distance,
      required this.posterUser})
      : super(key: key);

  @override
  State<PostDescriptionScreen> createState() => _PostDescriptionScreenState();
}

class _PostDescriptionScreenState extends State<PostDescriptionScreen> {
  late Marker _reportLocation;
  final Completer<GoogleMapController> _googleMapController = Completer();
  late BitmapDescriptor customMapMarker;
  void setCustomMarker() async {
    customMapMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "assets/siren.png");
  }

  @override
  void initState() {
    setCustomMarker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime dateTimeOfPost =
        (widget.snap['datePublished'] as Timestamp).toDate();
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.posterUser.photoUrl != null
                        ? CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage:
                                NetworkImage(widget.posterUser.photoUrl!),
                            radius: 20,
                          )
                        : const CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage("assets/profile.png"),
                            radius: 20,
                          ),
                    SizedBox(width: Dimensions.width5),
                    InkWell(
                      onTap: () {
                        Get.to(() => ProfileView(fuser: widget.posterUser));
                      },
                      child: widget.posterUser.fullName != null
                          ? Text(
                              widget.posterUser.fullName!,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            )
                          : const Text(
                              "Unkown User",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(right: Dimensions.width15),
                  child: Text(
                    timeago.format(dateTimeOfPost),
                    style: const TextStyle(
                      color: Color.fromARGB(255, 111, 111, 111),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            widget.picUrl != null
                ? Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: SizedBox(
                      // height: Dimensions.screenHeight * 0.75,
                      width: double.infinity,
                      child: Hero(
                        tag: widget.id + "photo",
                        child: Image.network(widget.picUrl!),
                      ),
                    ),
                  )
                : Container(),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Hero(
                tag: widget.id + "description",
                child: BigText(
                  text: widget.postDescription,
                  size: 15,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.screenWidth * 0.07),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        GeoPoint reportLocation = (widget.snap['reportLocation']
                            ['geopoint'] as GeoPoint);
                        _reportLocation = Marker(
                            position: LatLng(reportLocation.latitude,
                                reportLocation.longitude),
                            markerId: const MarkerId("reportLocation"),
                            icon: customMapMarker);
                        CameraPosition _initialCameraPosition = CameraPosition(
                          //Setting default camera position
                          target: LatLng(_reportLocation.position.latitude,
                              _reportLocation.position.longitude),
                          zoom: 15,
                        );
                        showModalBottomSheet(
                            enableDrag: false,
                            context: context,
                            builder: (context) {
                              return Container(
                                padding: const EdgeInsets.all(8),
                                color: const Color.fromRGBO(255, 255, 255, 1),
                                child: Column(
                                  children: [
                                    const Expanded(
                                      flex: 1,
                                      child: Text("Reported Location"),
                                    ),
                                    Expanded(
                                      flex: 8,
                                      child: Scaffold(
                                        body: GoogleMap(
                                          myLocationEnabled: true,
                                          myLocationButtonEnabled: true,
                                          mapToolbarEnabled: false,
                                          markers: {_reportLocation},
                                          zoomControlsEnabled: false,
                                          initialCameraPosition:
                                              _initialCameraPosition,
                                          onMapCreated:
                                              (GoogleMapController controller) {
                                            if (!_googleMapController
                                                .isCompleted) {
                                              _googleMapController
                                                  .complete(controller);
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.map),
                          Text(widget.distance.toStringAsFixed(2) + " KM away"),
                        ],
                      )),
                  UpvoteDownvote(postId: widget.id, snap: widget.snap),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
