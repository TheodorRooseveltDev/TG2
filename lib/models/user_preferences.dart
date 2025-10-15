class UserPreferences {
  final List<String> dietaryTypes;
  final List<String> allergens;
  final String skillLevel; // Beginner, Intermediate, Expert
  final List<String> preferredCuisines;
  final bool soundEffects;
  final bool vibration;

  UserPreferences({
    this.dietaryTypes = const [],
    this.allergens = const [],
    this.skillLevel = 'Beginner',
    this.preferredCuisines = const [],
    this.soundEffects = true,
    this.vibration = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'dietaryTypes': dietaryTypes,
      'allergens': allergens,
      'skillLevel': skillLevel,
      'preferredCuisines': preferredCuisines,
      'soundEffects': soundEffects,
      'vibration': vibration,
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      dietaryTypes: List<String>.from(json['dietaryTypes'] ?? []),
      allergens: List<String>.from(json['allergens'] ?? []),
      skillLevel: json['skillLevel'] ?? 'Beginner',
      preferredCuisines: List<String>.from(json['preferredCuisines'] ?? []),
      soundEffects: json['soundEffects'] ?? true,
      vibration: json['vibration'] ?? true,
    );
  }

  UserPreferences copyWith({
    List<String>? dietaryTypes,
    List<String>? allergens,
    String? skillLevel,
    List<String>? preferredCuisines,
    bool? soundEffects,
    bool? vibration,
  }) {
    return UserPreferences(
      dietaryTypes: dietaryTypes ?? this.dietaryTypes,
      allergens: allergens ?? this.allergens,
      skillLevel: skillLevel ?? this.skillLevel,
      preferredCuisines: preferredCuisines ?? this.preferredCuisines,
      soundEffects: soundEffects ?? this.soundEffects,
      vibration: vibration ?? this.vibration,
    );
  }
}
