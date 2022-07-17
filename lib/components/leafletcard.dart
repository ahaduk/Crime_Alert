import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crime_alert/components/police_inkwell.dart';
import 'package:crime_alert/model/police_station.dart';
import 'package:crime_alert/resources/firestore_methods.dart';
import 'package:crime_alert/utility/constants.dart';
import 'package:crime_alert/utility/utils.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:crime_alert/components/Skeleton.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../pages/post description/leaflet_description_screen.dart';
import '../widget/big_text.dart';

class LeafletCard extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final snap;
  final String docId;
  final Position? currentLocation;
  const LeafletCard(
      {Key? key, required this.snap, required this.docId, this.currentLocation})
      : super(key: key);

  @override
  State<LeafletCard> createState() => LeafletCardState();
}

class LeafletCardState extends State<LeafletCard> {
  late final PoliceStation _policeStation;
  bool _policeSet = false;
  getPoliceStation() async {
    _policeStation = await FireStoreMethods().getPoliceInfo(widget.snap['uid']);
    if (super.mounted) {
      setState(() {
        _policeSet = true;
      });
    }
  }

  @override
  void initState() {
    getPoliceStation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime dateTimeOfPost =
        (widget.snap['datePublished'] as Timestamp).toDate();

    double distance = 0;

    GeoPoint reportLocation = (widget.snap['reportLocation'] as GeoPoint);

    widget.currentLocation != null
        ? distance = calculateDistance(
            widget.currentLocation!.latitude,
            widget.currentLocation!.longitude,
            reportLocation.latitude,
            reportLocation.longitude)
        : 0;
    int reward = 0;
    if (widget.snap['reward'] != null) {
      reward = widget.snap['reward'];
    }

    return GestureDetector(
      onTap: (() {
        Get.to(() => LeafletDescriptionScreen(
            picUrl: widget.snap['imgUrl'],
            postDescription: widget.snap['description'],
            id: widget.docId,
            snap: widget.snap,
            distance: distance,
            reward: reward,
            policeStation: _policeStation));
      }),
      child: Container(
        decoration: Constants.cardBoxDecoration,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          children: [
            _policeSet
                ? PoliceInkwell(policeStation: _policeStation)
                : Padding(
                    padding: const EdgeInsets.only(left: 25, bottom: 10),
                    child: Row(
                      children: const [
                        Skeleton(height: 40, width: 40),
                        SizedBox(width: 10),
                        Skeleton(width: 120),
                      ],
                    ),
                  ),
            widget.snap['imgUrl'] != null
                ? Hero(
                    tag: widget.docId + "photo",
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.55,
                      width: double.infinity,
                      child: Image.network(
                        widget.snap['imgUrl'],
                        fit: BoxFit.fitWidth,
                        errorBuilder: (context, url, error) => SizedBox(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.error),
                                Text('Unable to load image')
                              ],
                            )),
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : Container(),
            // text section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Hero(
                    tag: widget.docId + "description",
                    child: BigText(
                      text: widget.snap['description'],
                      size: 15,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      Text(
                        timeago.format(dateTimeOfPost),
                        style: const TextStyle(
                          color: Color.fromARGB(255, 111, 111, 111),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      reward != 0
                          ? Text("Reward: " + reward.toString() + " birr")
                          : const Text("Reward: Unavailable "),
                      const SizedBox(height: 10),
                      distance == 0
                          ? const Text("Last seen: Unknown")
                          : Text("Last seen: " +
                              distance.toStringAsFixed(2) +
                              "KM away"),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
