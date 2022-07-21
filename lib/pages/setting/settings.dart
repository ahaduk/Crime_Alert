import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crime_alert/components/keep_me_alert_switch.dart';
import 'package:crime_alert/components/no_account_text.dart';
import 'package:crime_alert/model/flutter_user.dart';
import 'package:crime_alert/pages/emergency_contacts/emergency_contacts.dart';
import 'package:crime_alert/pages/user_agreement/user_agreement.dart';
import 'package:crime_alert/resources/auth_methods.dart';
import 'package:crime_alert/utility/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/user_profile_card.dart';
import '../../utility/colors.dart';
import '../../utility/dimensions.dart';
import '../../widget/big_text.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _toggled = false;
  FlutterUser? _fuser;

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      getUser();
    }
  }

  Future<void> getUser() async {
    FlutterUser? fuser = await AuthMethods().getUserDetails();
    setState(() {
      _fuser = fuser;
      _toggled = _fuser!.keepMeAlert;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: getUser,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
              padding: EdgeInsets.only(
                  left: Dimensions.width30, top: 80, right: Dimensions.width30),
              child: Column(
                children: [
                  // Conditionally show user profile card if user signed in
                  StreamBuilder(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder:
                        (BuildContext context, AsyncSnapshot<User?> snapshot) {
                      if (snapshot.data != null) {
                        //If logged in
                        return FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .get(),
                            builder: (context,
                                AsyncSnapshot<DocumentSnapshot?> usersnap) {
                              var userDocument = usersnap.data;
                              if (usersnap.hasData) {
                                _fuser = FlutterUser.fromSnap(userDocument!);
                                return UserProfileCard(
                                  ownProfile: true,
                                  fuser: _fuser!,
                                );
                              }
                              return Container();
                            });
                      }
                      return const NoAccountText();
                    },
                  ),
                  SizedBox(
                    height: Dimensions.height20,
                  ),
                  //  Settings
                  Column(children: [
                    _fuser != null
                        ? KeepMeAlert(toggled: _toggled)
                        : Container(),
                    //  User Agreement
                    ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: const Icon(
                        Icons.supervised_user_circle_outlined,
                        size: 26,
                        color: AppColors.mainColor,
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: AppColors.iconColor2,
                      ),
                      title: BigText(
                        text: "Privacy Policy",
                        size: Dimensions.font16,
                        color: AppColors.textColor,
                      ),
                      onTap: () {
                        Get.to(() => const UserAgreement());
                      },
                    ),
                    //  Emergency
                    ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: const Icon(
                        Icons.warning_rounded,
                        size: 26,
                        color: AppColors.mainColor,
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: AppColors.iconColor2,
                      ),
                      title: BigText(
                        text: "Emergency Contacts",
                        size: Dimensions.font16,
                        color: AppColors.textColor,
                      ),
                      onTap: () {
                        Get.to(() => const EmergencyPage());
                      },
                    ),
                    //  About crime alert
                    ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: const Icon(
                        Icons.info,
                        size: 26,
                        color: AppColors.mainColor,
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: AppColors.mainColor,
                      ),
                      title: BigText(
                        text: "About Crime Alert",
                        size: Dimensions.font16,
                        color: AppColors.textColor,
                      ),
                      onTap: () {
                        showAboutDialog(
                            context: context,
                            applicationVersion: '1.0.1',
                            applicationName: 'Crime Alert',
                            children: [
                              const Text(
                                  "Crime alert is an online social based system aimed to keep users aware on crime and crime related topics."),
                            ]);
                      },
                    ),
                    _fuser != null
                        ? ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            leading: const Icon(
                              Icons.logout,
                              size: 26,
                              color: AppColors.mainColor,
                            ),
                            title: BigText(
                              text: "Logout",
                              size: Dimensions.font16,
                              color: AppColors.textColor,
                            ),
                            onTap: () async {
                              showDialog(
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor:
                                        Theme.of(context).bottomAppBarColor,
                                    title: Center(
                                      child: Text(
                                        "Logout",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: Dimensions.height20,
                                            color: AppColors.mainColor),
                                      ),
                                    ),
                                    content: const Text(
                                      "Do you want to Logout?",
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: AppColors.titlecolor),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          "No",
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: AppColors.nocolor),
                                        ),
                                      ),
                                      TextButton(
                                          onPressed: () async {
                                            Navigator.pop(context);

                                            await AuthMethods().signOut();
                                            Utils.showSnackbar(
                                                "Signed out successfully"
                                                    .toString(),
                                                context);
                                            setState(() {
                                              _fuser = null;
                                            });
                                          },
                                          child: const Text("Yes",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: AppColors.yescolor)))
                                    ],
                                    elevation: 5.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  );
                                },
                                context: context,
                              );
                            },
                          )
                        : Container(),
                  ]),
                ],
              )),
        ),
      ),
    );
  }
}
