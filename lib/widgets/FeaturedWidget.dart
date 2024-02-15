import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:misproject/screens/foodPlaceDetailsScreen.dart';
import 'package:misproject/services/LocationPermissions.dart';
import 'package:misproject/services/featuredProvider.dart';
import 'package:provider/provider.dart';

class Featured extends StatefulWidget {
  const Featured({super.key});

  @override
  State<Featured> createState() => _FeaturedState();
}

class _FeaturedState extends State<Featured> {
  @override
  void initState() {
    super.initState();

    Provider.of<FeaturedProvider>(context, listen: false).loadFeaturedItems();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FeaturedProvider>(
      builder: (context, featuredProvider, child) {
        return SizedBox(
          height: 220,
          width: double.infinity,
          child: Column(
            children: <Widget>[
              title(),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: featuredProvider.featuredItems.length,
                  itemBuilder: (context, index){
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FoodPlaceDetailsScreen(foodPlace: featuredProvider.featuredItems[index]))
                        );
                      },
                      child: SizedBox(
                        width: 180,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(featuredProvider.featuredItems[index].name, style: const TextStyle(fontSize: 16)),
                                const SizedBox(height: 2),
                                Text(featuredProvider.featuredItems[index].address, style: const TextStyle(fontSize: 15)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget title() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        "Featured",
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }
}
