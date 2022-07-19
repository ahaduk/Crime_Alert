import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crime_alert/components/post_preview_card.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class UserPosts extends StatelessWidget {
  const UserPosts({
    Key? key,
    required String userId,
    required bool locationEnabled,
    required Position currentLocation,
  })  : _userId = userId,
        _locationEnabled = locationEnabled,
        _currentLocation = currentLocation,
        super(key: key);

  final String _userId;
  final bool _locationEnabled;
  final Position _currentLocation;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: _userId)
          .orderBy('datePublished', descending: true)
          .snapshots(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
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
              reportLocation: snapshot.data!.docs[index]['reportLocation']
                  ['geopoint'] as GeoPoint,
              currentLocation: _locationEnabled ? _currentLocation : null,
              snap: snapshot.data!.docs[index],
              userId: _userId,
              postDescription: snapshot.data!.docs[index]['description'],
              id: snapshot.data!.docs[index].id,
              picUrl: snapshot.data!.docs[index]['imgUrl'],
              dateTimeOfPost:
                  (snapshot.data!.docs[index]['datePublished'] as Timestamp)
                      .toDate(),
            );
          },
        );
      },
    );
  }
}
