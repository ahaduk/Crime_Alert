import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as lat_long;

class Stats extends StatelessWidget {
  const Stats({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        // onLongPress: (tapPosition, point) => print(point),
        center: lat_long.LatLng(9.001208, 38.807312),
        zoom: 16.0,
      ),
      layers: [
        TileLayerOptions(
          urlTemplate:
              "https://api.mapbox.com/styles/v1/ahadukasahun/cl3ipqa3z001r15ldmj3nwtuy/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYWhhZHVrYXNhaHVuIiwiYSI6ImNsM2lwaWMzazAwaDczZHFyaXF3MWVnNGgifQ.phK5ZIhhc_Br5oW3nIETMg",
          additionalOptions: {
            'accessToken':
                'pk.eyJ1IjoiYWhhZHVrYXNhaHVuIiwiYSI6ImNsM2lwaWMzazAwaDczZHFyaXF3MWVnNGgifQ.phK5ZIhhc_Br5oW3nIETMg',
            'id': 'mapbox.mapbox-streets-v8'
          },
        ),
        //Commented for markers
        // MarkerLayerOptions(
        //   markers: [
        //     Marker(
        //       width: 80.0,
        //       height: 80.0,
        //       point: lat_long.LatLng(51.5, -0.09),
        //       builder: (ctx) => Container(
        //         child: const FlutterLogo(),
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}
