import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:meal_app/features/home/data/model/favorite_meal_db_model.dart';
import 'package:meal_app/features/home/presentation/bloc/meals_bloc.dart';
import 'package:meal_app/features/home/presentation/widgets/meal_list_card.dart';

class FavoriteMealsScreen extends StatelessWidget {
  const FavoriteMealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Meals"),
      ),
      body: BlocBuilder<FavoritesCubit, List<FavoriteMealDbModel>>(
        builder: (context, favorites) {
      
          if (favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: colors.onSurfaceVariant,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "No favorites yet",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Tap the heart icon to save meals",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: colors.onSurfaceVariant),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: favorites.length,
            itemBuilder: (_, i) {
              final meal = favorites[i];

              return MealListCard(
                id: meal.id,
                title: meal.title,
                subtitle: meal.subtitle,
                imageUrl: meal.imageUrl,
                isFavorite: true,
                onFavoriteTap: () {
                  context.read<FavoritesCubit>().toggle(meal);
                },
              );
            },
          );
        },
      ),
    );
  }
}
