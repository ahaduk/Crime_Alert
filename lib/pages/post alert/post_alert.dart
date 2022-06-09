import 'dart:typed_data';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crime_alert/components/user_profile_avatar.dart';
import 'package:crime_alert/resources/firestore_methods.dart';
import 'package:crime_alert/utility/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  Uint8List? _file;
  bool _isLoading = false, _imageSelected = false, _locationSelected = false;
  final TextEditingController _descriptionController = TextEditingController();
  final Completer<GoogleMapController> _googleMapController = Completer();
  late Position _currentposition;
  late Marker _selectedLocation;
  late double _distanceInMeters;
  Set<Marker> markers = {};
  late BitmapDescriptor customMapMarker;
  void setCustomMarker() async {
    customMapMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "assets/siren.png");
  }

  @override
  void dispose() {
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
                //Validate
                if (!_locationSelected) {
                  showSnackbar(
                      "Please select a location for the alert", context);
                  return;
                }
                if (_descriptionController.text == "") {
                  showSnackbar("Descripton can not be empty", context);
                  return;
                }
                if (_distanceInMeters > 2000) {
                  showSnackbar(
                      "Report location can not be greater than 2KM from your current location.",
                      context);
                  return;
                }
                setState(() {
                  _isLoading = true;
                });
                //Uploading
                String res = await FireStoreMethods().uploadPost(
                    _descriptionController.text,
                    _file,
                    FirebaseAuth.instance.currentUser!.uid,
                    "Test data",
                    GeoPoint(_selectedLocation.position.latitude,
                        _selectedLocation.position.longitude));
                setState(() {
                  _isLoading = false;
                });
                if (res == "success") {
                  showSnackbar("Successfully posted alert!", context);
                  Get.back();
                } else {
                  showSnackbar("Failed to upload alert", context);
                }
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
                              _currentposition = currentLocation;
                              //Adding marker
                              markers.add(Marker(
                                  markerId: const MarkerId("Current Location"),
                                  position: LatLng(currentLocation.latitude,
                                      currentLocation.longitude)));
                              buildLocationSelector(
                                  context, _initialCameraPosition);
                            } catch (e) {
                              showSnackbar(e.toString(), context);
                              Get.back();
                            }
                          },
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  _locationSelected
                                      ? const Text("Change Location")
                                      : const Text("Choose Location"),
                                  const Icon(Icons.map)
                                ],
                              ),
                              _locationSelected
                                  ? Text(
                                      _distanceInMeters.toStringAsFixed(3) +
                                          " Meters away",
                                      style: TextStyle(
                                          color: _distanceInMeters > 2000
                                              ? Colors.red
                                              : Colors.blue),
                                    )
                                  : Container()
                            ],
                          )),
                    ],
                  ),
                  _imageSelected
                      ? SizedBox(
                          height: MediaQuery.of(context).size.width * 1,
                          width: MediaQuery.of(context).size.width * 1,
                          child: Image.memory(_file!),
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
                          _selectedLocation = Marker(
                              markerId: const MarkerId("reportLocation"),
                              position: pos,
                              icon: customMapMarker);
                          _distanceInMeters = calculateDistance(
                              _currentposition.latitude,
                              _currentposition.longitude,
                              pos.latitude,
                              pos.longitude);
                          setState(() {
                            _locationSelected = true;
                            _distanceInMeters *= 1000;
                          });
                          setStateModal(
                              () {}); //Setstate for modal to refresh selected location
                          if (_distanceInMeters > 2000) {
                            showSnackbar(
                                "Report location can not be greater than 2KM from your current location.",
                                context);
                          }
                        },
                        zoomControlsEnabled: false,
                        initialCameraPosition: _initialCameraPosition,
                        onMapCreated: (GoogleMapController controller) {
                          setCustomMarker();
                          if (!_googleMapController.isCompleted) {
                            _googleMapController.complete(controller);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
        });
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
