import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:recipe_gsg/models/recipy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<Recipe> _favorites = [];

  List<Recipe> get favorites => _favorites;

  FavoritesProvider() {
    loadFavorites();
  }

  bool isFavorite(Recipe recipe) {
    return _favorites.any((r) => r.id == recipe.id);
  }

  void toggleFavorite(Recipe recipe) {
    if (isFavorite(recipe)) {
      _favorites.removeWhere((r) => r.id == recipe.id);
    } else {
      _favorites.add(recipe);
    }
    saveFavorites();
    notifyListeners();
  }

  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favsJson =
        _favorites.map((r) => json.encode(_recipeToMap(r))).toList();
    await prefs.setStringList('favorites', favsJson);
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favsJson = prefs.getStringList('favorites') ?? [];
    _favorites.clear();
    _favorites.addAll(
        favsJson.map((jsonStr) => Recipe.fromJson(json.decode(jsonStr))));
    notifyListeners();
  }

  Map<String, dynamic> _recipeToMap(Recipe r) {
    return {
      'id': r.id,
      'name': r.name,
      'image': r.image,
      'rating': r.rating,
      'ingredients': r.ingredients,
      'instructions': r.instructions,
    };
  }
}
