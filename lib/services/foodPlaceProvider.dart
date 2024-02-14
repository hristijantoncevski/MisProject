import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:misproject/models/foodPlace.dart';
import 'package:provider/provider.dart';

class FoodPlaceProvider extends ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  late CollectionReference _allFoodPlacesCollection;

  List<FoodPlace> _foodPlaces = [];

  List<FoodPlace> get foodPlaces => _foodPlaces;

  FoodPlaceProvider() {
    _allFoodPlacesCollection = _firebaseFirestore.collection('foodPlaces');
  }

  Future<void> loadFoodPlaces() async {
    try {
      var snapshot = await _firebaseFirestore.collection('foodPlaces').get();
      _foodPlaces = snapshot.docs.map((doc) => FoodPlace.fromFirestore(doc)).toList();

      notifyListeners();
    } catch (error) {
      print('Error loading food places: $error');
    }
  }

  Future<void> addFoodPlace(FoodPlace foodPlace) async {
    try {
      if(!_foodPlaces.any((item) => item.id == foodPlace.id)) {
        List<Map<String, dynamic>> menuList = foodPlace.menu.map((item) => item.toMap()).toList();
        await _allFoodPlacesCollection.doc(foodPlace.id).set({
          'id': foodPlace.id,
          'name': foodPlace.name,
          'description': foodPlace.description,
          'address': foodPlace.address,
          'isFeatured': foodPlace.isFeatured,
          'latitude': foodPlace.location.latitude,
          'longitude': foodPlace.location.longitude,
          'menu': menuList,
        });
      }
    } catch (error) {
      print('Error adding a food place: $error');
    }
  }

}