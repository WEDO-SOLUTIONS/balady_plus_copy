import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/shared/test_utils/test_material_app.dart';
import 'package:mapness/widgets/app_feedback/v2/rating_bar.dart';

void main() {
  group('Widget test', () {
    late ProviderContainer container;

    setUpAll(() {
      container = ProviderContainer();
    });

    tearDownAll(() {
      container.dispose();
    });

    testWidgets('RatingBar displays correct number of active stars', (WidgetTester tester) async {
      const testRating = 3;
      await tester.pumpWidget(
        const ProviderScope(
          child: TestMaterialApp(
            child: Scaffold(
              body: RatingBar(rating: testRating),
            ),
          ),
        ),
      );

      for (int i = 0; i < RatingBar.maxRating; i++) {
        final isActive = i < testRating;
        expect(
          find.byKey(ValueKey('rating_star-$i-$isActive')),
          findsOneWidget,
        );
      }
    });

    testWidgets('RatingBar calls onRatingChanged with correct value', (WidgetTester tester) async {
      int? selectedRating;
      await tester.pumpWidget(
        ProviderScope(
          child: TestMaterialApp(
            child: Scaffold(
              body: RatingBar(
                onRatingChanged: (rating) {
                  selectedRating = rating;
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const ValueKey('rating_star-2-false')));
      await tester.pump();

      expect(selectedRating, 3);
    });
  });
}
