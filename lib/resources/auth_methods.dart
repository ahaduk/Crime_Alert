import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crime_alert/model/flutter_user.dart' as model;
import 'package:crime_alert/resources/firestore_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<model.FlutterUser?> getUserDetails() async {
    User? currentUser = _auth.currentUser;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser?.uid).get();
    return model.FlutterUser.fromSnap(snap);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String> verifyUser(
      {required String verificationId, required String otpCode}) async {
    String? res;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otpCode);

    // Sign the user with the credential
    try {
      await _auth.signInWithCredential(credential).then((credentials) async {
        bool? userExists =
            await FireStoreMethods().checkIfUserExists(credentials.user!.uid);
        if (userExists != null && !userExists) {
          //If user does not exist initialize data
          FireStoreMethods().initializeUserData(
              credentials.user!.uid, credentials.user!.phoneNumber!);
        }
      });
      res = "Successfully signed in";
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-verification-code') {
        res = 'The entered code is invalid';
      } else {
        res = err.code;
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
