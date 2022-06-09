import 'dart:async';

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
  Set<Marker> markers = {};
  late Marker _selectedLocation;
  late Circle _selectedLocationCircle;
  late Position currentLocation;

  @override
  Widget build(BuildContext context) {
    const CameraPosition _initialCameraPosition = CameraPosition(
      target: LatLng(9.01611042424233, 38.76187135931119),
      zoom: 12,
    );
    return Scaffold(
      body: GoogleMap(
        markers: {if (_locationSelected) _selectedLocation, ...markers},
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
              radius: 500,
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
      floatingActionButton: !_isLoading
          ? FloatingActionButton(
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
                  //Adding marker
                  setState(() {
                    markers.add(Marker(
                        markerId: const MarkerId("Current Location"),
                        position: LatLng(currentLocation.latitude,
                            currentLocation.longitude)));
                  });
                } catch (e) {
                  showSnackbar(e.toString(), context);
                }
              })
          : null,
    );
  }
}
