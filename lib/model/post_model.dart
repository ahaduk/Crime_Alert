import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class Post {
  final String description;
  final String uid;
  final DateTime datePublished;
  final String? imgUrl;
  final GeoFirePoint reportLocation;
  const Post(
      {required this.description,
      required this.uid,
      required this.datePublished,
      this.imgUrl,
      required this.reportLocation});
  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "datePublished": datePublished,
        "imgUrl": imgUrl,
        "reportLocation": reportLocation.data
      };
  static Post fromSnap(DocumentSnapshot snap) {
    var snapShot = snap.data() as Map<String, dynamic>;
    GeoPoint p1 = snapShot['reportLocation']['geopoint'] as GeoPoint;
    GeoFirePoint p2 = GeoFirePoint(p1.latitude, p1.longitude);
    return Post(
        description: snapShot['description'],
        uid: snapShot['uid'],
        datePublished: (snapShot['datePublished'] as Timestamp).toDate(),
        imgUrl: snapShot['imgUrl'],
        reportLocation: p2);
  }
}
