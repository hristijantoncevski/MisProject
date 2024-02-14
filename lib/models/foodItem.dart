import 'package:cloud_firestore/cloud_firestore.dart';

class FoodItem {
  final String id;
  final String name;
  final double price;

  FoodItem({required this.id, required this.name, required this.price});

  factory FoodItem.fromFirestore(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    return FoodItem(
      id: doc.id,
      name: doc['name'],
      price: doc['price'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }

  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      id: map['id'],
      name: map['name'],
      price: map['price'],
    );
  }
}