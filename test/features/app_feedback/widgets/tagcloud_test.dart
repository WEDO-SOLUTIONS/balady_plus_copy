import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/entities/app_feedback/app_feedback_tag_mapper.dart';
import 'package:mapness/l10n/generated/app_localizations_ar.dart';
import 'package:mapness/shared/test_utils/test_material_app.dart';
import 'package:mapness/widgets/app_feedback/v2/tag_cloud.dart';

void main() {
  group("Tag cloud test", () {
    late final ProviderContainer container;

    setUpAll(() {
      container = ProviderContainer();
    });

    tearDownAll(() {
      container.dispose();
    });

    testWidgets('TagCloud displays correct tags based on rating', (WidgetTester tester) async {
      const rating = 5;
      final tags = AppFeedbackTagMapper().getTags(rating, isRtl: false);

      final l10n = AppLocalizationsAr();

      await tester.pumpWidget(
        const ProviderScope(
          child: TestMaterialApp(
            child: Material(child: TagCloud(rating: rating)),
          ),
        ),
      );

      for (final tag in tags) {
        expect(find.text(AppFeedbackTagMapper.getLocalizedText(l10n, tag)), findsOneWidget);
      }
    });

    testWidgets('TagCloud updates selected tags when a tag is tapped', (WidgetTester tester) async {
      const rating = 4;
      final tags = AppFeedbackTagMapper().getTags(rating, isRtl: false);
      Set<Tag>? selectedTags;

      await tester.pumpWidget(
        ProviderScope(
          child: TestMaterialApp(
            child: Material(
              child: TagCloud(
                rating: rating,
                onTagsChanged: (tags) {
                  selectedTags = tags;
                },
              ),
            ),
          ),
        ),
      );

      final firstTag = tags.first;
      final l10n = AppLocalizationsAr();
      final tagId = find.text(AppFeedbackTagMapper.getLocalizedText(l10n, firstTag));
      await tester.tap(tagId);
      await tester.pumpAndSettle();

      expect(selectedTags, contains(firstTag));
    });
  });
}
