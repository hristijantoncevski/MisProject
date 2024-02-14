import 'package:geolocator/geolocator.dart';

class LocationPermissions {
  LocationPermissions();

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