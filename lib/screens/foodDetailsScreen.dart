import 'package:flutter/material.dart';
import 'package:misproject/models/foodItem.dart';
import 'package:misproject/services/favoriteProvider.dart';
import 'package:misproject/services/shoppingCartProvider.dart';
import 'package:provider/provider.dart';

class FoodDetailsScreen extends StatefulWidget {
  final FoodItem foodItem;

  const FoodDetailsScreen({super.key, required this.foodItem});

  @override
  State<FoodDetailsScreen> createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
  FavoriteProvider favoriteProvider = FavoriteProvider();
  late bool isFavorited;

  @override
  void initState() {
    super.initState();
    Provider.of<FavoriteProvider>(context, listen: false).loadFavoriteItems();
    isFavorited = Provider.of<FavoriteProvider>(context, listen: false).checkIfFavorited(widget.foodItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.foodItem.name),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 40),
            onPressed: () async {
              setState(() {
                if (isFavorited) {
                  favoriteProvider.removeFromFavorites(widget.foodItem);
                } else {
                  favoriteProvider.addToFavorites(widget.foodItem);
                }
                isFavorited = !isFavorited;
              });
            },
            color: isFavorited ? Colors.red : Colors.white,
            icon: Icon(isFavorited ? Icons.favorite : Icons.favorite_border,size: 40),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.foodItem.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('$isFavorited'),
            const SizedBox(height: 16),
            Text(
              'Price: \$${widget.foodItem.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton.icon(
                onPressed: () {
                  Provider.of<ShoppingCartProvider>(context, listen: false).addToCart(widget.foodItem,1);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Added to cart! ✔'),
                      duration: const Duration(milliseconds: 2000),
                      width: 280.0,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    )
                  );
                },
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text(
                  'Add to Cart',
                  style: TextStyle(fontSize: 18),
                ),
                style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.green)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

