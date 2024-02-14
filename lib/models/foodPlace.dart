import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:misproject/models/foodItem.dart';
import 'package:misproject/models/location.dart';

class FoodPlace {
  final String id;
  final String name;
  final String description;
  final String address;
  final bool isFeatured;
  final Location location;
  final List<FoodItem> menu;

  FoodPlace({required this.id, required this.name, required this.description, required this.address, required this.isFeatured, required this.location, required this.menu});

  factory FoodPlace.fromFirestore(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    List<dynamic> menuData = doc['menu'];
    List<FoodItem> menuItems = menuData.map((item) => FoodItem.fromMap(item)).toList();

    return FoodPlace(
      id: doc.id,
      name: doc['name'],
      description: doc['description'],
      address: doc['address'],
      isFeatured: doc['isFeatured'],
      location: Location(
        latitude: doc['latitude'],
        longitude: doc['longitude'],
      ),
      menu: menuItems,
    );
  }
}