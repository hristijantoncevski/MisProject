import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:misproject/models/foodItem.dart';

class ShoppingCartItem {
  final String id;
  final FoodItem foodItem;
  int quantity;

  ShoppingCartItem({required this.id, required this.foodItem, required this.quantity});

  factory ShoppingCartItem.fromFirestore(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    return ShoppingCartItem(
      foodItem: FoodItem(
        id: doc['foodItemId'],
        name: doc['name'],
        price: doc['price'],
      ),
      id: doc.id,
      quantity: doc['quantity'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'foodItemId': foodItem.id,
      'name': foodItem.name,
      'price': foodItem.price,
      'quantity': quantity,
      'id': foodItem.id,
    };
  }

  factory ShoppingCartItem.fromMap(Map<String, dynamic> map) {
    return ShoppingCartItem(
      foodItem: FoodItem(
        id: map['foodItemId'],
        name: map['name'],
        price: map['price'],
      ),
      id: map['id'],
      quantity: map['quantity'],
    );
  }
}