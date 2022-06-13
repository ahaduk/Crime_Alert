import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crime_alert/model/flutter_user.dart';
import 'package:crime_alert/resources/storage_methods.dart';
import 'package:crime_alert/utility/utils.dart';
import 'package:flutter/cupertino.dart';

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
    FlutterUser userToInitialize = FlutterUser(
      uid: uid,
      phoneNumber: phoneNumber,
      isAgent: false,
      keepMeAlert: false,
    );
    _firebaseFirestore
        .collection('users')
        .doc(uid)
        .set(userToInitialize.toJson())
        .then((value) => "User Added")
        .catchError((error) => "Failed to add user: $error");
    return res;
  }

  Future<String?> upvote(String postId, String uid, List? upvotes) async {
    try {
      if (upvotes != null && upvotes.contains(uid)) {
        await _firebaseFirestore.collection('posts').doc(postId).update({
          'upvotes': FieldValue.arrayRemove([uid]),
        });
      } else if (upvotes != null && !upvotes.contains(uid)) {
        await _firebaseFirestore.collection('posts').doc(postId).update({
          'upvotes': FieldValue.arrayUnion([uid]),
          'downvotes': FieldValue.arrayRemove([uid]),
        });
      } else if (upvotes == null) {
        await _firebaseFirestore.collection('posts').doc(postId).update({
          'upvotes': FieldValue.arrayUnion([uid]),
          'downvotes': [],
        });
      }
    } catch (e) {
      return e.toString();
    }
    return null;
  }

  Future<String?> downvote(String postId, String uid, List? downvotes) async {
    try {
      if (downvotes != null && downvotes.contains(uid)) {
        await _firebaseFirestore.collection('posts').doc(postId).update({
          'downvotes': FieldValue.arrayRemove([uid]),
        });
      } else if (downvotes != null && !downvotes.contains(uid)) {
        await _firebaseFirestore.collection('posts').doc(postId).update({
          'upvotes': FieldValue.arrayRemove([uid]),
          'downvotes': FieldValue.arrayUnion([uid]),
        });
      } else if (downvotes == null) {
        await _firebaseFirestore.collection('posts').doc(postId).update({
          'upvotes': [],
          'downvotes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      return e.toString();
    }
    return null;
  }

  Future<void> deletePost(
      String postId, String postUrl, BuildContext context) async {
    try {
      // Remove from storage
      // await FirebaseStorage.instance.refFromURL(postUrl).delete();
      await _firebaseFirestore.collection('posts').doc(postId).delete();
      showSnackbar("Successfully deleted post", context);
    } catch (err) {
      showSnackbar("Failed to delete post", context);
    }
  }
}
