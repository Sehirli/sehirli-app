import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:sehirli/utils/location.dart';
import 'package:sehirli/widgets/error_map.dart';

import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

class LocationSelector extends StatelessWidget {
  final Function(PickedData pickedData) onPicked;

  LocationSelector({super.key, required this.onPicked});

  final Location location = Location();
  final OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: const BorderSide(
        color: Colors.black
    )
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Konum Seç"),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder(
        future: location.determinePosition(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CupertinoActivityIndicator(color: Colors.white));
          }

          var data = snapshot.data;

          if (data == null) {
            return const ErrorMap();
          }

          return FlutterLocationPicker(
            selectLocationButtonText: "Tamam",
            selectLocationButtonStyle: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.black)
            ),
            searchbarBorderRadius: BorderRadius.circular(20),
            searchbarInputBorder: outlineInputBorder,
            showZoomController: false,
            searchbarInputFocusBorder: outlineInputBorder,
            showContributorBadgeForOSM: true,
            contributorBadgeForOSMPositionRight: MediaQuery.of(context).size.width / 2,
            searchBarHintText: "Bir konum aratın",
            initZoom: 11,
            locationButtonsColor: Colors.white,
            locationButtonBackgroundColor: Colors.black,
            zoomButtonsBackgroundColor: Colors.black,
            zoomButtonsColor: Colors.white,
            minZoomLevel: 5,
            maxZoomLevel: 16,
            mapLanguage: "tr",
            initPosition: LatLong(data.latitude, data.longitude),
            showCurrentLocationPointer: false,
            onPicked: onPicked,
            contributorBadgeForOSMColor: Colors.black,
            contributorBadgeForOSMTextColor: Colors.white,
          );
        }
      )
    );
  }
}

