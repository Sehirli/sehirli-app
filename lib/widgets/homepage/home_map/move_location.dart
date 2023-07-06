import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MoveLocation extends StatelessWidget {
  final LatLng location;
  final MapController mapController;

  const MoveLocation({
    super.key,
    required this.location,
    required this.mapController
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: FloatingActionButton(
        heroTag: "go_to_current_location",
        backgroundColor: Colors.black,
        child: const Icon(Icons.my_location, color: Colors.white),
        onPressed: () => mapController.move(location, 14),
      ),
    );
  }
}
