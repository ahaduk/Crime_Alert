import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class FlutterUser {
  final String? fullName;
  final String uid;
  final bool isAgent;
  final bool keepMeAlert;
  final String? photoUrl;
  final String phoneNumber;
  final int? trustPoint;
  final String? bio;
  final List? followers;
  final List? following;
  final GeoFirePoint? lastKnownLocation;
  const FlutterUser(
      {this.fullName,
      required this.phoneNumber,
      required this.uid,
      required this.isAgent,
      required this.keepMeAlert,
      this.photoUrl,
      this.trustPoint,
      this.bio,
      this.followers,
      this.following,
      this.lastKnownLocation});
  Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "phoneNumber": phoneNumber,
        "uid": uid,
        "isAgent": isAgent,
        "keepMeAlert": keepMeAlert,
        "photoUrl": photoUrl,
        "trustPoint": trustPoint,
        "bio": bio,
        "followers": followers,
        "following": following,
        "lastKnownLocation": lastKnownLocation
      };
  static FlutterUser fromSnap(DocumentSnapshot snap) {
    var snapShot = snap.data() as Map<String, dynamic>;
    return FlutterUser(
        uid: snapShot['uid'],
        isAgent: snapShot['isAgent'],
        keepMeAlert: snapShot['keepMeAlert'],
        photoUrl: snapShot['photoUrl'],
        bio: snapShot['bio'],
        followers: snapShot['followers'],
        following: snapShot['following'],
        fullName: snapShot['fullName'],
        phoneNumber: snapShot['phoneNumber'],
        trustPoint: snapShot['trustPoint']);
  }
}
