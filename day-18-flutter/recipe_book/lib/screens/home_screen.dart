import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/recipes.dart';
import '../models/recipe.dart';
import '../services/recipe_store.dart';
import '../widgets/recipe_card.dart';
import 'add_recipe_screen.dart';
import 'recipe_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  RecipeStore? _store;
  List<Recipe> _recipes = builtInRecipes;
  String _query = '';
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final store = RecipeStore(prefs);
    setState(() {
      _store = store;
      _recipes = [...builtInRecipes, ...store.userRecipes];
    });
  }

  List<Recipe> get _visibleRecipes {
    var list = _recipes;
    if (_selectedCategory == 'Favourites') {
      final favourites = _store?.favouriteIds ?? {};
      list = list.where((r) => favourites.contains(r.id)).toList();
      return filterRecipes(list, query: _query);
    }
    return filterRecipes(list, query: _query, category: _selectedCategory);
  }

  Future<void> _toggleFavourite(Recipe recipe) async {
    final store = _store;
    if (store == null) return;
    await store.toggleFavourite(recipe.id);
    setState(() {});
  }

  Future<void> _deleteRecipe(Recipe recipe) async {
    final store = _store;
    if (store == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete recipe?'),
        content: Text('${recipe.name} will be removed from your recipes.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await store.deleteUserRecipe(recipe.id);
    setState(() {
      _recipes = [...builtInRecipes, ...store.userRecipes];
    });
  }

  Future<void> _openAddRecipe() async {
    final recipe = await Navigator.push<Recipe>(
      context,
      MaterialPageRoute(builder: (_) => const AddRecipeScreen()),
    );
    if (recipe == null) return;
    final store = _store;
    if (store == null) return;
    await store.addUserRecipe(recipe);
    setState(() {
      _recipes = [...builtInRecipes, ...store.userRecipes];
    });
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visibleRecipes;
    final chips = ['All', 'Favourites', ...recipeCategories];

    return Scaffold(
      appBar: AppBar(title: const Text('Recipe Book')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search recipes or ingredients',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: chips.length,
              itemBuilder: (context, index) {
                final chip = chips[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(chip),
                    selected: _selectedCategory == chip,
                    onSelected: (_) => setState(() => _selectedCategory = chip),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: visible.isEmpty
                ? Center(
                    child: Text(
                      _selectedCategory == 'Favourites'
                          ? 'No favourites yet. Tap the heart on a recipe to save it here.'
                          : 'No recipes match your search.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  )
                : ListView.builder(
                    itemCount: visible.length,
                    itemBuilder: (context, index) {
                      final recipe = visible[index];
                      return RecipeCard(
                        recipe: recipe,
                        isFavourite: _store?.isFavourite(recipe.id) ?? false,
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RecipeDetailScreen(
                                recipe: recipe,
                                store: _store,
                              ),
                            ),
                          );
                          setState(() {});
                        },
                        onFavouritePressed: () => _toggleFavourite(recipe),
                        onDeletePressed: recipe.userAdded
                            ? () => _deleteRecipe(recipe)
                            : null,
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddRecipe,
        icon: const Icon(Icons.add),
        label: const Text('Add recipe'),
      ),
    );
  }
}
