import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:misproject/models/cartOrder.dart';
import 'package:misproject/models/shoppingCart.dart';

class OrderProvider extends ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  late CollectionReference _usersCollection;

  List<CartOrder> _orders = [];

  List<CartOrder> get orders => _orders;

  OrderProvider() {
    _usersCollection =  _firebaseFirestore.collection('users');
  }

  Future<void> loadOrders() async {
   try {
     var snapshot = await _usersCollection.doc(userId).collection('orders').get();
     _orders = snapshot.docs.map((doc) => CartOrder.fromFirestore(doc)).toList();

     notifyListeners();
   } catch (error) {
     print('Error loading orders: $error');
   }
  }

  Future<void> addOrder(CartOrder cartOrder) async {
    try {
      List<Map<String, dynamic>> items = cartOrder.items.map((item) => item.toFirestore()).toList();
      await _usersCollection.doc(userId).collection('orders').doc(cartOrder.id).set({
        'id': cartOrder.id,
        'totalPrice': cartOrder.totalPrice,
        'timestamp': cartOrder.timestamp,
        'items': items,
      });
      _orders.add(CartOrder(id: cartOrder.id, totalPrice: cartOrder.totalPrice, timestamp: cartOrder.timestamp, items: cartOrder.items));
      notifyListeners();
    } catch (error) {
      print('Error adding to orders: $error');
    }
  }
}