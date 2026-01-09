import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_app/features/home/presentation/widgets/meal_grid_card.dart';

void main() {
  testWidgets('MealGridCard shows title, description and favorite icon',
      (WidgetTester tester) async {
    bool favoriteTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MealGridCard(
            id: '1',
            title: 'Chicken Curry',
            description: 'Spicy Indian curry',
            imageUrl: 'https://test.com/image.jpg',
            isFavorite: false,
            onFavoriteTap: () {
              favoriteTapped = true;
            },
          ),
        ),
      ),
    );

    // Title visible
    expect(find.text('Chicken Curry'), findsOneWidget);

    // Description visible
    expect(find.text('Spicy Indian curry'), findsOneWidget);

    // Favorite border icon initially
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);

    // Tap favorite icon
    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pump();

    expect(favoriteTapped, true);
  });
}
