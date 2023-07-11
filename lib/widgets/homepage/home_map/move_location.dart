import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';

class MoveLocation extends StatelessWidget {
  final LatLng location;
  final MapController mapController;
  final bool isDefault;

  const MoveLocation({
    super.key,
    required this.location,
    required this.mapController,
    required this.isDefault
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: FloatingActionButton(
        heroTag: "go_to_current_location",
        backgroundColor: Colors.black,
        child: const Icon(Icons.my_location, color: Colors.white),
        onPressed: () {
          if (!isDefault) {
            mapController.move(location, 14);
          } else {
            Get.snackbar(
              "Hata!",
              "Lütfen konum servislerini etkinleştirin!",
              colorText: Colors.white,
              icon: const Icon(Icons.warning_amber, color: Colors.red),
              shouldIconPulse: false
            );
          }
        },
      ),
    );
  }
}
