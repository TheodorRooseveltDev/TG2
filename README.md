# 🍳 Sweet Spin 'n' Cook



A professional lifestyle app that makes cooking fun and spontaneous! Spin the wheel to discover random recipes, follow step-by-step cooking instructions with interactive timers, and track your cooking progress.



## ✨ Features## Getting Started



### 🎲 Core GameplayThis project is a starting point for a Flutter application.

- **Spin & Discover**: Interactive spinning wheel to randomly select recipes

- **Step-by-Step Cooking**: Guided cooking instructions with built-in timersA few resources to get you started if this is your first Flutter project:

- **Progress Tracking**: Track meals cooked, streaks, and earn points

- **Recipe Unlocking**: Unlock premium recipes by earning points- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)

- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

### 📊 Statistics & Motivation

- Daily and weekly meal trackingFor help getting started with Flutter development, view the

- Cooking streak counter[online documentation](https://docs.flutter.dev/), which offers tutorials,

- Points and achievement systemsamples, guidance on mobile development, and a full API reference.

- Progress comparison and insights

### 🎨 Professional Design
- Clean white-themed interface
- 60:30:10 color scheme (White/Orange/Blue-Gray)
- 3-4px rounded corners for modern, professional look
- Smooth animations and transitions
- Responsive Material Design 3

### 🍽️ Recipe Management
- Browse all available recipes
- Filter by dietary preferences and allergens
- View detailed recipe information
- Mark recipes as cooked
- Lock/unlock system based on points

### ⚙️ Customization
- Set dietary preferences (vegan, vegetarian, etc.)
- Specify allergens to avoid
- Choose cooking skill level
- Select preferred cuisines
- Toggle sound effects and vibration

## 🎨 Design Philosophy

### Color Scheme (60:30:10 Rule)
- **60% Primary**: White (#FFFFFF) and Off-White (#F8F9FA) - Clean, spacious backgrounds
- **30% Secondary**: Vibrant Orange (#FF6B35) - Action buttons, highlights, brand identity
- **10% Accent**: Dark Blue-Gray (#2C3E50) - Text, icons, depth

### Visual Elements
- **Border Radius**: 4px for professional, clean aesthetics
- **Spacing**: Consistent 4px increments (4, 8, 16, 24, 32, 48px)
- **Typography**: Clear hierarchy with Material Design 3 text styles
- **Cards**: White surfaces with subtle borders and shadows

## 📱 Screens

1. **Onboarding** - 4-step preference collection
2. **Home** - Stats dashboard with Spin & Cook CTA
3. **Spin** - Interactive wheel animation with recipe result
4. **Cooking** - Step-by-step instructions with timers
5. **Recipes** - Browse and filter all recipes
6. **Recipe Detail** - Full recipe information and ingredients
7. **Settings** - Preferences, profile, and data management

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Dart SDK (3.9.2 or higher)
- iOS Simulator or Android Emulator

### Installation

1. **Install dependencies**
   ```bash
   flutter pub get
   ```

2. **Add required images**
   See `assets/IMAGES_NEEDED.md` for the complete list of 18 images you need to add:
   - 6 recipe images (carbonara.jpg, buddha_bowl.jpg, stir_fry.jpg, lava_cake.jpg, greek_salad.jpg, curry.jpg)
   - 6 custom icons (badges, flames, locks, etc.)
   - 6 illustrations (welcome screens, empty states)

3. **Run the app**
   ```bash
   flutter run
   ```

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  shared_preferences: ^2.2.2  # Local data persistence
  flutter_fortune_wheel: ^1.3.1  # Spinning wheel animation
  intl: ^0.19.0  # Date formatting
```

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── theme/
│   └── app_theme.dart       # Color scheme and theme configuration
├── models/
│   ├── recipe.dart          # Recipe and RecipeStep models
│   ├── user_preferences.dart # User settings model
│   └── user_stats.dart      # User statistics model
├── services/
│   ├── data_service.dart    # Local data persistence
│   └── recipe_service.dart  # Recipe management
└── screens/
    ├── onboarding_screen.dart      # Initial setup
    ├── home_screen.dart            # Main dashboard
    ├── spin_screen.dart            # Wheel spinner
    ├── cooking_screen.dart         # Step-by-step cooking
    ├── recipes_screen.dart         # Recipe browser
    ├── recipe_detail_screen.dart   # Recipe details
    └── settings_screen.dart        # App settings
```

## 🎮 How to Use

### First Time Setup
1. Complete the onboarding to set preferences
2. Choose dietary types, allergens, skill level, and cuisines
3. Start your cooking journey!

### Cooking Flow
1. **Tap "Spin & Cook"** on home screen
2. **Watch the wheel spin** and land on a recipe
3. **Review recipe** or spin again
4. **Start cooking** with step-by-step instructions
5. **Use timers** for each timed step
6. **Complete recipe** to earn points and build streaks

### Earning Points
- Easy recipes: 10 points
- Medium recipes: 20 points
- Hard recipes: 30 points

### Unlocking Recipes
Some premium recipes require points:
- 50 points: Vegetable Curry
- 100 points: Chocolate Lava Cake

## 🎨 Customization

### Adding New Recipes
Edit `lib/services/recipe_service.dart` and add new Recipe objects to the `getAllRecipes()` method.

### Changing Colors
Edit `lib/theme/app_theme.dart` to customize the color scheme.

### Adjusting Border Radius
Modify the radius constants in `app_theme.dart` (currently set to 4px for professional look).

## 📊 Data Persistence

The app uses `shared_preferences` to store:
- User preferences (dietary types, allergens, settings)
- User statistics (meals cooked, streaks, points)
- Onboarding completion status
- Cooked recipe history

Data is automatically saved and persists across app sessions.

## 🎯 Future Enhancements

Potential features for future versions:
- Recipe search and advanced filters
- Favorite recipes
- Shopping list generation
- Social sharing
- Recipe ratings and reviews
- Meal planning calendar
- Nutritional information
- Video cooking tutorials
- Multi-language support
- Dark mode theme
- Cloud sync across devices

## 📝 Next Steps

1. **Add Images**: Review `assets/IMAGES_NEEDED.md` and add all 18 required images
2. **Test**: Run the app and test all features
3. **Customize**: Adjust colors, recipes, and content to your preferences
4. **Deploy**: Build for iOS/Android when ready

---

**Happy Cooking! 🍽️✨**

Made with ❤️ and Flutter
