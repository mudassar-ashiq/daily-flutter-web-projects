import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book/data/recipes.dart';
import 'package:recipe_book/models/recipe.dart';
import 'package:recipe_book/services/recipe_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('formatTime', () {
    test('under an hour shows minutes', () {
      expect(formatTime(40), '40 min');
    });

    test('exactly an hour shows hours', () {
      expect(formatTime(60), '1 h');
    });

    test('over an hour shows hours and minutes', () {
      expect(formatTime(75), '1 h 15 min');
    });
  });

  group('filterRecipes', () {
    test('empty query returns everything', () {
      expect(filterRecipes(builtInRecipes).length, builtInRecipes.length);
    });

    test('category filter only returns that category', () {
      final desi = filterRecipes(builtInRecipes, category: 'Desi');
      expect(desi.length, 5);
      expect(desi.every((r) => r.category == 'Desi'), isTrue);
    });

    test('query matches the recipe name', () {
      final result = filterRecipes(builtInRecipes, query: 'lassi');
      expect(result.map((r) => r.name), ['Mango Lassi']);
    });

    test('query matches an ingredient', () {
      final result = filterRecipes(builtInRecipes, query: 'basmati');
      expect(result.map((r) => r.name).toSet(), {
        'Chicken Biryani',
        'Vegetable Pulao',
      });
    });

    test('no match returns an empty list', () {
      expect(filterRecipes(builtInRecipes, query: 'sushi'), isEmpty);
    });
  });

  group('Recipe json', () {
    test('toJson and fromJson round trip', () {
      final recipe = builtInRecipes.first;
      final restored = Recipe.fromJson(jsonDecode(jsonEncode(recipe.toJson())));
      expect(restored.name, recipe.name);
      expect(restored.ingredients, recipe.ingredients);
      expect(restored.steps, recipe.steps);
      expect(restored.userAdded, isFalse);
    });
  });

  group('RecipeStore', () {
    late SharedPreferences prefs;
    late RecipeStore store;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      store = RecipeStore(prefs);
    });

    test('favourites start empty and toggle on and off', () async {
      expect(store.isFavourite('biryani'), isFalse);
      await store.toggleFavourite('biryani');
      expect(store.isFavourite('biryani'), isTrue);
      await store.toggleFavourite('biryani');
      expect(store.isFavourite('biryani'), isFalse);
    });

    test('a user recipe is saved and can be deleted', () async {
      const recipe = Recipe(
        id: 'user-1',
        name: 'Test Paratha',
        category: 'Breakfast',
        minutes: 15,
        servings: 2,
        difficulty: 'Easy',
        ingredients: ['2 cups flour', 'Water'],
        steps: ['Knead the dough.', 'Cook on a hot pan.'],
        userAdded: true,
      );
      await store.addUserRecipe(recipe);
      expect(store.userRecipes.map((r) => r.id), ['user-1']);
      expect(store.userRecipes.first.name, 'Test Paratha');

      await store.deleteUserRecipe('user-1');
      expect(store.userRecipes, isEmpty);
    });
  });
}
