import 'dart:typed_data';

import 'package:crime_alert/components/user_profile_avatar.dart';
import 'package:crime_alert/utility/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../utility/dimensions.dart';

class PostAlertPage extends StatefulWidget {
  const PostAlertPage({Key? key}) : super(key: key);

  @override
  State<PostAlertPage> createState() => _PostAlertPageState();
}

class _PostAlertPageState extends State<PostAlertPage> {
  late Uint8List _file;
  bool _isLoading = false,
      _mapInitialized = false,
      _imageSelected = false,
      _locationSelected = false;
  final TextEditingController _descriptionController = TextEditingController();
  late GoogleMapController _googleMapController;
  late Marker _selectedLocation;
  Set<Marker> markers = {};
  late BitmapDescriptor customMapMarker;
  void setCustomMarker() async {
    customMapMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "assets/siren.png");
  }

  void initializeMap(GoogleMapController googleMapController) {
    _googleMapController = googleMapController;
    setCustomMarker();
    _mapInitialized = true;
  }

  @override
  void dispose() {
    if (_mapInitialized) {
      _googleMapController.dispose();
    }
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
              onPressed: () async {
                //Validate and upload
                setState(() {
                  _isLoading = true;
                });
                await Future.delayed(const Duration(seconds: 3));
                setState(() {
                  _isLoading = false;
                });
                showSnackbar("Successfully Uploaded Alert!", context);
              },
              child: const Text("Post"))
        ],
        title: Text(
          "Post an Alert",
          style: TextStyle(
            color: Colors.grey,
            fontSize: Dimensions.font16,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const LinearProgressIndicator()
          : SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const UserProfileAvatar(),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextField(
                            decoration: const InputDecoration(
                              hintText: 'Write a caption...',
                              border: InputBorder.none,
                            ),
                            controller: _descriptionController,
                            maxLength: 70,
                            maxLines: 8),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                          onPressed: () {
                            _selectImage(context);
                          },
                          child: Row(
                            children: [
                              _imageSelected
                                  ? const Text("Change Image")
                                  : const Text("Choose Image"),
                              const Icon(Icons.image),
                            ],
                          )),
                      TextButton(
                          onPressed: () async {
                            CameraPosition _initialCameraPosition =
                                CameraPosition(
                              //Setting default camera position
                              target: _locationSelected
                                  ? _selectedLocation.position
                                  : const LatLng(9.001135, 38.807583),
                              zoom: 17,
                            );
                            try {
                              //Getting current location and asking permission
                              Position currentLocation =
                                  await determinePosition();
                              _initialCameraPosition = CameraPosition(
                                target: LatLng(currentLocation.latitude,
                                    currentLocation.longitude),
                                zoom: 19,
                              );
                              //Adding marker
                              markers.add(Marker(
                                  markerId: const MarkerId("Current Location"),
                                  position: LatLng(currentLocation.latitude,
                                      currentLocation.longitude)));
                              buildLocationSelector(
                                  context, _initialCameraPosition);
                            } catch (e) {
                              showSnackbar(
                                  "You need to enable location to post an alert",
                                  context);
                              Get.back();
                            }
                          },
                          child: Row(
                            children: [
                              _locationSelected
                                  ? const Text("Change Location")
                                  : const Text("Choose Location"),
                              const Icon(Icons.map)
                            ],
                          )),
                    ],
                  ),
                  _imageSelected
                      ? SizedBox(
                          height: MediaQuery.of(context).size.width * 1,
                          width: MediaQuery.of(context).size.width * 1,
                          child: Image.memory(_file),
                        )
                      : Container(),
                ],
              ),
            ),
    );
  }

  Future<dynamic> buildLocationSelector(
      BuildContext context, CameraPosition _initialCameraPosition) {
    return showModalBottomSheet(
        enableDrag: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setStateModal) {
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
                          mapToolbarEnabled: false,
                          markers: {
                            if (_locationSelected) _selectedLocation,
                            ...markers
                          },
                          onTap: (pos) {
                            HapticFeedback.vibrate();
                            setState(() {
                              _selectedLocation = Marker(
                                  markerId: const MarkerId("reportLocation"),
                                  position: pos,
                                  icon: customMapMarker);
                              _locationSelected = true;
                            });
                            setStateModal(
                                () {}); //Setstate for modal to refresh selected location
                          },
                          zoomControlsEnabled: false,
                          initialCameraPosition: _initialCameraPosition,
                          onMapCreated: (controller) =>
                              initializeMap(controller)),
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

  Future<dynamic> _buildLocationSelector(
      BuildContext context, CameraPosition _initialCameraPosition) async {
    return;
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Add picture'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a Photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                    _imageSelected = true;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List? file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file!;
                    _imageSelected = true;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
