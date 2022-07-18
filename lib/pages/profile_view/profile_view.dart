import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crime_alert/components/post_preview_card.dart';
import 'package:crime_alert/components/user_profile_card.dart';
import 'package:crime_alert/model/flutter_user.dart';
import 'package:crime_alert/utility/dimensions.dart';
import 'package:crime_alert/utility/utils.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';

class ProfileView extends StatefulWidget {
  final FlutterUser fuser;
  const ProfileView({Key? key, required this.fuser}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
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

  @override
  Widget build(BuildContext context) {
    final FlutterUser _fuser = widget.fuser;
    if (_isLoading && !_locationEnabled) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.only(bottom: 40),
                    child: UserProfileCard(ownProfile: false, fuser: _fuser)),
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
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: _fuser.uid)
                      .orderBy('datePublished', descending: true)
                      .get(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return PostPreview(
                          reportLocation: snapshot.data!.docs[index]
                              ['reportLocation']['geopoint'] as GeoPoint,
                          currentLocation:
                              _locationEnabled ? _currentLocation : null,
                          snap: snapshot.data!.docs[index],
                          posterUser: _fuser,
                          postDescription: snapshot.data!.docs[index]
                              ['description'],
                          id: snapshot.data!.docs[index].id,
                          picUrl: snapshot.data!.docs[index]['imgUrl'],
                          dateTimeOfPost: (snapshot.data!.docs[index]
                                  ['datePublished'] as Timestamp)
                              .toDate(),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
