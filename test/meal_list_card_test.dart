import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_app/features/home/presentation/widgets/meal_list_card.dart';

void main() {
  testWidgets('MealListCard displays content and favorite button works',
      (WidgetTester tester) async {
    bool favoriteTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MealListCard(
            id: '2',
            title: 'Beef Steak',
            subtitle: 'Grilled special',
            imageUrl: 'https://test.com/image.jpg',
            isFavorite: true,
            onFavoriteTap: () {
              favoriteTapped = true;
            },
          ),
        ),
      ),
    );

    // Text checks
    expect(find.text('Beef Steak'), findsOneWidget);
    expect(find.text('Grilled special'), findsOneWidget);

    // Favorite icon is filled
    expect(find.byIcon(Icons.favorite), findsOneWidget);

    // Tap favorite
    await tester.tap(find.byIcon(Icons.favorite));
    await tester.pump();

    expect(favoriteTapped, true);
  });
}
