import 'package:geolocator/geolocator.dart';

class Location {
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Lütfen konum servislerini açın!");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Lütfen uygulamaya konum izni verin!");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        "Konum bilgileri tamamen reddedildi. Lütfen konum izinlerini değiştirin."
      );
    }

    return await Geolocator.getCurrentPosition();
  }
}