import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/shared/ui/bottom_sheet/dgis_bottom_sheet.dart';

/// Regression for BALADY-3614: PopScope fires after the route is already
/// popped, so a second `router.pop(result)` used to remove the route
/// underneath the sheet (the tab shell) instead of just the sheet's route.
void main() {
  testWidgets('popping DgisBottomSheet with a non-null result keeps the route underneath', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Navigator(
          onGenerateRoute: (_) => MaterialPageRoute<void>(
            builder: (context) => Column(
              children: [
                const Text('base route'),
                Builder(
                  builder: (context) => ElevatedButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<Object?>(
                        builder: (_) => DgisBottomSheet(
                          initialExpansion: Expansion.expanded,
                          availableExpansions: const {Expansion.expanded},
                          body: (_) => const Text('picker'),
                        ),
                      ),
                    ),
                    child: const Text('open picker'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open picker'));
    await tester.pumpAndSettle();
    expect(find.text('picker'), findsOneWidget);
    expect(find.text('base route'), findsNothing);

    Navigator.of(tester.element(find.text('picker'))).pop('picked-address');
    await tester.pumpAndSettle();

    expect(find.text('picker'), findsNothing);
    expect(find.text('base route'), findsOneWidget);
  });
}
