import 'package:flutter/material.dart';
import 'package:recipe_gsg/models/recipy.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(recipe.image),
            const SizedBox(height: 16),
            Text('Ingredients:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...recipe.ingredients.map((i) => Text('- $i')),
            const SizedBox(height: 16),
            Text('Instructions:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...recipe.instructions.map((i) => Text('- $i')),
          ],
        ),
      ),
    );
  }
}
