import 'package:crime_alert/components/no_account_text.dart';
import 'package:crime_alert/model/flutter_user.dart';
import 'package:crime_alert/pages/emergency_contacts/emergency_contacts.dart';
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
    FlutterUser fuser = await AuthMethods().getUserDetails();
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
                  // User Profile
                  FirebaseAuth.instance.currentUser != null && _fuser != null
                      ? UserProfileCard(
                          ownProfile: true,
                          fuser: _fuser!,
                        )
                      : const NoAccountText(),
                  SizedBox(
                    height: Dimensions.height20,
                  ),
                  //  Settings
                  Column(children: [
                    FirebaseAuth.instance.currentUser != null
                        ? SwitchListTile(
                            contentPadding: const EdgeInsets.all(0),
                            secondary: const Icon(
                              Icons.alarm,
                              size: 26,
                              color: AppColors.iconColor1,
                            ),
                            title: BigText(
                              text: "Keep Me alert",
                              size: Dimensions.font16,
                              color: AppColors.textColor,
                            ),
                            value: _toggled,
                            onChanged: (bool value) {
                              setState(() {
                                _toggled = value;
                              });
                            })
                        : Container(),
                    ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: const Icon(
                        Icons.verified_user_outlined,
                        size: 26,
                        color: AppColors.iconColor1,
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: AppColors.iconColor2,
                      ),
                      title: BigText(
                        text: "New Version",
                        size: Dimensions.font16,
                        color: AppColors.textColor,
                      ),
                      onTap: () {},
                    ),
                    //  User Agreement
                    ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: const Icon(
                        Icons.supervised_user_circle_outlined,
                        size: 26,
                        color: AppColors.iconColor1,
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: AppColors.iconColor2,
                      ),
                      title: BigText(
                        text: "User Agreement",
                        size: Dimensions.font16,
                        color: AppColors.textColor,
                      ),
                      onTap: () {},
                    ),
                    //  Emergency
                    ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: const Icon(
                        Icons.warning_rounded,
                        size: 26,
                        color: AppColors.iconColor1,
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
                    // Privacy
                    ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: const Icon(
                        Icons.lock_outline,
                        size: 26,
                        color: AppColors.iconColor1,
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: AppColors.iconColor2,
                      ),
                      title: BigText(
                        text: "Privacy",
                        size: Dimensions.font16,
                        color: AppColors.textColor,
                      ),
                      onTap: () {},
                    ),
                    //  About crime alert
                    ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: const Icon(
                        Icons.star_border,
                        size: 26,
                        color: AppColors.iconColor1,
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: AppColors.iconColor2,
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
                    FirebaseAuth.instance.currentUser != null
                        ? ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            leading: const Icon(
                              Icons.logout,
                              size: 26,
                              color: AppColors.iconColor1,
                            ),
                            title: BigText(
                              text: "Logout",
                              size: Dimensions.font16,
                              color: AppColors.textColor,
                            ),
                            onTap: () async {
                              await AuthMethods().signOut();
                              showSnackbar("Signed out successfully".toString(),
                                  context);
                              setState(() {});
                            },
                          )
                        : Container(),
                  ])
                ],
              )),
        ),
      ),
    );
  }
}
