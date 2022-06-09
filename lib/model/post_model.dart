import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final DateTime datePublished;
  final String? imgUrl;
  final GeoPoint reportLocation;
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
        "reportLocation": reportLocation
      };
  static Post fromSnap(DocumentSnapshot snap) {
    var snapShot = snap.data() as Map<String, dynamic>;
    return Post(
        description: snapShot['description'],
        uid: snapShot['uid'],
        datePublished: snapShot['datePublished'],
        imgUrl: snapShot['imgUrl'],
        reportLocation: snapShot['reportLocation']);
  }
}
