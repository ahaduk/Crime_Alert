import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crime_alert/components/postcard.dart';
import 'package:crime_alert/model/flutter_user.dart';
import 'package:crime_alert/resources/auth_methods.dart';
import 'package:crime_alert/utility/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Following extends StatefulWidget {
  const Following({Key? key}) : super(key: key);

  @override
  State<Following> createState() => _FollowingState();
}

class _FollowingState extends State<Following> {
  late Position _currentLocation;
  FlutterUser? _fuser;
  bool _locationEnabled = false, _isLoading = true;
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
        });
      } catch (e) {
        showSnackbar("Please enable location services.", context);
      }
    }
  }

  Future<void> getUser() async {
    FlutterUser fuser = await AuthMethods().getUserDetails();
    setState(() {
      _fuser = fuser;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    getLocation();
    if (FirebaseAuth.instance.currentUser != null) {
      getUser();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FirebaseAuth.instance.currentUser == null
                ? const Center(
                    child: Text(
                      "Please login to see alerts from your safety agents",
                      textAlign: TextAlign.center,
                    ),
                  )
                : Flexible(
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : _fuser!.following == null ||
                                _fuser!.following!.isEmpty
                            ? const Center(
                                child: Text(
                                    "Please start following an agent to see your agents"),
                              )
                            : StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('posts')
                                    .where('uid', whereIn: _fuser!.following)
                                    .orderBy('datePublished', descending: true)
                                    .limit(15)
                                    .snapshots(),
                                builder: (context,
                                    AsyncSnapshot<
                                            QuerySnapshot<Map<String, dynamic>>>
                                        snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (snapshot.data != null &&
                                      snapshot.data!.docs.isEmpty) {
                                    return const Center(
                                      child: Text(
                                        "No Feeds Available\nStart following someone to see posts",
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  }
                                  if (snapshot.data != null) {
                                    return ListView.builder(
                                      itemCount: snapshot.data!.docs.length,
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return PostCard(
                                          snap:
                                              snapshot.data!.docs[index].data(),
                                          docId: snapshot.data!.docs[index]
                                                  .reference.id +
                                              "fo",
                                          currentLocation: _locationEnabled
                                              ? _currentLocation
                                              : null,
                                        );
                                      },
                                    );
                                  }
                                  return const Center(
                                    child: Text("Something Went Wrong"),
                                  );
                                },
                              ),
                  )
          ],
        ),
      ]),
    );
  }
}
