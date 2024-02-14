import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:misproject/models/foodItem.dart';
import 'package:misproject/models/shoppingCart.dart';
import 'package:provider/provider.dart';

class ShoppingCartProvider extends ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  late CollectionReference _usersCollection;

  List<ShoppingCartItem> _cartItems = [];

  List<ShoppingCartItem> get cartItems => _cartItems;

  ShoppingCartProvider() {
    _usersCollection = _firebaseFirestore.collection('users');
  }

  double get totalPrice {
    return _cartItems.fold(0, (total, item) => total + (item.foodItem.price * item.quantity));
  }

  Future<void> loadCartItems() async {
    try{
      var snapshot = await _usersCollection.doc(userId).collection('cartItems').get();
      _cartItems = snapshot.docs.map((doc) => ShoppingCartItem.fromFirestore(doc)).toList();

      notifyListeners();
      } catch (error){
      print('Error loading cart items: $error');
    }
  }

  Future<void> addToCart(FoodItem foodItem, int quantity) async {
    try{
      int index = _cartItems.indexWhere((item) => item.foodItem.id == foodItem.id);

      if(index != -1){
        int newQuantity = _cartItems[index].quantity + 1;
        _cartItems[index].quantity = newQuantity;

        await _usersCollection.doc(userId).collection('cartItems').doc(foodItem.id).update({'quantity': newQuantity});
      } else {
        //String docId = _usersCollection.doc().id;
        await _usersCollection.doc(userId).collection('cartItems').doc(foodItem.id).set({
          'foodItemId': foodItem.id,
          'name': foodItem.name,
          'price': foodItem.price,
          'quantity': quantity,
        });
        _cartItems.add(ShoppingCartItem(id: foodItem.id, foodItem: foodItem, quantity: quantity));
      }
      notifyListeners();
    } catch (error) {
      print('Error adding to cart: $error');
    }
  }

  Future<void> removeFromCart(String itemId) async {
    try {
      await _usersCollection.doc(userId).collection('cartItems').doc(itemId).delete();
      _cartItems.removeWhere((item) => item.id == itemId);
      notifyListeners();
    } catch (error) {
      print('Error removing to cart: $error');
    }
  }

  Future<void> updateQuantity(ShoppingCartItem shoppingCartItem, int newQuantity) async {
    try {
      int index = _cartItems.indexWhere((item) => item.foodItem.id == shoppingCartItem.foodItem.id);
      _cartItems[index].quantity = newQuantity;
      await _usersCollection.doc(userId).collection('cartItems').doc(shoppingCartItem.foodItem.id).update({'quantity': newQuantity});

      notifyListeners();
    } catch (error) {
      print("Error updating quantity: $error");
    }
  }

  Future<void> clearCart() async {
    try {
      _cartItems.clear();
      await _usersCollection.doc(userId).collection('cartItems').get().then((snapshot){
        for(DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });
      notifyListeners();
    } catch (error) {
      print('Error clearing items: $error');
    }
  }
}