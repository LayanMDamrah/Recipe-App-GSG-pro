import 'package:flutter/material.dart';
import 'package:recipe_gsg/models/recipy.dart';
import 'package:recipe_gsg/services/recipe_db_service.dart';
import 'package:recipe_gsg/services/shared_prefs.dart';
import 'package:recipe_gsg/widget/app_buttom.dart';

class RecipeInputScreen extends StatefulWidget {
  final VoidCallback onSave;
  const RecipeInputScreen({super.key, required this.onSave});

  @override
  State<RecipeInputScreen> createState() => _RecipeInputScreenState();
}

class _RecipeInputScreenState extends State<RecipeInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _imageController = TextEditingController();
  final _ratingController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _instructionsController = TextEditingController();

  Future<void> _saveRecipe() async {
    if (!_formKey.currentState!.validate()) return;

    final userEmail = await SharedPrefs.getUserToken();
    if (userEmail == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not logged in')));
      return;
    }

    Recipe newRecipe = Recipe(
      name: _nameController.text,
      image: _imageController.text,
      rating: double.parse(_ratingController.text),
      ingredients: _ingredientsController.text.split(','),
      instructions: _instructionsController.text.split(','),
      userEmail: userEmail,
    );

    await RecipeDBService.insertRecipe(newRecipe);
    widget.onSave();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => v!.isEmpty ? 'Enter recipe name' : null,
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: 'Image URL'),
                validator: (v) => v!.isEmpty ? 'Enter image URL' : null,
              ),
              const SizedBox(height: 25),

              TextFormField(
                controller: _ratingController,
                decoration: const InputDecoration(labelText: 'Rating'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Enter rating' : null,
              ),
              const SizedBox(height: 25),

              TextFormField(
                controller: _ingredientsController,
                decoration: const InputDecoration(
                  labelText: 'Ingredients (comma separated)',
                ),
              ),
              const SizedBox(height: 25),

              TextFormField(
                controller: _instructionsController,
                decoration: const InputDecoration(
                  labelText: 'Instructions (comma separated)',
                ),
              ),
              const SizedBox(height: 20),
              AppButton(text: 'Save Recipe', onPressed: _saveRecipe),
            ],
          ),
        ),
      ),
    );
  }
}
