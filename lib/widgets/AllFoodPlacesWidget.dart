import 'package:flutter/material.dart';
import 'package:misproject/screens/allFoodPlacesScreen.dart';
import 'package:misproject/screens/foodPlaceDetailsScreen.dart';
import 'package:misproject/services/foodPlaceProvider.dart';
import 'package:provider/provider.dart';

class AllFoodPlaces extends StatefulWidget {
  const AllFoodPlaces({super.key});

  @override
  State<AllFoodPlaces> createState() => _AllFoodPlacesState();
}

class _AllFoodPlacesState extends State<AllFoodPlaces> {
  @override
  void initState() {
    super.initState();
    Provider.of<FoodPlaceProvider>(context, listen: false).loadFoodPlaces();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FoodPlaceProvider>(
      builder: (context, foodPlaceProvider, child){
        return SizedBox(
          height: 180,
          width: double.infinity,
          child: Column(
            children: <Widget>[
              title(foodPlaceProvider),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  itemBuilder: (context, index){
                    if(foodPlaceProvider.foodPlaces.isEmpty) { return const CircularProgressIndicator();} else {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      FoodPlaceDetailsScreen(
                                          foodPlace: foodPlaceProvider
                                              .foodPlaces[index]))
                          );
                        },
                        child: SizedBox(
                          width: 180,
                          child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(foodPlaceProvider.foodPlaces[index].name,
                                    style: const TextStyle(fontSize: 16)),
                                const SizedBox(height: 4),
                                Text(foodPlaceProvider.foodPlaces[index].address,
                                    style: const TextStyle(fontSize: 15)),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget title(FoodPlaceProvider foodPlaceProvider) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Text("Food Places", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          TextButton(
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AllFoodPlacesScreen(foodPlaces: foodPlaceProvider.foodPlaces))
              );
            },
            child: const Text('See more', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
