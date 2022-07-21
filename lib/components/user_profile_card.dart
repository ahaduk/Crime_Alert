import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crime_alert/components/follow_button.dart';
import 'package:crime_alert/components/unfollow_button.dart';
import 'package:crime_alert/model/flutter_user.dart';
import 'package:crime_alert/resources/firestore_methods.dart';
import 'package:crime_alert/utility/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../utility/colors.dart';
import '../utility/dimensions.dart';
import '../widget/big_text.dart';
import '../widget/small_text.dart';

class UserProfileCard extends StatefulWidget {
  final bool ownProfile;
  final FlutterUser fuser;
  const UserProfileCard(
      {Key? key, required this.ownProfile, required this.fuser})
      : super(key: key);

  @override
  State<UserProfileCard> createState() => _UserProfileCardState();
}

class _UserProfileCardState extends State<UserProfileCard> {
  Uint8List? _file;
  bool _imageSelected = false, _settingProfile = false;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.fuser.uid)
          .snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.mainColor,
            ),
          );
        }
        if (!snapshot.data!.exists) {
          return const Center(
            child: Text(
              "Something went wrong",
              textAlign: TextAlign.center,
            ),
          );
        }
        final FlutterUser? _fuser = FlutterUser.fromSnap(snapshot.data!);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _imageSelected && !_settingProfile
                ? showImageConfirmationPopup(context)
                : Container(),
            _settingProfile
                ? const Center(
                    child: CircularProgressIndicator(
                    color: AppColors.mainColor,
                  ))
                : Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BigText(
                  text:
                      _fuser!.fullName != null ? _fuser.fullName! : "Civilian",
                  size: Dimensions.font26,
                  color: AppColors.textColor,
                  overflow: TextOverflow.fade,
                ),
                GestureDetector(
                  onTap: () {
                    if (!_fuser.isAgent) {
                      Utils.showSnackbar(
                          "Civilians don't need a profile picture", context);
                    } else if (FirebaseAuth.instance.currentUser != null &&
                        FirebaseAuth.instance.currentUser!.uid == _fuser.uid) {
                      _selectImage(context);
                    }
                  },
                  child: _imageSelected
                      ?
                      //This means there is image to be profile and shown as preview
                      CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: MemoryImage(_file!),
                          radius: 50,
                        )
                      :
                      //Actual profile picture
                      _fuser.photoUrl != null
                          ? CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(_fuser.photoUrl!),
                              radius: 50,
                            )
                          : const CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage("assets/profile.png"),
                              radius: 50,
                            ),
                ),
              ],
            ),
            widget.ownProfile
                ? Row(
                    children: [
                      const Text("Phone Number: "),
                      Text(
                        FirebaseAuth.instance.currentUser!.phoneNumber
                            .toString()
                            .replaceRange(8, 11, "***"),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                : Container(),
            SizedBox(
              height: Dimensions.height15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(left: Dimensions.width10),
                  child: SmallText(
                    text: _fuser.isAgent ? "Agent Profile" : "Civilian Profile",
                    size: Dimensions.font16,
                    color: AppColors.paraColor,
                  ),
                ),
                // If user is signed in show follow unfollow btn and not own profile
                FirebaseAuth.instance.currentUser != null &&
                        _fuser.uid != FirebaseAuth.instance.currentUser!.uid
                    ? Container(
                        child: _fuser.followers != null &&
                                _fuser.followers!.contains(
                                    FirebaseAuth.instance.currentUser!.uid)
                            ?
                            // Show unfollow if user already follows else show follow button
                            UnfollowButton(userId: _fuser.uid)
                            : FollowButton(userId: _fuser.uid),
                      )
                    : Container()
              ],
            ),

            const SizedBox(height: 10),
            // Post, follower, follwing
            Container(
              height: 90,
              padding: EdgeInsets.only(
                  left: Dimensions.width20, right: Dimensions.width20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    offset: const Offset(0, 10),
                    blurRadius: 10,
                  ),
                ],
                borderRadius: BorderRadius.all(
                  Radius.circular(Dimensions.radius10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: BigText(
                          text: _fuser.trustPoint == null
                              ? 0.toString()
                              : _fuser.trustPoint!.toString(),
                        ),
                      ),
                      SmallText(
                        text: "Trust Points",
                        size: Dimensions.font15,
                        color: AppColors.paraColor,
                      ),
                    ],
                  ),
                  const BigText(
                    text: "|",
                    size: 18,
                    color: AppColors.iconColor2,
                  ),
                  // Following Colum
                  Column(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: BigText(
                          text: _fuser.followers == null ||
                                  _fuser.followers!.isEmpty
                              ? 0.toString()
                              : _fuser.followers!.length.toString(),
                        ),
                      ),
                      SmallText(
                        text: "Followers",
                        size: Dimensions.font15,
                        color: AppColors.paraColor,
                      ),
                    ],
                  ),
                  const BigText(
                    text: "|",
                    size: 18,
                    color: AppColors.iconColor2,
                  ),
                  // Follower Colum
                  Column(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: BigText(
                          text: _fuser.following == null ||
                                  _fuser.following!.isEmpty
                              ? 0.toString()
                              : _fuser.following!.length.toString(),
                        ),
                      ),
                      SmallText(
                        text: "Following",
                        size: Dimensions.font15,
                        color: AppColors.paraColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  _selectImage(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Set Profile Picture'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a Photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List? file = await pickImage(ImageSource.camera);
                  if (file != null) {
                    setState(() {
                      _file = file;
                      _imageSelected = true;
                    });
                  }
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List? file = await pickImage(ImageSource.gallery);
                  if (file != null) {
                    setState(() {
                      _file = file;
                      _imageSelected = true;
                    });
                  }
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _file = null;
                    _imageSelected = false;
                  });
                },
              )
            ],
          );
        });
  }

  SimpleDialog showImageConfirmationPopup(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(20.0),
      children: [
        const Text("Continue to set profile picture",
            textAlign: TextAlign.center),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
                onPressed: () {
                  setState(() {
                    _file = null;
                    _imageSelected = false;
                  });
                },
                child: const Text("Cancel")),
            TextButton(
                onPressed: () async {
                  setState(() {
                    _settingProfile = true;
                  });
                  //set profile pic
                  String res = await FireStoreMethods().setprofilePic(
                      _file!, FirebaseAuth.instance.currentUser!.uid);
                  Utils.showSnackbar(res, context);
                  setState(() {
                    _file = null;
                    _imageSelected = false;
                    _settingProfile = false;
                  });
                },
                child: const Text("Continue"))
          ],
        ),
      ],
    );
  }
}
