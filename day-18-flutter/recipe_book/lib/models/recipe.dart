class Recipe {
  const Recipe({
    required this.id,
    required this.name,
    required this.category,
    required this.minutes,
    required this.servings,
    required this.difficulty,
    required this.ingredients,
    required this.steps,
    this.userAdded = false,
  });

  final String id;
  final String name;
  final String category;
  final int minutes;
  final int servings;
  final String difficulty;
  final List<String> ingredients;
  final List<String> steps;
  final bool userAdded;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'minutes': minutes,
    'servings': servings,
    'difficulty': difficulty,
    'ingredients': ingredients,
    'steps': steps,
    'userAdded': userAdded,
  };

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      minutes: json['minutes'] as int,
      servings: json['servings'] as int,
      difficulty: json['difficulty'] as String,
      ingredients: List<String>.from(json['ingredients'] as List),
      steps: List<String>.from(json['steps'] as List),
      userAdded: json['userAdded'] as bool? ?? false,
    );
  }
}

String formatTime(int minutes) {
  if (minutes < 60) return '$minutes min';
  final hours = minutes ~/ 60;
  final rest = minutes % 60;
  if (rest == 0) return '$hours h';
  return '$hours h $rest min';
}

// Search looks at the recipe name and its ingredients, and the
// category chip narrows the list down further.
List<Recipe> filterRecipes(
  List<Recipe> recipes, {
  String query = '',
  String category = 'All',
}) {
  final q = query.trim().toLowerCase();
  return recipes.where((recipe) {
    if (category != 'All' && recipe.category != category) return false;
    if (q.isEmpty) return true;
    if (recipe.name.toLowerCase().contains(q)) return true;
    return recipe.ingredients.any((item) => item.toLowerCase().contains(q));
  }).toList();
}
