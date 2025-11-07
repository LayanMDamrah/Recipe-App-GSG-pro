import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:recipe_gsg/cubit/recipe_cubit.dart';
import 'package:recipe_gsg/provider/bottom_nav_provider.dart';
import 'package:recipe_gsg/screens/add_recipy_screen.dart';
import 'package:recipe_gsg/screens/favorites_screen.dart';
import 'package:recipe_gsg/screens/home_content_screen.dart';
import 'package:recipe_gsg/services/shared_prefs.dart';
import 'package:recipe_gsg/utils/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openAddRecipePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          body: AddRecipeScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomNav = Provider.of<BottomNavProvider>(context);

    return BlocProvider(
      create: (_) => RecipeCubit()..fetchRecipesFromApi(),
      child: Scaffold(
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
        body: BlocBuilder<RecipeCubit, RecipeState>(
          builder: (context, state) {
            if (state is RecipeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RecipeError) {
              return Center(child: Text(state.message));
            } else if (state is RecipeLoaded) {
              final recipes = state.recipes;
              final pages = [
                HomeContentScreen(recipes: recipes),
                const FavoritesScreen(),
              ];
              return pages[bottomNav.selectedIndex];
            }
            return const SizedBox.shrink();
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: bottomNav.selectedIndex,
          onTap: (index) {
            if (index == 2) {
              _openAddRecipePage(context);
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
      ),
    );
  }
}
