import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Future<model.User> getUserDetails() async {
  //   User? currentUser = _auth.currentUser;
  //   DocumentSnapshot snap =
  //       await _firestore.collection('users').doc(currentUser?.uid).get();
  //   return FlutterUser.fromSnap(snap);
  // }

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
      await _auth.signInWithCredential(credential);
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
