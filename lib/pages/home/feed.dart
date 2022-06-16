import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crime_alert/utility/utils.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import '../../components/postcard.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  late Position _currentLocation;
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
    super.initState();
  }

  _conditionalRender() {
    if (_isLoading && !_locationEnabled) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (!_isLoading && _locationEnabled) {
      GeoFirePoint center = geo.point(
          latitude: _currentLocation.latitude,
          longitude: _currentLocation.longitude);

// get the collection reference or query
      var collectionReference = FirebaseFirestore.instance.collection('posts');
      // .orderBy('datePublished', descending: true);

      Stream<List<DocumentSnapshot<Map<String, dynamic>>>> stream = geo
          .collection(collectionRef: collectionReference)
          .within(center: center, radius: 2, field: 'reportLocation');
      return Stack(children: [
        Column(
          children: [
            Expanded(
              child: StreamBuilder<List<DocumentSnapshot>>(
                stream: stream,
                builder: (context,
                    AsyncSnapshot<List<DocumentSnapshot<Object?>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data != null && snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "No Alerts Have Been Reported in Your Area\nKeep the notification on to get alerts",
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  if (snapshot.data != null) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return PostCard(
                          snap: snapshot.data![index].data(),
                          docId: snapshot.data![index].reference.id + "fe",
                          currentLocation: _currentLocation,
                        );
                      },
                    );
                  }
                  return const Center(
                    child: Text(
                      "Something went wrong",
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ]);
    }
    return const Center(
      child: Text('Please enable location services'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: _conditionalRender());
  }
}
