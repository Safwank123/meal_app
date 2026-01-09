import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:meal_app/config/typography/app_typography.dart';
import 'package:meal_app/core/common_widgets/custom_image_widget.dart';
import 'package:meal_app/core/extensions/app_extensions.dart';
import 'package:meal_app/features/home/presentation/bloc/meals_bloc.dart';
import 'package:meal_app/features/home/presentation/screens/meal_detail_screen.dart';

class MealListCard extends StatelessWidget {
  const MealListCard({
    super.key,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.isFavorite = false,
    this.onFavoriteTap,
  });

  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;

  final bool isFavorite;
  final VoidCallback? onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        context.read<MealsBloc>().add(FetchMealDetail(id));

        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => MealDetailScreen(mealId: id)));
      },
      child: Card(
        elevation: 1,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Hero(
              tag: id,
              child: CustomImageWidget(
                width: 90,
                height: 90,
                imageUrl: imageUrl,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.style14Bold,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.style12Regular,
                  ),
                ],
              ),
            ),

            IconButton(
              onPressed: onFavoriteTap,
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? colors.primary : colors.onSurfaceVariant,
              ),
            ),
          ],
        ).pAll(8),
      ),
    );
  }
}
