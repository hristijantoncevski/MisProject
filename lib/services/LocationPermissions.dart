import 'package:geolocator/geolocator.dart';

class LocationPermissions {
  static final LocationPermissions instance = LocationPermissions.internal();

  factory LocationPermissions() {
    return instance;
  }

  LocationPermissions.internal();

  Future<void> getPermissions() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if(permission == LocationPermission.denied) {
      print('Denied');
    } else if(permission == LocationPermission.deniedForever) {
      print('Denied forever');
    } else {
      print('Allowed');
    }
  }

  Future<Position> getCurrentLocation() async {
    return await Geolocator.getCurrentPosition();
  }
}