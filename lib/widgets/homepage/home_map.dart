import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sehirli/models/event.dart';
import 'package:sehirli/models/event_type.dart';
import 'package:sehirli/pages/home_pages/event_page.dart';
import 'package:sehirli/utils/database.dart';
import 'package:sehirli/utils/location.dart';
import 'package:sehirli/widgets/homepage/home_map/move_location.dart';
import 'package:sehirli/widgets/homepage/home_map/osm_copyright.dart';
import 'package:sehirli/widgets/homepage/home_map/refresh_map.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class HomeMap extends StatefulWidget {
  const HomeMap({super.key});

  @override
  State<HomeMap> createState() => _HomeMapState();
}

class _HomeMapState extends State<HomeMap> {
  final Location location = Location();
  final Database database = Database();
  final MapController controller = MapController();

  late LatLng currentLocation;
  late double zoom;
  late bool isDefault;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        location.determinePosition(),
        database.getAll(7)
      ]),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CupertinoActivityIndicator(color: Colors.white));
        }

        var locationData = snapshot.data[0];
        if (locationData == null) {
          currentLocation = const LatLng(39.221536, 34.614446);
          zoom = 5;
          isDefault = true;
        } else {
          currentLocation = LatLng(locationData.latitude, locationData.longitude);
          zoom = 10;
          isDefault = false;
        }

        List<Marker> markers = [
          Marker(
            point: currentLocation,
            builder: (BuildContext context) {
              return isDefault
                  ? const SizedBox()
                  : const Icon(FontAwesomeIcons.locationCrosshairs, size: 30, color: Colors.black);
            }
          ),
        ];

        List<Event> eventsData = snapshot.data[1];

        for (Event item in eventsData) {
          markers.add(Marker(
            width: 40,
            height: 40,
            point: LatLng(
              item.geoPoint.latitude,
              item.geoPoint.longitude
            ),
            builder: (BuildContext context) {
              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Get.to(() => EventPage(event: item));
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(99)
                  ),
                  child: buildMarkerIcon(item),
                ),
              );
            }
          ));
        }

        return FlutterMap(
          mapController: controller,
          options: MapOptions(
            center: currentLocation,
            zoom: zoom
          ),
          nonRotatedChildren: [
            SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RefreshMap(onPressed: () {
                    setState(() {});
                  }),
                  SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: MoveLocation(
                        location: currentLocation,
                        mapController: controller,
                        isDefault: isDefault
                      )
                    ),
                  )
                  // const FilterButton()
                ],
              ),
            ),
            const SafeArea(
              child: OsmCopyright(),
            )
          ],
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: const ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers: markers
            )
          ],
        );
      },
    );
  }

  Icon buildMarkerIcon(Event event) {
    EventType eventType = EventType.values.byName(event.eventType);

    switch (eventType) {
      case EventType.crash:
        return const Icon(FontAwesomeIcons.carBurst, color: Colors.white, size: 18);
      case EventType.explosion:
        return const Icon(FontAwesomeIcons.explosion, color: Colors.white, size: 18);
      case EventType.fire:
        return const Icon(FontAwesomeIcons.fire, color: Colors.white, size: 18);
      case EventType.murder:
        return const Icon(Icons.person, color: Colors.white, size: 18);
      case EventType.shooting:
        return const Icon(FontAwesomeIcons.gun, color: Colors.white, size: 18);
      case EventType.other:
        return const Icon(Icons.warning, color: Colors.white, size: 18);
    }
  }
}