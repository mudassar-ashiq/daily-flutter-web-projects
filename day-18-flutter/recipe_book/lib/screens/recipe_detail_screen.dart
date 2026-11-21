import 'package:flutter/material.dart';

import '../models/recipe.dart';
import '../services/recipe_store.dart';

class RecipeDetailScreen extends StatefulWidget {
  const RecipeDetailScreen({
    super.key,
    required this.recipe,
    required this.store,
  });

  final Recipe recipe;
  final RecipeStore? store;

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final Set<int> _checkedIngredients = {};

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;
    final store = widget.store;
    final isFavourite = store?.isFavourite(recipe.id) ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
        actions: [
          IconButton(
            icon: Icon(isFavourite ? Icons.favorite : Icons.favorite_border),
            tooltip: isFavourite
                ? 'Remove from favourites'
                : 'Add to favourites',
            onPressed: store == null
                ? null
                : () async {
                    await store.toggleFavourite(recipe.id);
                    setState(() {});
                  },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Wrap(
            spacing: 8,
            children: [
              Chip(label: Text(recipe.category)),
              Chip(label: Text(formatTime(recipe.minutes))),
              Chip(label: Text('Serves ${recipe.servings}')),
              Chip(label: Text(recipe.difficulty)),
            ],
          ),
          const SizedBox(height: 20),
          Text('Ingredients', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...List.generate(recipe.ingredients.length, (index) {
            final ingredient = recipe.ingredients[index];
            final checked = _checkedIngredients.contains(index);
            return CheckboxListTile(
              value: checked,
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _checkedIngredients.add(index);
                  } else {
                    _checkedIngredients.remove(index);
                  }
                });
              },
              title: Text(
                ingredient,
                style: checked
                    ? const TextStyle(decoration: TextDecoration.lineThrough)
                    : null,
              ),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            );
          }),
          const SizedBox(height: 12),
          Text('Method', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...List.generate(recipe.steps.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(radius: 14, child: Text('${index + 1}')),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      recipe.steps[index],
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
