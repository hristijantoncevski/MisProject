import 'package:flutter/material.dart';
import 'package:misproject/screens/foodDetailsScreen.dart';
import 'package:misproject/services/favoriteProvider.dart';
import 'package:provider/provider.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  void initState() {
    super.initState();
    Provider.of<FavoriteProvider>(context, listen: false).loadFavoriteItems();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteProvider>(
      builder: (context, favoriteProvider, child) {
        return SizedBox(
          height: 200,
          width: double.infinity,
          child: Column(
            children: <Widget>[
              title(),
              favoriteProvider.favoriteItems.isEmpty ?
              const Expanded(child: SizedBox(child: Card(child: Center(child: Text('You have no favorites', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red))))))
                  :
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: favoriteProvider.favoriteItems.length,
                  itemBuilder: (context, index){
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FoodDetailsScreen(foodItem: favoriteProvider.favoriteItems[index]))
                        ).then((_) {
                          setState(() {
                            favoriteProvider.loadFavoriteItems();
                          });
                        });
                      },
                      child: SizedBox(
                        width: 220,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(favoriteProvider.favoriteItems[index].name),
                                Text('\$${favoriteProvider.favoriteItems[index].price.toStringAsFixed(2)}'),
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
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(height: 10),
          Text("Favorites", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
