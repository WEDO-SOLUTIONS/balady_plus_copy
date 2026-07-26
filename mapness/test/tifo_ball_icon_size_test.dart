import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/features/tifo/ui/tifo_theme.dart';

/// The rendered ball itself (asset, or the Material glyph fallback when the
/// asset bundle isn't available in tests) — the wrapper is allowed to be
/// stretched by tight constraints, the artwork is not.
Finder ballArtwork() => find.byWidgetPredicate((w) => w is Image || w is Icon);

void main() {
  testWidgets('artwork keeps its size under the tight constraints of a map button', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Center(
          child: SizedBox(
            width: 48,
            height: 48,
            child: Material(
              // Default size (24) — the same one the map control uses.
              child: InkWell(onTap: _noop, child: TifoBallIcon()),
            ),
          ),
        ),
      ),
    );
    expect(tester.getSize(ballArtwork()), const Size(24, 24));
  });

  testWidgets('artwork keeps its size inside a row', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Row(children: [TifoBallIcon(size: 18)])));
    expect(tester.getSize(ballArtwork()), const Size(18, 18));
  });
}

void _noop() {}
