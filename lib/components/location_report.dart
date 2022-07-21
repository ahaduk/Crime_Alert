import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crime_alert/components/detail_on_report.dart';
import 'package:crime_alert/model/post_model.dart';
import 'package:crime_alert/utility/colors.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LocationReport extends StatefulWidget {
  final double radius;
  final LatLng latlng;
  const LocationReport({Key? key, required this.radius, required this.latlng})
      : super(key: key);

  @override
  State<LocationReport> createState() => _LocationReportState();
}

class _LocationReportState extends State<LocationReport> {
  bool _reportLoading = true;
  final geo = Geoflutterfire();
  List<Post> _posts = [];
  List<Post> _updateMarkers(List<DocumentSnapshot> documentList) {
    List<Post> posts = [];
    for (var snap in documentList) {
      posts.add(Post.fromSnap(snap));
    }
    return posts;
  }

  List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  List<int> counter = [];
  List<_ReportsData> repData = [];
  void generateReport(double radius, LatLng latLng) {
    GeoFirePoint center =
        geo.point(latitude: latLng.latitude, longitude: latLng.longitude);
    var collectionReference = FirebaseFirestore.instance.collection('posts');
    Stream<List<DocumentSnapshot>> stream = geo
        .collection(collectionRef: collectionReference)
        .within(
            center: center,
            radius: 2,
            field: 'reportLocation',
            strictMode: true);
    stream.listen((List<DocumentSnapshot> documentList) {
      _posts = _updateMarkers(documentList);
      initializeData();
    });
  }

  void initializeData() {
    repData = [];
    counter = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    for (var i = 0; i < _posts.length; i++) {
      counter[_posts[i].datePublished.month - 1] += 1;
    }
    for (var i = 0; i < months.length; i++) {
      repData.add(_ReportsData(months[i], counter[i]));
    }
    setState(() {
      _reportLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    generateReport(widget.radius, widget.latlng);
  }

  @override
  Widget build(BuildContext context) {
    return _reportLoading
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Generating Report",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                CircularProgressIndicator(
                  color: AppColors.mainColor,
                )
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                SfCartesianChart(
                    title: ChartTitle(
                        text: 'Crime Rate Statistics',
                        textStyle: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                    // legend: Legend(isVisible: true),
                    primaryXAxis: CategoryAxis(),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <ChartSeries<_ReportsData, String>>[
                      LineSeries<_ReportsData, String>(
                        color: Colors.red,
                        dataSource: repData,
                        xValueMapper: (_ReportsData reports, _) =>
                            reports.month,
                        yValueMapper: (_ReportsData reports, _) =>
                            reports.reports,
                        name: 'Crime Reports',
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true),
                      )
                    ]),
                _posts.isNotEmpty
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: TextButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        AppColors.mainColor),
                                    shadowColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                    foregroundColor: MaterialStateProperty.all(
                                        Colors.black)),
                                onPressed: () {
                                  Get.to(
                                      () => MoreDetailOnReport(posts: _posts));
                                },
                                child: const Text('More Information')),
                          )
                        ],
                      )
                    : Container(),
              ],
            ),
          );
  }
}

class _ReportsData {
  _ReportsData(this.month, this.reports);

  final String month;
  final int reports;
}
