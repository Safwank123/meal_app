import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_app/config/typography/app_typography.dart';
import 'package:meal_app/core/common_widgets/custom_search_mixin.dart';
import 'package:meal_app/features/home/data/model/favorite_meal_db_model.dart';
import 'package:meal_app/features/home/data/model/meal_model.dart';
import 'package:meal_app/features/home/presentation/bloc/meals_bloc.dart';
import 'package:meal_app/features/home/presentation/screens/favorite_meals_screen.dart';
import 'package:meal_app/features/home/presentation/widgets/meal_grid_card.dart';
import 'package:meal_app/features/home/presentation/widgets/meal_list_card.dart';
import 'package:skeletonizer/skeletonizer.dart';


class MealListScreen extends StatefulWidget {
  const MealListScreen({super.key});

  @override
  State<MealListScreen> createState() => _MealListScreenState();
}

class _MealListScreenState extends State<MealListScreen>
    with SearchMixin<MealListScreen> {
  bool isGridView = true;

  String searchQuery = '';
  String? selectedCategory;
  String? selectedArea;

  SortOrder sortOrder = SortOrder.az;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    context.read<MealsBloc>().add(const FetchAllMeals());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }


  @override
  void onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() => searchQuery = value.toLowerCase().trim());
    });
  }

  int get activeFilterCount {
    int count = 0;
    if (searchQuery.isNotEmpty) count++;
    if (selectedCategory != null) count++;
    if (selectedArea != null) count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesCubit>();

    return RefreshIndicator(
      onRefresh: () async {
        context.read<MealsBloc>().add(const FetchAllMeals());
      },
      child: Scaffold(
      appBar: isSearching
    ? null
    : AppBar(
        title: const Text("Meals"),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FavoriteMealsScreen(),
                ),
              );
            },
          ),
          PopupMenuButton<SortOrder>(
            onSelected: (v) => setState(() => sortOrder = v),
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: SortOrder.az,
                child: Text("Name A–Z"),
              ),
              PopupMenuItem(
                value: SortOrder.za,
                child: Text("Name Z–A"),
              ),
            ],
            icon: const Icon(Icons.sort),
          ),
          IconButton(
            icon: Icon(isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () => setState(() => isGridView = !isGridView),
          ),
        ],
      ),

      
      body: BlocBuilder<MealsBloc, MealsState>(
          builder: (context, state) {
         
            if (state.emitState == MealsEmitState.loading) {
              return Skeletonizer(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: buildSearchField(hintText: "Search meals"),
                    ),
                    
                
                    if (isGridView)
                      SliverPadding(
                        padding: const EdgeInsets.all(12),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                            (context, i) => Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 140,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(12),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 16,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Container(
                                          height: 12,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            childCount: 8,
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.72,
                          ),
                        ),
                      )
                    
                 
                    else
                      SliverPadding(
                        padding: const EdgeInsets.all(12),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, i) => Container(
                              height: 100,
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: const BorderRadius.horizontal(
                                        left: Radius.circular(12),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 16,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            height: 12,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            childCount: 8,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }

            if (state.emitState == MealsEmitState.error) {
              return const Center(child: Text("Failed to load meals"));
            }

       
            List<MealModel> meals = [...(state.meals?.data ?? [])];

       
            if (searchQuery.isNotEmpty) {
              meals = meals
                  .where((e) => e.name.toLowerCase().contains(searchQuery))
                  .toList();
            }

            if (selectedCategory != null) {
              meals = meals.where((e) => e.category == selectedCategory).toList();
            }

            if (selectedArea != null) {
              meals = meals.where((e) => e.area == selectedArea).toList();
            }

    
            meals.sort((a, b) => sortOrder == SortOrder.az
                ? a.name.compareTo(b.name)
                : b.name.compareTo(a.name));

            if (meals.isEmpty) {
              return const Center(child: Text("No meals found"));
            }

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: buildSearchField(hintText: "Search meals"),
                ),
                
                SliverToBoxAdapter(
                  child: MealFilterBar(
                    selectedCategory: selectedCategory,
                    selectedArea: selectedArea,
                    activeCount: activeFilterCount,
                    onClear: () => setState(() {
                      searchQuery = '';
                      selectedCategory = null;
                      selectedArea = null;
                    }),
                    onCategorySelected: (v) =>
                        setState(() => selectedCategory = v),
                    onAreaSelected: (v) =>
                        setState(() => selectedArea = v),
                  ),
                ),
                
            
                if (isGridView)
                  SliverPadding(
                    padding: const EdgeInsets.all(12),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) {
                          final meal = meals[i];

                          return MealGridCard(
                            id: meal.idMeal,
                            title: meal.name,
                            imageUrl: meal.thumbnail,
                            description: meal.category,
                            isFavorite: favorites.isFavorite(meal.idMeal),
                            onFavoriteTap: () {
                              favorites.toggle(
                                FavoriteMealDbModel(
                                  id: meal.idMeal,
                                  title: meal.name,
                                  subtitle: "${meal.area} • ${meal.category}",
                                  imageUrl: meal.thumbnail,
                                ),
                              );
                            },
                          );
                        },
                        childCount: meals.length,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.72,
                      ),
                    ),
                  )
          
                else
                  SliverPadding(
                    padding: const EdgeInsets.all(12),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) {
                          final meal = meals[i];

                          return MealListCard(
                            id: meal.idMeal,
                            title: meal.name,
                            subtitle: meal.category,
                            imageUrl: meal.thumbnail,
                            isFavorite: favorites.isFavorite(meal.idMeal),
                            onFavoriteTap: () {
                              favorites.toggle(
                                FavoriteMealDbModel(
                                  id: meal.idMeal,
                                  title: meal.name,
                                  subtitle: "${meal.area} • ${meal.category}",
                                  imageUrl: meal.thumbnail,
                                ),
                              );
                            },
                          );
                        },
                        childCount: meals.length,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}


