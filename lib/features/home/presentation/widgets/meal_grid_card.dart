import 'package:flutter/material.dart';
import 'package:meal_app/config/typography/app_typography.dart';
import 'package:meal_app/core/common_widgets/custom_image_widget.dart';
import 'package:meal_app/features/home/presentation/screens/meal_detail_screen.dart';

class MealGridCard extends StatelessWidget {
  const MealGridCard({
    super.key,
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.description,
    this.isFavorite = false,
    this.onFavoriteTap,
  });

  final String id;
  final String title;
  final String imageUrl;
  final String description;

  final bool isFavorite;
  final VoidCallback? onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),

        /// 👉 ONLY CARD TAP NAVIGATES
        onTap: () {
          debugPrint("➡️ Card tapped, navigating to detail: $id");

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => MealDetailScreen(mealId: id),
            ),
          );
        },

        child: Card(
          elevation: 2,
          color: colors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🖼 IMAGE + ❤️ FAVORITE
              Stack(
                children: [
                  /// 🦸 HERO IMAGE
                  Hero(
                    tag: id,
                    child: CustomImageWidget(
                      height: 150,
                      width: double.infinity,
                      imageUrl: imageUrl,
                    ),
                  ),

                  /// ❤️ FAVORITE (NO NAVIGATION)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        debugPrint(
                          "❤️ Favorite icon tapped for meal: $id | "
                          "currentlyFavorite=$isFavorite",
                        );

                        if (onFavoriteTap == null) {
                          debugPrint("❌ onFavoriteTap is NULL");
                          return;
                        }

                        onFavoriteTap!();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.surface.withOpacity(0.85),
                        ),
                        child: Icon(
                          isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 28,
                          color: isFavorite
                              ? colors.primary
                              : colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

          
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.style14SemiBold.copyWith(
                    color: colors.onSurface,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Text(
                  description.isNotEmpty
                      ? description
                      : 'No description available',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.style12Regular.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
