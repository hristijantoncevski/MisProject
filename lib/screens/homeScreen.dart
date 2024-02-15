import 'package:flutter/material.dart';
import 'package:misproject/widgets/AllFoodPlacesWidget.dart';
import 'package:misproject/widgets/FavoritesWidget.dart';
import 'package:misproject/widgets/FeaturedWidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 740,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 25, left: 5, right: 5),
      child: Column(
        children: <Widget>[
          Image.asset("assets/images/logo/logoFoodly.png", height: 115, width: 115),
          const Featured(),
          const Favorites(),
          const AllFoodPlaces(),
        ],
      ),
    );
  }
}
