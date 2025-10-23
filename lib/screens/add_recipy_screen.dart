import 'package:flutter/material.dart';
import 'package:recipe_gsg/models/recipy.dart';
import 'package:recipe_gsg/screens/recipe_input_screen.dart';
import 'package:recipe_gsg/screens/recipy_detials_screen.dart';
import 'package:recipe_gsg/services/recipe_db_service.dart';
import 'package:recipe_gsg/services/shared_prefs.dart';
import 'package:recipe_gsg/utils/app_colors.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key, required Future<void> Function() onSave});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  List<Recipe> recipes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initAndFetch();
  }

  Future<void> _initAndFetch() async {
    await RecipeDBService.init();
    await fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    setState(() => isLoading = true);

    final userEmail = await SharedPrefs.getUserToken();

    if (userEmail == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not logged in')));
      setState(() => isLoading = false);
      return;
    }

    final fetchedRecipes = await RecipeDBService.getRecipesByUser(userEmail);

    setState(() {
      recipes = fetchedRecipes;
      isLoading = false;
    });
  }

  void _showAddRecipeScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SafeArea(
          child: Scaffold(
            body: RecipeInputScreen(
              onSave: () async {
                await fetchRecipes();
                if (!mounted) return;
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes'),
        centerTitle: true,
        leading: const BackButton(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: _showAddRecipeScreen,
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : recipes.isEmpty
          ? const Center(child: Text('No recipes yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RecipeDetailScreen(recipe: recipe),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(15),
                          ),
                          child: Image.network(
                            recipe.image,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recipe.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: AppColors.primary,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    recipe.rating.toString(),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(width: 12),
                                  IconButton(
                                    onPressed: () async {
                                      if (recipe.id != null) {
                                        await RecipeDBService.deleteRecipe(
                                          recipe.id!,
                                        );

                                        await fetchRecipes();
                                      }
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => RecipeInputScreen(
                                            onSave: fetchRecipes,
                                            recipeToEdit: recipe,
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
