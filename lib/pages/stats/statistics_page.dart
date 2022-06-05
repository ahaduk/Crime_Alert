import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Stats extends StatefulWidget {
  const Stats({Key? key}) : super(key: key);

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  late GoogleMapController _googleMapController;
  bool _locationSelected = false, _isLoading = true;
  late Marker _selectedLocation;
  late Circle _selectedLocationCircle;
  @override
  void dispose() {
    if (!_isLoading) _googleMapController.dispose();
    super.dispose();
  }

  void initializeMap(GoogleMapController googleMapController) {
    _googleMapController = googleMapController;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const CameraPosition _initialCameraPosition = CameraPosition(
      target: LatLng(9.001135, 38.807583),
      zoom: 17,
    );
    return Scaffold(
      body: GoogleMap(
        markers: {if (_locationSelected) _selectedLocation},
        circles: {if (_locationSelected) _selectedLocationCircle},
        onLongPress: (pos) {
          setState(() {
            _selectedLocation = Marker(
                markerId: const MarkerId("Selected"),
                infoWindow: const InfoWindow(title: "Origin"),
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
        onMapCreated: (controller) => initializeMap(controller),
      ),
      floatingActionButton: !_isLoading
          ? FloatingActionButton(
              onPressed: () => _googleMapController.animateCamera(
                  CameraUpdate.newCameraPosition(_initialCameraPosition)),
              child: const Icon(Icons.pin_drop_rounded),
            )
          : null,
    );
  }
}
