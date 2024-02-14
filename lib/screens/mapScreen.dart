import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:misproject/models/foodPlace.dart';
import 'package:misproject/services/LocationPermissions.dart';

class MapScreen extends StatefulWidget {
  final List<FoodPlace> foodPlaces;

  const MapScreen({super.key, required this.foodPlaces});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Marker> markers = [];
  int markerIndex = 0;
  List<Marker> homeMarkers = [];
  Marker? currentLocation;
  MapController mapController = MapController();

  @override
  void initState() {
    super.initState();
    addMarkers();
  }

  void showNextMarkerLocation() {
    if(markers.isNotEmpty) {
      markerIndex = (markerIndex + 1) % markers.length;
      LatLng latlng = markers[markerIndex].point;
      mapController.move(latlng, 17);
    }
  }

  Future<Position> getCurrentLocation() async {
    await LocationPermissions().getPermissions();

    return LocationPermissions().getCurrentLocation();
  }

  void addMarkers() async {

    setState(() {
      markers = markers;
    });

    for(FoodPlace foodPlace in widget.foodPlaces) {
      markers.add(
        Marker(
          width: 80,
          height: 80,
          point: LatLng(foodPlace.location.latitude, foodPlace.location.longitude),
          child: GestureDetector(
            onTap: () async {
              return showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(foodPlace.name),
                    content: Text(foodPlace.address),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  );
                }
              );
            },
            child: const Icon(Icons.location_on, color: Colors.red, size: 50),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: LatLng(widget.foodPlaces.first.location.latitude, widget.foodPlaces.first.location.longitude),
          initialZoom: 17,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          MarkerLayer(markers: markers),
          MarkerLayer(markers: homeMarkers),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'nextButton',
            onPressed: showNextMarkerLocation,
            child: const Icon(Icons.navigate_next, color: Colors.white),
          ),
          const SizedBox(height: 20),
          FloatingActionButton(
            heroTag: 'homeButton',
            onPressed: () async {
              getCurrentLocation().then((value) async {
                LatLng center = LatLng(value.latitude, value.longitude);
                mapController.move(center, 16);

                setState(() {
                  homeMarkers.add(
                    Marker(
                      width: 80,
                      height: 80,
                      point: center,
                      child: const Icon(Icons.home_filled, color: Colors.green, size: 50),
                    ),
                  );
                });
              });
            },
            child: const Icon(Icons.home_filled, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
