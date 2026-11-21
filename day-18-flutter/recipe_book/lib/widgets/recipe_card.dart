import 'package:flutter/material.dart';

import '../models/recipe.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({
    super.key,
    required this.recipe,
    required this.isFavourite,
    required this.onTap,
    required this.onFavouritePressed,
    this.onDeletePressed,
  });

  final Recipe recipe;
  final bool isFavourite;
  final VoidCallback onTap;
  final VoidCallback onFavouritePressed;
  final VoidCallback? onDeletePressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Text(
                recipe.name[0],
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(recipe.name),
            subtitle: Text(
              '${recipe.category}  ·  ${formatTime(recipe.minutes)}  ·  Serves ${recipe.servings}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (onDeletePressed != null)
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Delete recipe',
                    onPressed: onDeletePressed,
                  ),
                IconButton(
                  icon: Icon(
                    isFavourite ? Icons.favorite : Icons.favorite_border,
                    color: isFavourite
                        ? Theme.of(context).colorScheme.error
                        : null,
                  ),
                  tooltip: isFavourite
                      ? 'Remove from favourites'
                      : 'Add to favourites',
                  onPressed: onFavouritePressed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
