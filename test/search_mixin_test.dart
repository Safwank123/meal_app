import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_app/core/common_widgets/custom_search_mixin.dart';


class TestSearchPage extends StatefulWidget {
  const TestSearchPage({super.key});

  @override
  State<TestSearchPage> createState() => _TestSearchPageState();
}

class _TestSearchPageState extends State<TestSearchPage>
    with SearchMixin<TestSearchPage> {
  String lastSearch = '';

  @override
  void onSearchChanged(String searchTerm) {
    lastSearch = searchTerm;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildSearchField(),
    );
  }
}

void main() {
  testWidgets('SearchMixin accepts input and triggers search',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: TestSearchPage(),
      ),
    );

    // Tap search icon
    await tester.tap(find.byIcon(Icons.search));
    await tester.pump();

    // Enter search text
    await tester.enterText(find.byType(TextField), 'Pasta');
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Pasta'), findsOneWidget);
  });
}
