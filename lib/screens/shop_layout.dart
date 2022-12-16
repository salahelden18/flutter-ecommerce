import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app_api_course_abdallah_mansour_design/screens/cart_screen.dart';
import '../providers/shop_layout_provider.dart';
import './search_screen.dart';

class ShopLayout extends StatelessWidget {
  const ShopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ShopLayoutProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Salla',
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(SearchScreen.routeName);
            },
            icon: const Icon(
              Icons.search,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
            icon: const Icon(
              Icons.shopping_cart_outlined,
            ),
          ),
        ],
      ),
      body: provider.bottomScreens[provider.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: provider.changeBottom,
        currentIndex: provider.currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.apps,
            ),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
            ),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
            ),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
