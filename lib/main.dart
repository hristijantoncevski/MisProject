import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:misproject/firebase_options.dart';
import 'package:misproject/screens/mainScreen.dart';
import 'package:misproject/screens/login_screen.dart';
import 'package:misproject/services/authProvider.dart';
import 'package:misproject/services/favoriteProvider.dart';
import 'package:misproject/services/featuredProvider.dart';
import 'package:misproject/services/foodPlaceProvider.dart';
import 'package:misproject/services/navigationProvider.dart';
import 'package:misproject/services/orderProvider.dart';
import 'package:misproject/services/shoppingCartProvider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (context) => NavigationProvider()),
        ChangeNotifierProvider(create: (context) => FavoriteProvider()),
        ChangeNotifierProvider(create: (context) => FeaturedProvider()),
        ChangeNotifierProvider(create: (context) => FoodPlaceProvider()),
        ChangeNotifierProvider(create: (context) => ShoppingCartProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
      ],
      child: const MaterialApp(
        title: '192041',
        home: Auth(),
      ),
    );
  }
}

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);
    if(authProvider.status == AuthStatus.authenticated){
      return const MainScreen();
    } else {
      return Login();
    }
  }

}
