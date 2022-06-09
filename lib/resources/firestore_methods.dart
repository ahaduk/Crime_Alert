import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crime_alert/resources/auth_methods.dart';
import 'package:crime_alert/resources/storage_methods.dart';

import '../model/post_model.dart';

class FireStoreMethods {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  // upload post
  Future<String> uploadPost(String description, Uint8List? file, String uid,
      String username, GeoPoint reportLocation) async {
    String res = "Some Error Occured";
    try {
      String? photoUrl;
      // to storage
      if (file != null) {
        photoUrl =
            await StorageMethods().uploadImageToStorage('posts', file, true);
      }
      Post post = Post(
        description: description,
        uid: uid,
        datePublished: DateTime.now(),
        imgUrl: photoUrl,
        reportLocation: reportLocation,
      );
      // to firestore
      _firebaseFirestore.collection('posts').add(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  bool checkIfUserExists(String uid) {
    _firebaseFirestore
        .collection('users')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        return true;
      } else {
        return false;
      }
    });
    return false;
  }

  String initializeUserData(String uid, String phoneNumber) {
    String res = "Failed to add user";
    _firebaseFirestore
        .collection('users')
        .add({'phone': phoneNumber, 'isAgent': false})
        .then((value) => "User Added")
        .catchError((error) => "Failed to add user: $error");
    return res;
  }
}
