import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/themes/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SliderListView Widget Tests', () {
    final theme = createAppLightTheme();
    testWidgets('renders SliderListView with given items', (tester) async {
      // Arrange
      final items = List.generate(
        5,
        (index) => 'Item $index',
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('ar', 'AR'),
          ],
          theme: theme.copyWith(
            extensions: [
              ...theme.extensions.values,
              ThemeTextStyles.english(),
            ],
          ),
          home: Scaffold(
            body: SliderListView<String>(
              items: items,
              contentSize: 200,
              viewportWidth: 400,
              itemBuilder: (item) => Text(item ?? ''),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(SliderListView<String>), findsOneWidget);
      expect(find.text('Item 0'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
    });

    testWidgets('tapping an item calls the onTap callback', (tester) async {
      // Arrange
      String? tappedItem;
      final items = List.generate(
        5,
        (index) => 'Item $index',
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('ar', 'AR'),
          ],
          theme: theme.copyWith(
            extensions: [
              ...theme.extensions.values,
              ThemeTextStyles.english(),
            ],
          ),
          home: Scaffold(
            body: SliderListView<String>(
              items: items,
              contentSize: 200,
              viewportWidth: 400,
              itemBuilder: (item) => Text(item ?? ''),
              onTap: (item) {
                tappedItem = item;
              },
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.text('Item 2'));
      await tester.pumpAndSettle();

      // Assert
      expect(tappedItem, 'Item 2');
    });

    testWidgets('renders correct number of items', (tester) async {
      // Arrange
      final items = List.generate(
        10,
        (index) => 'Item $index',
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('ar', 'AR'),
          ],
          theme: theme.copyWith(
            extensions: [
              ...theme.extensions.values,
              ThemeTextStyles.english(),
            ],
          ),
          home: Scaffold(
            body: SliderListView<String>(
              items: items,
              contentSize: 200,
              viewportWidth: 400,
              itemBuilder: (item) => Text(item ?? ''),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(Text), findsNWidgets(4));
    });

    testWidgets('displays a placeholder when the item list is empty', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SliderListView<String>(
              items: const [],
              contentSize: 200,
              viewportWidth: 400,
              itemBuilder: (item) => Text(item ?? 'Placeholder'),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Placeholder'), findsOneWidget);
    });

    testWidgets('shows a page indicator when showIndicator is true', (tester) async {
      // Arrange
      final items = List.generate(
        5,
        (index) => 'Item $index',
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('ar', 'AR'),
          ],
          theme: theme.copyWith(
            extensions: [
              ...theme.extensions.values,
              ThemeTextStyles.english(),
            ],
          ),
          home: Scaffold(
            body: SliderListView<String>(
              items: items,
              contentSize: 200,
              viewportWidth: 400,
              itemBuilder: (item) => Text(item ?? ''),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(SmoothDotSliderIndicator), findsOneWidget);
    });

    testWidgets('does not show a page indicator when showIndicator is false', (tester) async {
      // Arrange
      final items = List.generate(
        5,
        (index) => 'Item $index',
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('ar', 'AR'),
          ],
          theme: theme.copyWith(
            extensions: [
              ...theme.extensions.values,
              ThemeTextStyles.english(),
            ],
          ),
          home: Scaffold(
            body: SliderListView<String>(
              items: items,
              contentSize: 200,
              viewportWidth: 400,
              showIndicator: false,
              itemBuilder: (item) => Text(item ?? ''),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(SmoothDotSliderIndicator), findsNothing);
    });
  });
}
