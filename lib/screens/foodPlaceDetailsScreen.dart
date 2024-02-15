import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:misproject/models/foodPlace.dart';
import 'package:misproject/screens/foodDetailsScreen.dart';
import 'package:misproject/screens/mainScreen.dart';
import 'package:misproject/screens/mapScreen.dart';
import 'package:misproject/services/LocationPermissions.dart';

class FoodPlaceDetailsScreen extends StatefulWidget {
  final FoodPlace foodPlace;

  const FoodPlaceDetailsScreen({super.key, required this.foodPlace});

  @override
  State<FoodPlaceDetailsScreen> createState() => _FoodPlaceDetailsScreenState();
}

class _FoodPlaceDetailsScreenState extends State<FoodPlaceDetailsScreen> {
  Position? _userLocation;

  @override
  void initState() {
    super.initState();

  }

  Future<void> _calculateDistance() async {
    try {
      await LocationPermissions.instance.getPermissions();
      _userLocation = await LocationPermissions.instance.getCurrentLocation();

      setState(() {

      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    if(_userLocation == null) {
      _calculateDistance();
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => const MainScreen())),
        ),
        title: Text(widget.foodPlace.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.foodPlace.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text(widget.foodPlace.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Text('Address: ${widget.foodPlace.address}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 2),
            _userLocation != null ? Text("Distance to ${widget.foodPlace.name}: ${Geolocator.distanceBetween(
              widget.foodPlace.location.latitude,
              widget.foodPlace.location.longitude,
              _userLocation!.latitude,
              _userLocation!.longitude,
            ).toStringAsFixed(2)} m", style: const TextStyle(fontSize: 15)) : const Icon(Icons.location_off_outlined),
            const SizedBox(height: 2),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MapScreen(foodPlaces: [widget.foodPlace])));
              },
              child: const Text('Show on Map'),
            ),
            const SizedBox(height: 16),
            const Text('Menu items: ', style: TextStyle(fontSize: 17)),
            Expanded(
              child: ListView.builder(
                itemCount: widget.foodPlace.menu.length,
                itemBuilder: (context, index){
                  final item = widget.foodPlace.menu[index];
                  return GestureDetector(
                    onTap: () {
                      Future.delayed(const Duration(milliseconds: 800), ()
                      {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    FoodDetailsScreen(foodItem: item)
                            )
                        );
                      });
                    },
                    child: Card(
                      child: ListTile(
                        title: Text(item.name),
                        subtitle: Text('\$${item.price}'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
