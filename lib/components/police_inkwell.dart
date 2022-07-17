import 'package:crime_alert/model/police_station.dart';
import 'package:crime_alert/pages/police_profile/police_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PoliceInkwell extends StatelessWidget {
  final PoliceStation policeStation;
  const PoliceInkwell({Key? key, required this.policeStation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
            .copyWith(right: 0),
        child: Row(
          children: [
            policeStation.photoUrl != null
                ? CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(policeStation.photoUrl!),
                  )
                : const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage("assets/policelogo.jpg"),
                    backgroundColor: Colors.white,
                  ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(
                            () => PoliceProfile(policeStation: policeStation));
                      },
                      child: Text(
                        'Station: ' + policeStation.stationCode,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
