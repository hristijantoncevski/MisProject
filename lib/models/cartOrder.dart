import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:misproject/models/shoppingCart.dart';

class CartOrder {
  final String id;
  final List<ShoppingCartItem> items;
  final double totalPrice;
  final DateTime timestamp;

  CartOrder({required this.id, required this.items, required this.totalPrice, required this.timestamp});

  factory CartOrder.fromFirestore(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    List<dynamic> itemsData = doc['items'];
    List<ShoppingCartItem> cartItems = itemsData.map((item) => ShoppingCartItem.fromMap(item)).toList();

    return CartOrder(
      id: doc.id,
      totalPrice: doc['totalPrice'],
      timestamp: (doc['timestamp'] as Timestamp).toDate(),
      items: cartItems,
    );
  }
}