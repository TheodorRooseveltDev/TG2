import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/data_service.dart';

class KitchenGuideScreen extends StatefulWidget {
  const KitchenGuideScreen({super.key});

  @override
  State<KitchenGuideScreen> createState() => _KitchenGuideScreenState();
}

class _KitchenGuideScreenState extends State<KitchenGuideScreen> {
  String _selectedCategory = 'techniques';

  @override
  void initState() {
    super.initState();
    // Track guide visit
    final dataService = DataService();
    dataService.incrementGuideVisits();
  }

  final Map<String, List<GuideItem>> _guideContent = {
    'techniques': [
      GuideItem(
        title: 'Knife Skills',
        icon: Icons.cut,
        content: '''
**Basic Cuts:**

• **Chop**: Rough, irregular pieces for rustic dishes
• **Dice**: Small cubes (small: 1/4", medium: 1/2", large: 3/4")
• **Mince**: Very fine pieces, smaller than dice
• **Julienne**: Thin matchstick strips (1/8" x 1/8" x 2")
• **Chiffonade**: Thin ribbons, perfect for herbs and leafy greens

**Safety Tips:**
- Keep your knives sharp (dull knives are more dangerous)
- Use the "claw grip" to protect your fingers
- Always cut away from your body
- Use a stable cutting board with a damp towel underneath
''',
      ),
      GuideItem(
        title: 'Sautéing',
        icon: Icons.local_fire_department,
        content: '''
**The Perfect Sauté:**

1. **Prep First**: Cut all ingredients to uniform size
2. **Hot Pan**: Heat pan over medium-high heat
3. **Add Fat**: Use oil with high smoke point (vegetable, canola)
4. **Don't Overcrowd**: Give ingredients space to brown
5. **Keep Moving**: Toss or stir frequently for even cooking

**Pro Tips:**
- Pat ingredients dry before cooking
- Add aromatics (garlic, ginger) towards the end
- Deglaze the pan with wine or stock for extra flavor
''',
      ),
      GuideItem(
        title: 'Roasting',
        icon: Icons.restaurant,
        content: '''
**Roasting Guidelines:**

**Temperature Guide:**
• High (425-450°F): Vegetables, thin cuts
• Medium (350-375°F): Chicken, fish, medium roasts
• Low (275-325°F): Large roasts, slow-cooking cuts

**Key Principles:**
- Pat proteins dry for better browning
- Season generously with salt and pepper
- Use a rack for air circulation
- Let meat rest 5-15 minutes after cooking
- Use a meat thermometer for accuracy

**Roasting Times (per pound):**
• Chicken: 20 minutes at 375°F
• Beef (medium-rare): 20 minutes at 425°F
• Pork: 25 minutes at 350°F
• Fish: 10 minutes per inch of thickness at 400°F
''',
      ),
      GuideItem(
        title: 'Braising',
        icon: Icons.soup_kitchen,
        content: '''
**The Art of Braising:**

Braising transforms tough cuts into tender, flavorful dishes.

**Steps:**
1. Season and sear meat on all sides
2. Remove meat, sauté aromatics (onions, carrots, celery)
3. Deglaze pan with wine or stock
4. Return meat to pot
5. Add liquid (cover 1/2 to 2/3 of meat)
6. Cover and cook low and slow (275-325°F)

**Best Cuts for Braising:**
- Beef: Chuck, short ribs, brisket
- Pork: Shoulder, ribs
- Chicken: Thighs, legs
- Lamb: Shoulder, shanks

**Timing:** 2-4 hours until fork-tender
''',
      ),
      GuideItem(
        title: 'Blanching',
        icon: Icons.water_drop,
        content: '''
**Perfect Blanching:**

Blanching brightens colors and sets textures.

**Method:**
1. Bring large pot of salted water to boil
2. Add vegetables in small batches
3. Cook briefly (30 seconds to 2 minutes)
4. Immediately transfer to ice bath
5. Drain and pat dry

**Blanching Times:**
• Green beans: 2 minutes
• Broccoli: 2-3 minutes
• Asparagus: 2-3 minutes
• Spinach: 30 seconds
• Tomatoes (for peeling): 30 seconds

**Uses:**
- Prep vegetables for freezing
- Remove skins from tomatoes or peaches
- Set bright green color in vegetables
- Pre-cook for faster final cooking
''',
      ),
    ],
    'tips': [
      GuideItem(
        title: 'Seasoning Tips',
        icon: Icons.settings_suggest,
        content: '''
**The Art of Seasoning:**

**Salt:**
- Season in layers throughout cooking, not just at the end
- Use kosher salt for better control
- Salt meat 40 minutes before or right before cooking
- Finish dishes with flaky sea salt for texture

**Balancing Flavors:**
• **Too Salty**: Add acid (lemon, vinegar) or sweetness
• **Too Acidic**: Add fat (butter, oil) or sweetness
• **Too Sweet**: Add acid or salt
• **Too Bitter**: Add fat or salt
• **Bland**: Add salt, acid, or umami (soy sauce, parmesan)

**Herbs & Spices:**
- Toast whole spices before grinding
- Add hardy herbs (rosemary, thyme) early
- Add delicate herbs (basil, cilantro) at the end
- Bloom spices in oil to release flavors
''',
      ),
      GuideItem(
        title: 'Food Safety',
        icon: Icons.health_and_safety,
        content: '''
**Safe Cooking Temperatures:**

**Minimum Internal Temperatures:**
• Poultry (whole & ground): 165°F
• Ground meats: 160°F
• Beef, pork, lamb (steaks/chops): 145°F
• Fish: 145°F
• Eggs: 160°F

**Storage Guidelines:**
- Refrigerator: 40°F or below
- Freezer: 0°F or below
- Danger zone: 40-140°F (bacteria grows rapidly)

**Storage Times (Refrigerator):**
• Raw ground meat: 1-2 days
• Raw steaks/chops: 3-5 days
• Cooked meat: 3-4 days
• Fresh fish: 1-2 days
• Eggs: 3-5 weeks

**Golden Rules:**
1. Wash hands for 20 seconds before cooking
2. Use separate cutting boards for raw meat
3. Never reuse marinades from raw meat
4. Refrigerate leftovers within 2 hours
''',
      ),
      GuideItem(
        title: 'Kitchen Organization',
        icon: Icons.kitchen,
        content: '''
**Mise en Place:**

French for "everything in its place" - the key to stress-free cooking.

**Before Cooking:**
- Read the entire recipe
- Prep all ingredients (wash, chop, measure)
- Organize by order of use
- Gather all tools and equipment
- Preheat oven if needed

**Kitchen Zones:**
• **Prep Zone**: Cutting board, knives, vegetables
• **Cooking Zone**: Stove, pans, utensils
• **Cleaning Zone**: Sink, dish soap, towels
• **Landing Zone**: Space for hot pans

**Time-Saving Tips:**
- Clean as you go
- Use one bowl for all vegetable scraps
- Line baking sheets with parchment paper
- Keep frequently used items within reach
- Sharpen knives regularly
''',
      ),
      GuideItem(
        title: 'Ingredient Substitutions',
        icon: Icons.swap_horiz,
        content: '''
**Common Substitutions:**

**Dairy:**
• Buttermilk: 1 cup milk + 1 tbsp lemon juice
• Heavy cream: 3/4 cup milk + 1/4 cup melted butter
• Sour cream: Greek yogurt (1:1 ratio)

**Baking:**
• 1 egg: 1/4 cup applesauce or mashed banana
• Baking powder: 1/4 tsp baking soda + 1/2 tsp cream of tartar
• Brown sugar: White sugar + 1 tbsp molasses per cup

**Flavor:**
• Fresh herbs: Dried herbs (1/3 the amount)
• Garlic clove: 1/8 tsp garlic powder
• Wine (cooking): Stock + splash of vinegar
• Soy sauce: Worcestershire sauce + salt

**Produce:**
• Shallots: Small red onion + pinch of garlic
• Fresh tomatoes: Canned tomatoes (drained)
• Fresh ginger: Ground ginger (1/8 the amount)
''',
      ),
      GuideItem(
        title: 'Pasta Perfection',
        icon: Icons.dining,
        content: '''
**Cooking Perfect Pasta:**

**The Method:**
1. Use 4-6 quarts water per pound of pasta
2. Salt water generously (should taste like the sea)
3. Don't add oil to the water
4. Stir immediately after adding pasta
5. Cook until al dente (follow package time, test often)
6. Reserve 1 cup pasta water before draining
7. Never rinse pasta (unless for cold salads)

**Sauce Pairing:**
• **Thin/smooth sauces**: Long pasta (spaghetti, linguine)
• **Chunky sauces**: Short pasta with ridges (rigatoni, penne)
• **Light/oil-based**: Thin pasta (angel hair, capellini)
• **Cream sauces**: Flat pasta (fettuccine, pappardelle)

**Pro Tips:**
- Start sauce when you start pasta water
- Finish cooking pasta in the sauce
- Use pasta water to adjust sauce consistency
- Add pasta to sauce, not sauce to pasta
- Toss with cheese off heat to prevent clumping
''',
      ),
    ],
    'essentials': [
      GuideItem(
        title: 'Essential Kitchen Tools',
        icon: Icons.construction,
        content: '''
**Must-Have Tools:**

**Knives:**
• Chef's knife (8-inch)
• Paring knife
• Serrated bread knife

**Cutting:**
• Large cutting board (wood or plastic)
• Kitchen shears

**Cooking:**
• 10" or 12" stainless steel skillet
• Large pot (8-12 quart) for pasta/soups
• 3-quart saucepan with lid
• Cast iron skillet
• Baking sheet (half-sheet size)

**Prep:**
• Mixing bowls (various sizes)
• Measuring cups (dry and liquid)
• Measuring spoons
• Vegetable peeler
• Box grater
• Colander

**Essential Utensils:**
- Wooden spoons
- Silicone spatula
- Tongs
- Whisk
- Ladle

**Nice to Have:**
- Instant-read thermometer
- Microplane zester
- Bench scraper
- Kitchen scale
''',
      ),
      GuideItem(
        title: 'Pantry Staples',
        icon: Icons.inventory_2,
        content: '''
**Stock Your Pantry:**

**Oils & Vinegars:**
• Extra virgin olive oil (finishing)
• Neutral oil (vegetable, canola)
• Toasted sesame oil
• Red wine vinegar
• Balsamic vinegar

**Canned & Jarred:**
• Crushed tomatoes
• Tomato paste
• Chicken/vegetable stock
• Coconut milk
• Beans (black, kidney, chickpeas)

**Grains & Pasta:**
• Rice (white, brown, or arborio)
• Pasta (various shapes)
• Quinoa or couscous
• Flour (all-purpose)
• Panko breadcrumbs

**Seasonings:**
• Kosher salt & black pepper
• Garlic powder & onion powder
• Paprika & cumin
• Dried oregano & thyme
• Red pepper flakes
• Soy sauce
• Hot sauce

**Baking:**
• Sugar (white & brown)
• Baking powder & baking soda
• Vanilla extract
• Honey or maple syrup
''',
      ),
      GuideItem(
        title: 'Spice Guide',
        icon: Icons.spa,
        content: '''
**Essential Spices & Their Uses:**

**Warm Spices:**
• **Cinnamon**: Baking, oatmeal, curries, Middle Eastern dishes
• **Cumin**: Mexican, Indian, Middle Eastern cuisines
• **Coriander**: Pairs with cumin, great in curries and marinades
• **Cardamom**: Coffee, baked goods, Indian curries

**Hot Spices:**
• **Black Pepper**: Universal, freshly ground is best
• **Red Pepper Flakes**: Pizza, pasta, stir-fries
• **Cayenne**: Heat without flavor change
• **Paprika**: Smoky (Spanish) or sweet (Hungarian)

**Aromatic:**
• **Garlic Powder**: Quick garlic flavor, rubs, seasonings
• **Onion Powder**: Base flavor for many dishes
• **Ginger**: Asian dishes, baking, marinades
• **Turmeric**: Curries, golden milk, anti-inflammatory

**Herbs:**
• **Oregano**: Italian, Greek, pizza, tomato sauces
• **Basil**: Italian dishes, pairs with tomatoes
• **Thyme**: Versatile, poultry, vegetables, French cuisine
• **Rosemary**: Roasted meats, potatoes, bread

**Storage:**
- Keep in cool, dark place
- Replace ground spices yearly
- Whole spices last 2-3 years
- Toast before using for more flavor
''',
      ),
      GuideItem(
        title: 'Cooking Oils Guide',
        icon: Icons.opacity,
        content: '''
**Choosing the Right Oil:**

**High Heat (450°F+):**
• **Avocado Oil**: Neutral flavor, smoke point 520°F
• **Refined Peanut Oil**: Great for frying, 450°F
• **Safflower Oil**: Light flavor, 510°F

**Medium-High Heat (400-450°F):**
• **Canola Oil**: Neutral, affordable, 400°F
• **Grapeseed Oil**: Light, clean flavor, 420°F
• **Vegetable Oil**: All-purpose, 400-450°F

**Medium Heat (350-375°F):**
• **Coconut Oil**: Adds coconut flavor, 350°F
• **Corn Oil**: Economical, neutral, 450°F

**Low Heat/Finishing:**
• **Extra Virgin Olive Oil**: Fruity, peppery, 325-375°F
• **Sesame Oil**: Toasted for Asian dishes, 350°F
• **Walnut Oil**: Finishing, salads, 320°F

**Best Uses:**
- **Deep frying**: Peanut, canola, vegetable
- **Sautéing**: Canola, grapeseed, light olive oil
- **Roasting**: Avocado, canola, vegetable
- **Salad dressings**: Extra virgin olive, walnut
- **Baking**: Canola, vegetable, coconut

**Storage Tips:**
- Keep in cool, dark place
- Use within 6-12 months
- Refrigerate nut oils
''',
      ),
      GuideItem(
        title: 'Measuring Equivalents',
        icon: Icons.straighten,
        content: '''
**Measurement Conversions:**

**Volume:**
• 3 teaspoons = 1 tablespoon
• 4 tablespoons = 1/4 cup
• 16 tablespoons = 1 cup
• 2 cups = 1 pint
• 4 cups = 1 quart
• 4 quarts = 1 gallon

**Weight:**
• 16 ounces = 1 pound
• 1 ounce = 28 grams
• 1 pound = 454 grams

**Common Ingredient Weights:**
• 1 cup all-purpose flour = 120g
• 1 cup granulated sugar = 200g
• 1 cup brown sugar (packed) = 220g
• 1 cup butter = 227g (2 sticks)
• 1 stick butter = 8 tbsp = 1/2 cup = 113g

**Temperature:**
• Celsius to Fahrenheit: (°C × 9/5) + 32
• Fahrenheit to Celsius: (°F - 32) × 5/9

**Quick Reference:**
• 250°F = 120°C (low)
• 350°F = 175°C (moderate)
• 425°F = 220°C (hot)
• 450°F = 230°C (very hot)

**Pinch, Dash & Smidgen:**
• Pinch = 1/16 teaspoon
• Dash = 1/8 teaspoon
• Smidgen = 1/32 teaspoon
''',
      ),
    ],
    'guides': [
      GuideItem(
        title: 'Meal Planning',
        icon: Icons.calendar_today,
        content: '''
**Effective Meal Planning:**

**Weekly Planning Steps:**
1. **Check Schedule**: Note busy days, plan quick meals
2. **Inventory**: Check fridge, freezer, pantry
3. **Plan Meals**: 5-7 dinners, breakfasts, lunches
4. **Make List**: Organize by store section
5. **Prep Ahead**: Chop vegetables, marinate proteins

**Time-Saving Strategies:**
• **Batch Cooking**: Make double, freeze half
• **Theme Nights**: Taco Tuesday, Pasta Thursday
• **One-Pot Meals**: Less cleanup, more flavor
• **Prep on Sunday**: Wash/chop vegetables, cook grains

**Budget Tips:**
- Plan meals around sales
- Use seasonal produce
- Buy proteins in bulk, freeze portions
- Cook from scratch when possible
- Repurpose leftovers creatively

**Sample Week:**
• Monday: Slow cooker meal (minimal effort)
• Tuesday: Quick stir-fry (20 minutes)
• Wednesday: Sheet pan dinner (easy cleanup)
• Thursday: Pasta night (crowd-pleaser)
• Friday: Leftover remix or takeout
• Weekend: Batch cooking for the week
''',
      ),
      GuideItem(
        title: 'Knife Maintenance',
        icon: Icons.handyman,
        content: '''
**Keeping Knives Sharp:**

**Why Sharp Matters:**
- Safer (less likely to slip)
- Easier to use
- Cleaner cuts preserve food texture
- More control and precision

**Maintenance:**
• **Honing** (weekly): Realigns the edge
  - Use a honing steel before each use
  - Hold steel vertically, blade at 15-20° angle
  - Swipe blade from heel to tip, alternating sides
  
• **Sharpening** (few times/year): Removes metal
  - Use whetstone, electric sharpener, or professional
  - Whetstone gives best control
  - Test on paper - should slice cleanly

**Care Tips:**
- Hand wash and dry immediately
- Never put in dishwasher
- Store in knife block or on magnetic strip
- Use wood or plastic cutting boards (not glass/marble)
- Don't use for tasks like opening cans

**When to Sharpen:**
- Knife won't cut tomato skin easily
- You apply pressure to cut
- Honing steel doesn't help anymore
- Blade looks dull or rounded
''',
      ),
      GuideItem(
        title: 'Making Stock',
        icon: Icons.local_drink,
        content: '''
**Homemade Stock Basics:**

**Why Make Stock:**
- Better flavor than store-bought
- Use up vegetable scraps and bones
- Control sodium content
- Economical

**Basic Chicken Stock:**
**Ingredients:**
- 3-4 lbs chicken bones/carcass
- 2 onions, quartered
- 3 carrots, roughly chopped
- 3 celery stalks, roughly chopped
- 2 bay leaves
- 10 peppercorns
- Fresh herbs (parsley, thyme)
- Water to cover

**Method:**
1. Place all ingredients in large pot
2. Cover with cold water by 2 inches
3. Bring to gentle simmer (don't boil)
4. Skim foam from surface
5. Simmer 3-4 hours, uncovered
6. Strain through fine-mesh sieve
7. Cool quickly, refrigerate or freeze

**Other Stocks:**
• **Vegetable**: 45 minutes, any vegetables
• **Beef**: 6-8 hours, roast bones first
• **Fish**: 30-45 minutes, use mild fish bones

**Storage:**
- Refrigerate: 5 days
- Freeze: 6 months
- Ice cube trays for small amounts
''',
      ),
      GuideItem(
        title: 'Baking Basics',
        icon: Icons.cake,
        content: '''
**Baking Fundamentals:**

**Key Principles:**
- Measure accurately (weight is best)
- Room temperature ingredients blend better
- Don't overmix (develops gluten, tough texture)
- Preheat oven fully before baking
- Bake in center of oven

**Understanding Leaveners:**
• **Baking Powder**: Contains acid, just needs liquid
• **Baking Soda**: Needs acid (buttermilk, yogurt, vinegar)
• **Yeast**: Living organism, needs warmth and time

**Mixing Methods:**
• **Creaming**: Beat butter & sugar until fluffy (cookies, cakes)
• **Muffin Method**: Mix wet and dry separately, combine gently
• **Biscuit Method**: Cut cold butter into flour
• **Folding**: Gently incorporate with spatula to keep air

**Common Issues:**
• **Dense/Heavy**: Overmixed or too much flour
• **Dry**: Overbaked or too much flour
• **Flat Cookies**: Butter too warm, not enough flour
• **Sunken Cake**: Oven too hot, opened door too early
• **Tough**: Overmixed or overbaked

**Testing Doneness:**
- Toothpick comes out with few moist crumbs
- Springs back when lightly touched
- Edges pull away from pan
- Internal temp: 190-210°F for bread
''',
      ),
      GuideItem(
        title: 'Wine Pairing Basics',
        icon: Icons.wine_bar,
        content: '''
**Simple Wine Pairing Guide:**

**Basic Principles:**
- Match weight: Light food = light wine
- Complement or contrast flavors
- Consider sauce more than protein
- Regional pairings usually work (Italian food + Italian wine)
- When in doubt, go with bubbles or rosé

**By Protein:**
• **Fish/Seafood**: Crisp white (Sauvignon Blanc, Pinot Grigio)
• **Chicken**: Versatile - white or light red (Chardonnay, Pinot Noir)
• **Pork**: Medium whites or light reds (Riesling, Grenache)
• **Beef**: Full-bodied red (Cabernet, Malbec, Syrah)
• **Lamb**: Bold red (Cabernet, Bordeaux blend)

**By Flavor:**
• **Spicy**: Off-dry white or rosé (Riesling, Gewürztraminer)
• **Rich/Creamy**: Full white or light red (Chardonnay, Pinot Noir)
• **Acidic (tomato)**: High-acid wine (Chianti, Sangiovese)
• **Sweet**: Wine should be sweeter than food
• **Salty**: Sparkling or crisp white

**Cooking with Wine:**
- Use wine you'd drink
- Cook off alcohol (simmer 10+ minutes)
- Add early for mellow flavor
- Red wine = beef/lamb
- White wine = chicken/fish/pork
- Fortified wines add depth (sherry, marsala)

**Non-Drinkers:**
Pair with similar profiles in non-alcoholic drinks!
''',
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitchen Guide'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Category Tabs
            Container(
              decoration: BoxDecoration(
                color: AppTheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingL,
                  vertical: AppTheme.spacingM,
                ),
                child: Row(
                  children: [
                    _buildCategoryTab('techniques', 'Techniques', Icons.restaurant_menu),
                    const SizedBox(width: AppTheme.spacingS),
                    _buildCategoryTab('tips', 'Tips & Tricks', Icons.lightbulb),
                    const SizedBox(width: AppTheme.spacingS),
                    _buildCategoryTab('essentials', 'Essentials', Icons.kitchen),
                    const SizedBox(width: AppTheme.spacingS),
                    _buildCategoryTab('guides', 'Guides', Icons.menu_book),
                  ],
                ),
              ),
            ),

            // Content
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(AppTheme.spacingL),
                itemCount: _guideContent[_selectedCategory]!.length,
                itemBuilder: (context, index) {
                  final item = _guideContent[_selectedCategory]![index];
                  return _buildGuideCard(item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTab(String category, String label, IconData icon) {
    final isSelected = _selectedCategory == category;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingM,
          vertical: AppTheme.spacingS,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.secondary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          border: Border.all(
            color: isSelected ? AppTheme.secondary : AppTheme.divider,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : AppTheme.textSecondary,
            ),
            const SizedBox(width: AppTheme.spacingXS),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isSelected ? Colors.white : AppTheme.textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideCard(GuideItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingL),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with Icon
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  decoration: BoxDecoration(
                    color: AppTheme.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  child: Icon(
                    item.icon,
                    color: AppTheme.secondary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: Text(
                    item.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingL),
            
            // Divider
            Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.secondary.withOpacity(0.3),
                    AppTheme.secondary.withOpacity(0.05),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),
            
            // Content
            _buildMarkdownContent(item.content),
          ],
        ),
      ),
    );
  }

  Widget _buildMarkdownContent(String content) {
    final lines = content.trim().split('\n');
    final widgets = <Widget>[];

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      
      if (line.trim().isEmpty) {
        widgets.add(const SizedBox(height: AppTheme.spacingM));
        continue;
      }

      // Headers (bold text with **)
      if (line.startsWith('**') && line.endsWith('**')) {
        final text = line.substring(2, line.length - 2);
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(
              top: AppTheme.spacingM,
              bottom: AppTheme.spacingM,
            ),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppTheme.secondary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingS),
                Expanded(
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                  ),
                ),
              ],
            ),
          ),
        );
        continue;
      }

      // Bullet points with •
      if (line.trim().startsWith('•')) {
        final text = line.trim().substring(1).trim();
        widgets.add(_buildBulletPoint(text, false));
        continue;
      }

      // Numbered lists
      if (RegExp(r'^\d+\.').hasMatch(line.trim())) {
        final match = RegExp(r'^(\d+)\.\s*(.*)').firstMatch(line.trim());
        if (match != null) {
          final number = match.group(1)!;
          final text = match.group(2)!;
          widgets.add(_buildNumberedPoint(number, text));
        }
        continue;
      }

      // Dashes (sub-bullets)
      if (line.trim().startsWith('-')) {
        final text = line.trim().substring(1).trim();
        widgets.add(_buildSubBullet(text));
        continue;
      }

      // Regular text
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
          child: _parseInlineFormatting(line),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _buildNumberedPoint(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppTheme.secondary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: _parseInlineFormatting(text),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text, bool isNumbered) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppTheme.secondary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: _parseInlineFormatting(text),
          ),
        ],
      ),
    );
  }

  Widget _buildSubBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: AppTheme.spacingL, bottom: AppTheme.spacingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.textSecondary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: _parseInlineFormatting(text),
          ),
        ],
      ),
    );
  }

  Widget _parseInlineFormatting(String text) {
    final spans = <TextSpan>[];
    final regex = RegExp(r'\*\*(.*?)\*\*');
    var lastIndex = 0;

    for (final match in regex.allMatches(text)) {
      // Add text before the match
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: text.substring(lastIndex, match.start),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.textPrimary,
                height: 1.6,
              ),
        ));
      }

      // Add bold text
      spans.add(TextSpan(
        text: match.group(1),
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
              height: 1.6,
            ),
      ));

      lastIndex = match.end;
    }

    // Add remaining text
    if (lastIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastIndex),
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textPrimary,
              height: 1.6,
            ),
      ));
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }
}

class GuideItem {
  final String title;
  final IconData icon;
  final String content;

  GuideItem({
    required this.title,
    required this.icon,
    required this.content,
  });
}
