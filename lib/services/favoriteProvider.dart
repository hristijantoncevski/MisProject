import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:misproject/models/foodItem.dart';
import 'package:provider/provider.dart';

class FavoriteProvider extends ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  late CollectionReference _usersCollection;

  List<FoodItem> _favoriteItems = [];

  List<FoodItem> get favoriteItems => _favoriteItems;

  FavoriteProvider(){
    _usersCollection = _firebaseFirestore.collection('users');
  }

  Future<void> loadFavoriteItems() async {
    try {
      var snapshot = await _usersCollection.doc(userId).collection('favorites').get();
      _favoriteItems = snapshot.docs.map((doc) => FoodItem.fromFirestore(doc)).toList();

      notifyListeners();
    } catch (error) {
      print('Error loading favorite items: $error');
    }
  }

  bool checkIfFavorited(FoodItem foodItem) {
    int itemId = _favoriteItems.indexWhere((item) => item.id == foodItem.id);

    if(itemId != -1) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> addToFavorites(FoodItem foodItem) async {
    try {
      if (!_favoriteItems.any((item) => item.id == foodItem.id)) {
        await _usersCollection.doc(userId).collection('favorites').doc(foodItem.id).set({
          'id': foodItem.id,
          'name': foodItem.name,
          'price': foodItem.price,
        });
        _favoriteItems.add(FoodItem(id: foodItem.id, name: foodItem.name, price: foodItem.price));
        notifyListeners();
      }
    } catch (error) {
      print('Error adding to favorites: $error');
    }
  }

  Future<void> removeFromFavorites(FoodItem foodItem) async {
    try {
      await _usersCollection.doc(userId).collection('favorites').doc(foodItem.id).delete();
      _favoriteItems.removeWhere((item) => item.id == foodItem.id);
      notifyListeners();
    } catch (error) {
      print('Error removing to favorites: $error');
    }
  }
}