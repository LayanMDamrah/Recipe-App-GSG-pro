import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_gsg/models/recipy.dart';
import 'package:recipe_gsg/provider/bottom_nav_provider.dart';
import 'package:recipe_gsg/screens/add_recipy_screen.dart';
import 'package:recipe_gsg/screens/favorites_screen.dart';
import 'package:recipe_gsg/screens/home_content_screen.dart';
import 'package:recipe_gsg/services/api_service.dart';
import 'package:recipe_gsg/services/shared_prefs.dart';
import 'package:recipe_gsg/utils/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Recipe> recipes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    final fetchedRecipes = await ApiService.getRecipes();
    setState(() {
      recipes = fetchedRecipes;
      isLoading = false;
    });
  }

  void _openAddRecipePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
         
          body: AddRecipeScreen(
            onSave: fetchRecipes,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomNav = Provider.of<BottomNavProvider>(context);

    final pages = [
      HomeContentScreen(recipes: recipes),
      const FavoritesScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          bottomNav.selectedIndex == 0
              ? 'Home'
              : bottomNav.selectedIndex == 1
                  ? 'Favorites'
                  : 'Add Recipe',
        ),
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pages[bottomNav.selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: bottomNav.selectedIndex,
        onTap: (index) {
          if (index == 2) {
            _openAddRecipePage();
          } else {
            bottomNav.setIndex(index);
          }
        },
        selectedItemColor: AppColors.primary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
        ],
      ),
    );
  }
}
