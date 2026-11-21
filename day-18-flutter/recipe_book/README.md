# Recipe Book

Day 18 of my daily project series — a recipe book app built with Flutter and Dart.

It comes with ten recipes (biryani, karahi, daal fry, kebabs, pancakes and
more), each with ingredients and steps. You can search by recipe name or by
an ingredient, filter by category, save favourites, tick ingredients off
while you cook, and add your own recipes. Favourites and your own recipes
are saved on the phone, so they are still there when you open the app again.

## Features

- Ten built-in recipes with ingredients and step-by-step method
- Search by name or ingredient, category chips, favourites filter
- Favourites saved with shared_preferences
- Ingredients checklist on the recipe page (tap to tick off)
- Add your own recipes with a form, delete them with a confirm dialog

## How to run

```
flutter pub get
flutter run
```

## Tests

```
flutter test
```

## What I practised

- Keeping the recipe data in a plain model class with toJson/fromJson
  (`lib/models/recipe.dart`) so it can be tested without the UI
- A small filter function for search and category
  (`filterRecipes` in the same file)
- Saving favourites and user recipes as JSON with shared_preferences
  (`lib/services/recipe_store.dart`)
- A form screen with validation for adding a recipe
