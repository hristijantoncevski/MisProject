import 'package:flutter/material.dart';
import 'package:misproject/models/foodPlace.dart';
import 'package:misproject/screens/foodPlaceDetailsScreen.dart';
import 'package:misproject/screens/mapScreen.dart';

class AllFoodPlacesScreen extends StatefulWidget {
  List<FoodPlace> foodPlaces;

  AllFoodPlacesScreen({super.key, required this.foodPlaces});

  @override
  State<AllFoodPlacesScreen> createState() => _AllFoodPlacesScreenState();
}

class _AllFoodPlacesScreenState extends State<AllFoodPlacesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Food Places'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MapScreen(foodPlaces: widget.foodPlaces)));
            },
            icon: const Icon(Icons.map),
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: widget.foodPlaces.length,
        itemBuilder: (context, index){
          return GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FoodPlaceDetailsScreen(foodPlace: widget.foodPlaces[index]))
              );
            },
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(widget.foodPlaces[index].name, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(widget.foodPlaces[index].address, style: const TextStyle(fontSize: 15)),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
