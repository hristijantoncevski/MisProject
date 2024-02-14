import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

enum AuthStatus { authenticated, unauthenticated, loading }

class AuthenticationProvider extends ChangeNotifier {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthStatus _status = AuthStatus.loading;

  AuthenticationProvider(){
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
      notifyListeners();
    });
  }

  AuthStatus get status => _status;

  User? get user => _auth.currentUser;

  Future<void> signOut() async {
    await _auth.signOut();
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    try {
      _status = AuthStatus.loading;
      notifyListeners();

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _status = AuthStatus.authenticated;
      notifyListeners();
    } catch (e) {
      print("Error signing in: $e");
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      _status = AuthStatus.loading;
      notifyListeners();

      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _status = AuthStatus.authenticated;
      notifyListeners();
    } catch (e) {
      print("Error signing up: $e");
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    }
  }
}