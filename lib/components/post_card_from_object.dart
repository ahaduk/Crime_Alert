import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crime_alert/components/Skeleton.dart';
import 'package:crime_alert/components/police_inkwell.dart';
import 'package:crime_alert/components/user_inkwell.dart';
import 'package:crime_alert/model/flutter_user.dart';
import 'package:crime_alert/model/police_station.dart';
import 'package:crime_alert/model/post_model.dart';
import 'package:crime_alert/resources/firestore_methods.dart';
import 'package:crime_alert/utility/constants.dart';
import 'package:crime_alert/utility/utils.dart';
import 'package:crime_alert/widget/big_text.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class PostCardFromList extends StatefulWidget {
  final Post post;
  final Position? currentLocation;
  const PostCardFromList({Key? key, required this.post, this.currentLocation})
      : super(key: key);

  @override
  State<PostCardFromList> createState() => _PostCardFromListState();
}

class _PostCardFromListState extends State<PostCardFromList> {
  FlutterUser? _posterUser;
  Position? _currentLocation;
  bool _userSet = false, _policeSet = false;
  late final PoliceStation _policeStation;
  getPoliceStation() async {
    _policeStation = await FireStoreMethods().getPoliceInfo(widget.post.uid);
    if (super.mounted) {
      setState(() {
        _policeSet = true;
      });
    }
  }

  //Also pass a user object or user id to identify profile of poster
  getPoster() async {
    _posterUser = await FireStoreMethods().getUserDetails(widget.post.uid);
    if (_posterUser == null) {
      //If post is not from agent it is from police station
      await getPoliceStation();
    }
    if (super.mounted) {
      setState(() {
        _userSet = true;
      });
    }
  }

  void getLocation() async {
    try {
      _currentLocation = await determinePosition();
    } catch (e) {
      try {
        _currentLocation = (await Geolocator.getLastKnownPosition())!;
        showSnackbar("Using last known location to load feed", context);
      } catch (e) {
        showSnackbar("Please enable location services.", context);
      }
    }
  }

  @override
  void initState() {
    getLocation();
    getPoster();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime dateTimeOfPost = widget.post.datePublished;
    GeoPoint reportLocation = widget.post.reportLocation.geoPoint;
    double distance = 0;
    _currentLocation != null
        ? distance = calculateDistance(
            _currentLocation!.latitude,
            _currentLocation!.longitude,
            reportLocation.latitude,
            reportLocation.longitude)
        : 0;
    return Container(
      decoration: Constants.cardBoxDecoration
          .copyWith(border: Border.all(color: Colors.grey)),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          buildConditionalInkwell(),
          const SizedBox(height: 5),
          widget.post.imgUrl != null
              ? Hero(
                  tag: widget.post.imgUrl.toString() + "photo",
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.55,
                    width: double.infinity,
                    child: Image.network(
                      widget.post.imgUrl!,
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
                  ))
              : Container(),
          // text section

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Hero(
                  tag: widget.post.description + "description",
                  child: BigText(
                    text: widget.post.description,
                    size: 15,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      timeago.format(dateTimeOfPost),
                      style: const TextStyle(
                        color: Color.fromARGB(255, 111, 111, 111),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(distance.toStringAsFixed(2) + "KM away"),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildConditionalInkwell() {
    if (_userSet && _posterUser != null) {
      return UserInkwell(
        posterUser: _posterUser!,
        postUrl: widget.post.imgUrl,
      );
    } else if (_policeSet) {
      return PoliceInkwell(policeStation: _policeStation);
    }
    //Show skeleton during user data fetch
    return Padding(
      padding: const EdgeInsets.only(left: 25, bottom: 10),
      child: Row(
        children: const [
          Skeleton(height: 40, width: 40),
          SizedBox(width: 10),
          Skeleton(width: 120),
        ],
      ),
    );
  }
}
