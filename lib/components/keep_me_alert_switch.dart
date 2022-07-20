import 'package:crime_alert/resources/firestore_methods.dart';
import 'package:crime_alert/utility/colors.dart';
import 'package:crime_alert/utility/dimensions.dart';
import 'package:crime_alert/utility/utils.dart';
import 'package:crime_alert/widget/big_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class KeepMeAlert extends StatefulWidget {
  final bool toggled;
  const KeepMeAlert({Key? key, required this.toggled}) : super(key: key);

  @override
  State<KeepMeAlert> createState() => _KeepMeAlertState();
}

class _KeepMeAlertState extends State<KeepMeAlert> {
  bool stateSet = false;
  late bool _toggled;
  @override
  Widget build(BuildContext context) {
    if (!stateSet) {
      _toggled = widget.toggled;
    }
    return SwitchListTile(
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
        onChanged: (bool value) async {
          if (await Geolocator.isLocationServiceEnabled()) {
            String res = await FireStoreMethods().toggleKeepMeAlert(
                FirebaseAuth.instance.currentUser!.uid, value);
            showSnackbar(res, context);
            setState(() {
              _toggled = value;
              stateSet = true;
            });
          } else {
            showSnackbar(
                'You need to enable your location to stay alert', context);
          }
        });
  }
}
