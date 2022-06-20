import 'package:cloud_firestore/cloud_firestore.dart';

class Leaflet {
  final String description;
  final String uid;
  final DateTime datePublished;
  final String? imgUrl;
  final GeoPoint? reportLocation;
  final double? reward;
  final double primaryContact;
  final double? secondaryContact;
  final bool isWanted;
  const Leaflet(
      {required this.description,
      required this.uid,
      required this.datePublished,
      this.imgUrl,
      this.reportLocation,
      this.reward,
      required this.isWanted,
      required this.primaryContact,
      this.secondaryContact});
  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "datePublished": datePublished,
        "imgUrl": imgUrl,
        "reportLocation": reportLocation,
        "reward": reward,
        "isWanted": isWanted,
        "primaryContact": primaryContact,
        "secondaryContact": secondaryContact
      };
  static Leaflet fromSnap(DocumentSnapshot snap) {
    var snapShot = snap.data() as Map<String, dynamic>;
    return Leaflet(
        description: snapShot['description'],
        uid: snapShot['uid'],
        datePublished: snapShot['datePublished'],
        imgUrl: snapShot['imgUrl'],
        reportLocation: snapShot['reportLocation'],
        reward: snapShot['reward'],
        isWanted: snapShot['isWanted'],
        primaryContact: snapShot['primaryContact'],
        secondaryContact: snapShot['secondaryContact']);
  }
}
