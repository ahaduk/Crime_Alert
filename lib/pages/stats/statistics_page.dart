import 'dart:async';

import 'package:crime_alert/components/location_report.dart';
import 'package:crime_alert/utility/colors.dart';
import 'package:crime_alert/utility/dimensions.dart';
import 'package:crime_alert/utility/utils.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Stats extends StatefulWidget {
  const Stats({Key? key}) : super(key: key);

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  final Completer<GoogleMapController> _googleMapController = Completer();
  bool _locationSelected = false, _isLoading = true;
  double _selectedRadius = 0.5;
  late Marker _selectedLocation;
  late Circle _selectedLocationCircle;
  late Position currentLocation;

  @override
  Widget build(BuildContext context) {
    const CameraPosition _initialCameraPosition = CameraPosition(
      target: LatLng(9.01611042424233, 38.76187135931119),
      zoom: 12,
    );
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapToolbarEnabled: false,
            markers: {if (_locationSelected) _selectedLocation},
            circles: {if (_locationSelected) _selectedLocationCircle},
            onTap: (pos) {
              setState(() {
                _selectedLocation = Marker(
                    markerId: const MarkerId("Selected"),
                    infoWindow: const InfoWindow(title: "Report Radius"),
                    position: pos,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueOrange));
                _selectedLocationCircle = Circle(
                  strokeColor: Colors.transparent,
                  fillColor: const Color.fromARGB(62, 83, 147, 250),
                  circleId: const CircleId("selectedCircle"),
                  center: pos,
                  radius: _selectedRadius * 1000,
                );
                _locationSelected = true;
              });
            },
            zoomControlsEnabled: false,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (GoogleMapController controller) {
              _googleMapController.complete(controller);
              setState(() {
                _isLoading = false;
              });
            },
          ),
          SelectLocationPromptText(locationSelected: _locationSelected),
          _locationSelected
              ? Container(
                  padding: const EdgeInsets.only(top: 20),
                  margin: EdgeInsets.only(top: Dimensions.screenHeight * 0.65),
                  height: Dimensions.screenHeight * 0.3,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                  child: Column(
                    children: [
                      const Text(
                        "Adjust Report Radius in KM",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Slider(
                        thumbColor: AppColors.iconColor2,
                        activeColor: AppColors.iconColor1,
                        inactiveColor: AppColors.iconColor2.withOpacity(0.5),
                        value: _selectedRadius,
                        min: 0.5,
                        max: 2,
                        divisions: 3,
                        label: _selectedRadius.toString() + "KMs",
                        onChanged: (double value) {
                          setState(() {
                            _selectedRadius = value;
                            setState(() {
                              _selectedLocation = Marker(
                                  markerId: const MarkerId("Selected"),
                                  infoWindow:
                                      const InfoWindow(title: "Report Radius"),
                                  position: _selectedLocation.position,
                                  icon: BitmapDescriptor.defaultMarkerWithHue(
                                      BitmapDescriptor.hueOrange));
                              _selectedLocationCircle = Circle(
                                strokeColor: Colors.transparent,
                                fillColor:
                                    const Color.fromARGB(62, 83, 147, 250),
                                circleId: const CircleId("selectedCircle"),
                                center: _selectedLocation.position,
                                radius: _selectedRadius * 1000,
                              );
                            });
                          });
                        },
                      ),
                      TextButton(
                        onPressed: () async {
                          showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) {
                                return Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                      ),
                                    ),
                                    height: Dimensions.screenHeight * 0.5,
                                    child: Center(
                                      child: LocationReport(
                                          radius: _selectedRadius,
                                          latlng: LatLng(
                                              _selectedLocation
                                                  .position.latitude,
                                              _selectedLocation
                                                  .position.longitude)),
                                    ));
                              });
                        },
                        child: const Text("Show Report On Location"),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                AppColors.iconColor2),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white)),
                      )
                    ],
                  ),
                )
              : Container()
        ]),
        floatingActionButton: !_isLoading
            ? FloatingActionButton(
                backgroundColor: AppColors.iconColor1,
                child: const Icon(Icons.location_on),
                heroTag: "navigate to location",
                onPressed: () async {
                  Position currentLocation;
                  try {
                    //Getting current location and asking permission
                    currentLocation = await determinePosition();
                    final GoogleMapController controller =
                        await _googleMapController.future;
                    controller.animateCamera(
                        CameraUpdate.newCameraPosition(CameraPosition(
                      target: LatLng(
                          currentLocation.latitude, currentLocation.longitude),
                      zoom: 19,
                    )));
                  } catch (e) {
                    showSnackbar(e.toString(), context);
                  }
                })
            : null,
      ),
    );
  }
}

class SelectLocationPromptText extends StatelessWidget {
  const SelectLocationPromptText({
    Key? key,
    required bool locationSelected,
  })  : _locationSelected = locationSelected,
        super(key: key);

  final bool _locationSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: Dimensions.screenWidth * 0.23, top: 50),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ]),
      child: Text(
        _locationSelected
            ? "Tap to Change Report Location"
            : "Tap to Choose Report Location",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
