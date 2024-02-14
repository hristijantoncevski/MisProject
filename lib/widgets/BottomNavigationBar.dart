import 'package:flutter/material.dart';
import 'package:misproject/services/navigationProvider.dart';
import 'package:provider/provider.dart';

class BottomNavigationBarNewWidget extends StatelessWidget {
  final int currentPageIndex;

  const BottomNavigationBarNewWidget({super.key, required this.currentPageIndex});

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    return NavigationBar(
      onDestinationSelected: (int index) {
        navigationProvider.currentIndex = index;
      },
      indicatorColor: Colors.orangeAccent,
      selectedIndex: navigationProvider.currentIndex,
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      destinations: const <Widget> [
        NavigationDestination(
          selectedIcon: Icon(Icons.home),
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.shopping_cart),
          icon: Icon(Icons.shopping_cart_outlined),
          label: 'Cart',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.account_box),
          icon: Icon(Icons.account_box_outlined),
          label: 'Account',
        ),
      ],
    );
  }

}
