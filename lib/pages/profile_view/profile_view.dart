import 'package:crime_alert/components/user_profile_card.dart';
import 'package:crime_alert/model/flutter_user.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  final FlutterUser fuser;
  const ProfileView({Key? key, required this.fuser}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    final FlutterUser _fuser = widget.fuser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [UserProfileCard(ownProfile: false, fuser: _fuser)],
          ),
        ),
      ),
    );
  }
}
