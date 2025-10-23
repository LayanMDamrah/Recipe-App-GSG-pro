import 'package:flutter/material.dart';
import 'package:recipe_gsg/models/recipy.dart';
import 'package:recipe_gsg/services/recipe_db_service.dart';
import 'package:recipe_gsg/services/shared_prefs.dart';
import 'package:recipe_gsg/widget/app_buttom.dart';

class RecipeInputScreen extends StatefulWidget {
  final VoidCallback onSave;
  final Recipe? recipeToEdit;

  const RecipeInputScreen({super.key, required this.onSave, this.recipeToEdit});

  @override
  State<RecipeInputScreen> createState() => _RecipeInputScreenState();
}

class _RecipeInputScreenState extends State<RecipeInputScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _imageController;
  late TextEditingController _ratingController;
  late TextEditingController _ingredientsController;
  late TextEditingController _instructionsController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.recipeToEdit?.name ?? '',
    );
    _imageController = TextEditingController(
      text: widget.recipeToEdit?.image ?? '',
    );
    _ratingController = TextEditingController(
      text: widget.recipeToEdit != null
          ? widget.recipeToEdit!.rating.toString()
          : '',
    );
    _ingredientsController = TextEditingController(
      text: widget.recipeToEdit?.ingredients.join(',') ?? '',
    );
    _instructionsController = TextEditingController(
      text: widget.recipeToEdit?.instructions.join(',') ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _imageController.dispose();
    _ratingController.dispose();
    _ingredientsController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _saveRecipe() async {
    if (!_formKey.currentState!.validate()) return;

    final userEmail = await SharedPrefs.getUserToken() ?? 'example@email.com';

    final recipe = Recipe(
      id: widget.recipeToEdit?.id,
      name: _nameController.text.trim(),
      image: _imageController.text.trim(),
      rating: double.tryParse(_ratingController.text.trim()) ?? 0,
      ingredients: _ingredientsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      instructions: _instructionsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      userEmail: widget.recipeToEdit?.userEmail ?? userEmail,
    );

    if (widget.recipeToEdit != null) {
      await RecipeDBService.updateRecipe(recipe);
    } else {
      await RecipeDBService.insertRecipe(recipe);
    }

    widget.onSave();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipeToEdit != null ? 'Edit Recipe' : 'Add Recipe'),
        centerTitle: true,
      ),
      body: SafeArea(
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
                AppButton(
                  text: widget.recipeToEdit != null
                      ? 'Update Recipe'
                      : 'Save Recipe',
                  onPressed: _saveRecipe,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
