import 'package:flutter/material.dart';
import 'package:misproject/screens/accountScreen.dart';
import 'package:misproject/screens/cartScreen.dart';
import 'package:misproject/screens/homeScreen.dart';
import 'package:misproject/services/navigationProvider.dart';
import 'package:misproject/widgets/BottomNavigationBar.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  Widget build(BuildContext context) {
    final currentIndex = Provider.of<NavigationProvider>(context).currentIndex;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if (currentIndex == 0)
              const HomeScreen()
            else if (currentIndex == 1)
              const CartScreen()
            else
              const AccountScreen()
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarNewWidget(currentPageIndex: currentIndex),
    );
  }
}

