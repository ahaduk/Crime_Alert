import 'package:cloud_firestore/cloud_firestore.dart';

class PoliceStation {
  final String uid;
  final String email;
  final String? photoUrl;
  final double latitude;
  final double longitude;
  final String primaryContact;
  final String? secondaryContact;
  final String stationCode;
  const PoliceStation({
    required this.uid,
    required this.email,
    this.photoUrl,
    required this.latitude,
    required this.longitude,
    required this.primaryContact,
    this.secondaryContact,
    required this.stationCode,
  });
  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "latitude": latitude,
        "longitude": longitude,
        "primaryContact": primaryContact,
        "secondaryContact": secondaryContact,
        "stationCode": stationCode
      };
  static PoliceStation fromSnap(DocumentSnapshot snap) {
    var snapShot = snap.data() as Map<String, dynamic>;
    return PoliceStation(
        uid: snapShot['uid'],
        email: snapShot['email'],
        photoUrl: snapShot['imgUrl'],
        latitude: snapShot['latitude'],
        longitude: snapShot['longitude'],
        primaryContact: snapShot['primaryContact'],
        secondaryContact: snapShot['secondaryContact'],
        stationCode: snapShot['stationCode']);
  }
}
