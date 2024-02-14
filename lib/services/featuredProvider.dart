
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:misproject/models/foodItem.dart';
import 'package:misproject/models/foodPlace.dart';

class FeaturedProvider extends ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  late CollectionReference _featuredCollection;

  List<FoodPlace> _featuredItems = [];

  List<FoodPlace> get featuredItems => _featuredItems;

  FeaturedProvider(){
    _featuredCollection = _firebaseFirestore.collection('foodPlaces');
  }

  Future<void> loadFeaturedItems() async {
    try {
      var snapshot = await _firebaseFirestore.collection('foodPlaces').where('isFeatured', isEqualTo: true).get();
      _featuredItems = snapshot.docs.map((doc) => FoodPlace.fromFirestore(doc)).toList();

      notifyListeners();
    } catch (error) {
      print('Error loading featured places: $error');
    }
  }
}