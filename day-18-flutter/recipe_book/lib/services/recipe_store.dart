import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/recipe.dart';

// Favourite ids and the user's own recipes live in SharedPreferences
// so they are still there when the app is opened again.
class RecipeStore {
  RecipeStore(this._prefs);

  final SharedPreferences _prefs;

  static const _favouritesKey = 'favourite_recipe_ids';
  static const _userRecipesKey = 'user_recipes';

  Set<String> get favouriteIds =>
      _prefs.getStringList(_favouritesKey)?.toSet() ?? {};

  bool isFavourite(String id) => favouriteIds.contains(id);

  Future<void> toggleFavourite(String id) async {
    final ids = favouriteIds;
    if (ids.contains(id)) {
      ids.remove(id);
    } else {
      ids.add(id);
    }
    await _prefs.setStringList(_favouritesKey, ids.toList());
  }

  List<Recipe> get userRecipes {
    final raw = _prefs.getStringList(_userRecipesKey) ?? [];
    return raw
        .map(
          (item) => Recipe.fromJson(jsonDecode(item) as Map<String, dynamic>),
        )
        .toList();
  }

  Future<void> addUserRecipe(Recipe recipe) async {
    final recipes = userRecipes..add(recipe);
    await _saveUserRecipes(recipes);
  }

  Future<void> deleteUserRecipe(String id) async {
    final recipes = userRecipes.where((r) => r.id != id).toList();
    await _saveUserRecipes(recipes);
  }

  Future<void> _saveUserRecipes(List<Recipe> recipes) async {
    await _prefs.setStringList(
      _userRecipesKey,
      recipes.map((r) => jsonEncode(r.toJson())).toList(),
    );
  }
}