enum SortOrder { az, za }


class MealFilterBar extends StatelessWidget {
  const MealFilterBar({
    super.key,
    required this.selectedCategory,
    required this.selectedArea,
    required this.activeCount,
    required this.onCategorySelected,
    required this.onAreaSelected,
    required this.onClear,
  });

  final String? selectedCategory;
  final String? selectedArea;
  final int activeCount;

  final ValueChanged<String?> onCategorySelected;
  final ValueChanged<String?> onAreaSelected;
  final VoidCallback onClear;

  static const _categories = [
    'Chicken',
    'Dessert',
    'Seafood',
    'Vegetarian',
  ];

  static const _areas = [
    'American',
    'Italian',
    'Indian',
    'Chinese',
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      height: 56,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
    
          ..._categories.map(
            (cat) => _chip(
              context,
              label: cat,
              selected: selectedCategory == cat,
              onTap: () =>
                  onCategorySelected(selectedCategory == cat ? null : cat),
            ),
          ),

          const SizedBox(width: 12),

          ..._areas.map(
            (area) => _chip(
              context,
              label: area,
              selected: selectedArea == area,
              onTap: () =>
                  onAreaSelected(selectedArea == area ? null : area),
            ),
          ),

          const SizedBox(width: 12),

       
          if (activeCount > 0)
            TextButton.icon(
              onPressed: onClear,
              icon: Icon(Icons.clear, size: 16, color: colors.primary),
              label: Text(
                'Clear ($activeCount)',
                style: AppTypography.style12SemiBold.copyWith(
                  color: colors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _chip(
    BuildContext context, {
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          label,
          style: AppTypography.style12Regular.copyWith(
            color: selected
                ? colors.onPrimary
                : colors.onSurfaceVariant,
          ),
        ),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: colors.primary,
        backgroundColor: colors.surface,
        checkmarkColor: colors.onPrimary,
        shape: StadiumBorder(
          side: BorderSide(
            color: selected
                ? colors.primary
                : colors.outlineVariant,
          ),
        ),
      ),
    );
  }
}



