import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_gsg/provider/bottom_nav_provider.dart';
import 'package:recipe_gsg/services/shared_prefs.dart';
import 'package:recipe_gsg/screens/favorites_screen.dart';
import 'package:recipe_gsg/screens/home_content_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Widget> _pages = const [HomeContentScreen(), FavoritesScreen()];

  @override
  Widget build(BuildContext context) {
    final bottomNav = Provider.of<BottomNavProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(bottomNav.selectedIndex == 0 ? 'Home' : 'Favorites'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await SharedPrefs.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: _pages[bottomNav.selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        
        currentIndex: bottomNav.selectedIndex,
        onTap: (index) => bottomNav.setIndex(index),
        selectedItemColor: Colors.orange,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
