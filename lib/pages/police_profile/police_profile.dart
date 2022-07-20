import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crime_alert/components/user_posts.dart';
import 'package:crime_alert/model/police_station.dart';
import 'package:crime_alert/utility/colors.dart';
import 'package:crime_alert/utility/dimensions.dart';
import 'package:crime_alert/utility/utils.dart';
import 'package:crime_alert/widget/big_text.dart';
import 'package:crime_alert/widget/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PoliceProfile extends StatefulWidget {
  final PoliceStation policeStation;
  const PoliceProfile({Key? key, required this.policeStation})
      : super(key: key);

  @override
  State<PoliceProfile> createState() => _PoliceProfileState();
}

class _PoliceProfileState extends State<PoliceProfile> {
  late BitmapDescriptor customMapMarker;
  Position? _currentLocation;
  final Completer<GoogleMapController> _googleMapController = Completer();
  void setCustomMarker() async {
    customMapMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "assets/policestation.png");
  }

  bool _locationEnabled = false, _isLoading = true;
  final geo = Geoflutterfire();
  void getLocation() async {
    try {
      _currentLocation = await determinePosition();
      setState(() {
        _locationEnabled = true;
        _isLoading = false;
      });
    } catch (e) {
      try {
        _currentLocation = (await Geolocator.getLastKnownPosition())!;
        showSnackbar("Using last known location to load feed", context);
        setState(() {
          _locationEnabled = true;
          _isLoading = false;
        });
      } catch (e) {
        showSnackbar("Please enable location services.", context);
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    getLocation();
    setCustomMarker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && !_locationEnabled) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.mainColor,
          title: const Text('Station Profile'),
          foregroundColor: Colors.black,
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: Dimensions.screenWidth * 0.6,
                  height: 80,
                  child: BigText(
                    text: 'Station: ' + widget.policeStation.stationCode,
                    size: Dimensions.font26,
                    color: AppColors.textColor,
                    overflow: TextOverflow.fade,
                  ),
                ),
                widget.policeStation.photoUrl != null
                    ? CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage:
                            NetworkImage(widget.policeStation.photoUrl!),
                        radius: 60,
                      )
                    : const CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage("assets/policelogo.jpg"),
                        radius: 50,
                      ),
              ],
            ),
            SizedBox(height: Dimensions.height10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SmallText(
                  text: 'Primary Contact: ',
                  color: Color.fromARGB(255, 74, 74, 74),
                  size: 15,
                ),
                BigText(
                  text: widget.policeStation.primaryContact,
                  size: 16,
                ),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => SimpleDialog(
                                backgroundColor: AppColors.iconColor4,
                                title: Text(
                                  "Are You Sure You Want To Call That Station?",
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
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          await FlutterPhoneDirectCaller
                                              .callNumber(widget.policeStation
                                                  .primaryContact);
                                        },
                                        child: const Text('Call'),
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
                                          //Continue to call
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel'),
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
                    icon: const Icon(Icons.phone)),
              ],
            ),
            SizedBox(height: Dimensions.height10),
            //Secondary Contact if there is one
            widget.policeStation.secondaryContact != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SmallText(
                        text: 'Secondary Contact: ',
                        color: Color.fromARGB(255, 74, 74, 74),
                        size: 15,
                      ),
                      BigText(
                        text: widget.policeStation.primaryContact,
                        size: 16,
                      ),
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => SimpleDialog(
                                      backgroundColor: AppColors.iconColor4,
                                      title: Text(
                                        "Are You Sure You Want To Call That Station?",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: Dimensions.font16),
                                      ),
                                      contentPadding: const EdgeInsets.all(20)
                                          .copyWith(top: 5),
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () async {
                                                Navigator.of(context).pop();
                                                await FlutterPhoneDirectCaller
                                                    .callNumber(widget
                                                        .policeStation
                                                        .secondaryContact!);
                                              },
                                              child: const Text('Call'),
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.black),
                                                  foregroundColor:
                                                      MaterialStateProperty.all(
                                                          AppColors
                                                              .iconColor3)),
                                            ),
                                            ElevatedButton(
                                              onPressed: () async {
                                                //Continue to call
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Cancel'),
                                              style: ButtonStyle(
                                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(3),
                                                          side: const BorderSide(
                                                              color: Colors
                                                                  .black))),
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
                          icon: const Icon(Icons.phone)),
                    ],
                  )
                : Container(),
            //Show Station location on map
            TextButton(
                onPressed: () {
                  GeoPoint reportLocation = GeoPoint(
                      widget.policeStation.latitude,
                      widget.policeStation.longitude);
                  Marker _reportLocation = Marker(
                      position: LatLng(
                          reportLocation.latitude, reportLocation.longitude),
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
                              const Flexible(
                                flex: 1,
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text("Police Station Location"),
                                ),
                              ),
                              Flexible(
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
                                      if (!_googleMapController.isCompleted) {
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
                    Text("Show Police Station Location"),
                  ],
                )),
            const SizedBox(height: 10),
            const Divider(color: Colors.grey),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10, left: 10),
              child: Text(
                'Most Recent Posts',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                    fontSize: Dimensions.font14),
              ),
            ),
            UserPosts(
                userId: widget.policeStation.uid,
                locationEnabled: _locationEnabled,
                currentLocation: _currentLocation),
          ]),
        ),
      );
    }
  }
}
