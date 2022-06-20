import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crime_alert/components/upvote_downvote.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../utility/dimensions.dart';
import '../../widget/big_text.dart';

import 'package:timeago/timeago.dart' as timeago;

class LeafletDescriptionScreen extends StatefulWidget {
  final String? picUrl;
  final String postDescription, id;
  final double distance;
  final int reward;

  // ignore: prefer_typing_uninitialized_variables
  final snap;

  const LeafletDescriptionScreen(
      {Key? key,
      required this.postDescription,
      required this.id,
      this.picUrl,
      required this.snap,
      required this.distance,
      required this.reward})
      : super(key: key);

  @override
  State<LeafletDescriptionScreen> createState() =>
      _LeafletDescriptionScreenState();
}

class _LeafletDescriptionScreenState extends State<LeafletDescriptionScreen> {
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
          "Leaflet Description",
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
                    const CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage("assets/user1.jpg"),
                    ),
                    SizedBox(width: Dimensions.width5),
                    InkWell(
                      onTap: () {},
                      child: const Text(
                        "Username",
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
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.7,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    widget.picUrl != null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Hero(
                          tag: widget.id + "description",
                          child: Expanded(
                            child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Text(
                                  widget.postDescription,
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(fontSize: 16.0),
                                )),
                          )),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  widget.reward != 0
                      ? Text("Reward: " + widget.reward.toString() + " birr")
                      : Text("Reward: Unavailable")
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  widget.snap['secondaryContact'] != null
                      ? Text("Contact: " +
                          widget.snap['primaryContact'] +
                          " / " +
                          widget.snap['secondaryContact'])
                      : Text(
                          "Contact: " + widget.snap['primaryContact'],
                        )
                ],
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
                        GeoPoint reportLocation =
                            (widget.snap['reportLocation'] as GeoPoint);
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
                                      child: Text("Tap to choose location"),
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
                          Text("Last known location is " +
                              widget.distance.toStringAsFixed(2) +
                              " KM away"),
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
