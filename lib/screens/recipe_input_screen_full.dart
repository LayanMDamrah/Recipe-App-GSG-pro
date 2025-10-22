import 'package:flutter/material.dart';
import 'package:recipe_gsg/screens/recipe_input_screen.dart';

class RecipeInputScreenFull extends StatelessWidget {
  final VoidCallback onSave;
  const RecipeInputScreenFull({super.key, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: RecipeInputScreen(onSave: onSave));
  }
}
