import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crime_alert/components/police_inkwell.dart';
import 'package:crime_alert/model/police_station.dart';
import 'package:crime_alert/utility/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../utility/dimensions.dart';

import 'package:timeago/timeago.dart' as timeago;

class LeafletDescriptionScreen extends StatefulWidget {
  final String? picUrl;
  final String postDescription, id;
  final double distance;
  final int reward;
  final PoliceStation policeStation;

  // ignore: prefer_typing_uninitialized_variables
  final snap;

  const LeafletDescriptionScreen(
      {Key? key,
      required this.postDescription,
      required this.id,
      this.picUrl,
      required this.snap,
      required this.distance,
      required this.reward,
      required this.policeStation})
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
        backgroundColor: AppColors.iconColor2,
        elevation: 0,
        title: Text(
          "Leaflet Description",
          style: TextStyle(
            color: Colors.black,
            fontSize: Dimensions.font16,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                    width: Dimensions.screenWidth * 0.5,
                    child: PoliceInkwell(policeStation: widget.policeStation)),
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
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.65,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    widget.picUrl != null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            child: SizedBox(
                              height: Dimensions.screenHeight * 0.55,
                              width: double.infinity,
                              child: Hero(
                                tag: widget.id + "photo",
                                child: Image.network(
                                  widget.picUrl!,
                                  errorBuilder: (context, url, error) =>
                                      SizedBox(
                                          width: double.infinity,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Icon(Icons.error),
                                              Text('Unable to load image')
                                            ],
                                          )),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    const SizedBox(height: 5),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Hero(
                          tag: widget.id + "description",
                          child: Text(
                            widget.postDescription,
                            style: const TextStyle(fontSize: 16.0),
                          )),
                    ),
                  ],
                ),
              ),
            ),
            //Bottom fixed panel
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.5))),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  //Reward
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Reward: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      widget.reward != 0
                          ? Text(widget.reward.toString() + " birr")
                          : const Text("Unavailable")
                    ],
                  ),
                  const SizedBox(height: 20),
                  //Contact
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Contact: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      widget.snap['secondaryContact'] != null
                          ? Text(widget.snap['primaryContact'] +
                              " / " +
                              widget.snap['secondaryContact'])
                          : Text(
                              widget.snap['primaryContact'],
                            )
                    ],
                  ),
                  const SizedBox(height: 10),
                  //Show map button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
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
                            CameraPosition _initialCameraPosition =
                                CameraPosition(
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
                                    color:
                                        const Color.fromRGBO(255, 255, 255, 1),
                                    child: Column(
                                      children: [
                                        const Expanded(
                                          flex: 1,
                                          child: Text("Last seen location"),
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
                                              onMapCreated: (GoogleMapController
                                                  controller) {
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
                            children: const [
                              Icon(Icons.map),
                              Text("Show last seen location"),
                            ],
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
