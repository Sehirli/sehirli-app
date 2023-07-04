import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:sehirli/widgets/homepage/home_map/osm_copyright.dart';

class EventPageMap extends StatelessWidget {
  final LatLng point;

  EventPageMap({super.key, required this.point});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 300,
      child: FlutterMap(
        options: MapOptions(
          center: point
        ),
        nonRotatedChildren: const [
          OsmCopyright()
        ],
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: point,
                builder: (BuildContext context) {
                  return const Icon(
                    Icons.location_pin,
                    color: Colors.black,
                    size: 40
                  );
                }
              )
            ],
          )
        ],
      ),
    );
  }
}
