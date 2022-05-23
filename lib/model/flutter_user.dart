class FlutterUser {
  final String firstName;
  final String middleName;
  final String lastName;
  final String uid;
  final String photoUrl;
  final String phoneNumber;
  final int age;
  final int trustPoint;
  final String bio;
  final List followers;
  final List following;
  const FlutterUser(
      {required this.firstName,
      required this.middleName,
      required this.lastName,
      required this.phoneNumber,
      required this.uid,
      required this.photoUrl,
      required this.age,
      required this.trustPoint,
      required this.bio,
      required this.followers,
      required this.following});
  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "middleName": middleName,
        "lastName": lastName,
        "phoneNumber": phoneNumber,
        "uid": uid,
        "photoUrl": photoUrl,
        "age": age,
        "trustPoint": trustPoint,
        "bio": bio,
        "followers": followers,
        "following": following
      };
  //     static FlutterUser fromSnap(DocumentSnapshot snap) {
  //   var snapShot = snap.data() as Map<String, dynamic>;
  //   return FlutterUser(
  //       email: snapShot['username'],
  //       uid: snapShot['uid'],
  //       photoUrl: snapShot['photoUrl'],
  //       username: snapShot['username'],
  //       bio: snapShot['bio'],
  //       followers: snapShot['followers'],
  //       following: snapShot['following']);
  // }
}
