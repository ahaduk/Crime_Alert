import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crime_alert/model/flutter_user.dart';
import 'package:crime_alert/resources/storage_methods.dart';
import 'package:crime_alert/utility/utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

import '../model/post_model.dart';

class FireStoreMethods {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  //To get any user details
  Future<FlutterUser> getUserDetails(String uid) async {
    DocumentSnapshot snap =
        await _firebaseFirestore.collection('users').doc(uid).get();
    return FlutterUser.fromSnap(snap);
  }

  Future<String> setprofilePic(Uint8List file, String uid) async {
    String res = "Some Error Occured";
    try {
      // to storage
      String? photoUrl = await StorageMethods().uploadImageToStorage(
          'users', file, false); //Is not post 'false' to overwrite user data
      // to firestore
      _firebaseFirestore
          .collection('users')
          .doc(uid)
          .update({'photoUrl': photoUrl});
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // upload post
  Future<String> uploadPost(String description, Uint8List? file, String uid,
      String username, GeoFirePoint reportLocation) async {
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

  Future<bool?> checkIfUserExists(String uid) async {
    bool? exists = false;
    await _firebaseFirestore.collection('users').doc(uid).get().then((doc) {
      exists = doc.exists;
    });
    return exists;
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
      String postId, String? postUrl, BuildContext context) async {
    try {
      // Remove from storage
      if (postUrl != null) {
        await FirebaseStorage.instance.refFromURL(postUrl).delete();
      }
      await _firebaseFirestore.collection('posts').doc(postId).delete();
      showSnackbar("Successfully deleted post", context);
    } catch (err) {
      showSnackbar("Failed to delete post", context);
    }
  }

  Future<void> followUser(String uid, String followId) async {
    await _firebaseFirestore.collection('users').doc(followId).update({
      'followers': FieldValue.arrayUnion([uid])
    });
    await _firebaseFirestore.collection('users').doc(uid).update({
      'following': FieldValue.arrayUnion([followId])
    });
  }

  Future<void> unfollowUser(String uid, String followId) async {
    await _firebaseFirestore.collection('users').doc(followId).update({
      'followers': FieldValue.arrayRemove([uid])
    });
    await _firebaseFirestore.collection('users').doc(uid).update({
      'following': FieldValue.arrayRemove([followId])
    });
  }
}
