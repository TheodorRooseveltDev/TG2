class Recipe {
  final String id;
  final String name;
  final String description;
  final String imagePath;
  final String difficulty; // Easy, Medium, Hard
  final int prepTime; // in minutes
  final int cookTime; // in minutes
  final List<String> ingredients;
  final List<RecipeStep> steps;
  final List<String> cuisines;
  final List<String> dietaryTypes; // vegan, vegetarian, gluten-free, etc.
  final List<String> allergens;
  final bool isLocked;
  final int pointsRequired;

  Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.difficulty,
    required this.prepTime,
    required this.cookTime,
    required this.ingredients,
    required this.steps,
    required this.cuisines,
    required this.dietaryTypes,
    required this.allergens,
    this.isLocked = false,
    this.pointsRequired = 0,
  });

  int get totalTime => prepTime + cookTime;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imagePath': imagePath,
      'difficulty': difficulty,
      'prepTime': prepTime,
      'cookTime': cookTime,
      'ingredients': ingredients,
      'steps': steps.map((s) => s.toJson()).toList(),
      'cuisines': cuisines,
      'dietaryTypes': dietaryTypes,
      'allergens': allergens,
      'isLocked': isLocked,
      'pointsRequired': pointsRequired,
    };
  }

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imagePath: json['imagePath'],
      difficulty: json['difficulty'],
      prepTime: json['prepTime'],
      cookTime: json['cookTime'],
      ingredients: List<String>.from(json['ingredients']),
      steps: (json['steps'] as List)
          .map((s) => RecipeStep.fromJson(s))
          .toList(),
      cuisines: List<String>.from(json['cuisines']),
      dietaryTypes: List<String>.from(json['dietaryTypes']),
      allergens: List<String>.from(json['allergens']),
      isLocked: json['isLocked'] ?? false,
      pointsRequired: json['pointsRequired'] ?? 0,
    );
  }
}

class RecipeStep {
  final String title;
  final String description;
  final int duration; // in seconds, 0 if no timer needed
  final String? imagePath;

  RecipeStep({
    required this.title,
    required this.description,
    this.duration = 0,
    this.imagePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'duration': duration,
      'imagePath': imagePath,
    };
  }

  factory RecipeStep.fromJson(Map<String, dynamic> json) {
    return RecipeStep(
      title: json['title'],
      description: json['description'],
      duration: json['duration'] ?? 0,
      imagePath: json['imagePath'],
    );
  }
}
