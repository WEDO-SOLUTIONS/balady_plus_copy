import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheetify/sheetify.dart';

/// BALADY-3978: the sheet skipped laying out a transparent `outside`, so a relayout
/// inside it stayed dirty under the clean sheet and the next one tripped
/// `_debugRelayoutBoundaryAlreadyMarkedNeedsLayout`.
void main() {
  testWidgets('BALADY-3978 relayout inside a transparent sheet outside', (tester) async {
    final controller = MultiStateSheetController<ThreeStateSheet>(
      behavior: FractionSnappingBehavior(fractions: {0.0, 0.5, 1.0}),
      stateMapper: const ThreeStateMapper(),
      initialState: ThreeStateSheet.open,
    );
    addTearDown(controller.dispose);
    final outsideHeight = ValueNotifier<double>(40);
    addTearDown(outsideHeight.dispose);
    // Same shape as the dashboard: controls fade out once the sheet is expanded.
    final outsideOpacity = StatefulSheetDelegateFunction<double, ThreeStateSheet>(
      function: (controller) => controller.state == ThreeStateSheet.expanded ? 0 : 1,
    );
    const outsideKey = ValueKey('outside');

    await tester.pumpWidget(
      MaterialApp(
        home: MultiStateSheet<ThreeStateSheet>(
          scrollController: controller,
          animateOpening: false,
          useSafeArea: false,
          outsideOpacityDelegate: outsideOpacity,
          outside: Align(
            alignment: Alignment.topCenter,
            child: ValueListenableBuilder<double>(
              valueListenable: outsideHeight,
              builder: (context, height, _) => SizedBox(key: outsideKey, width: 40, height: height),
            ),
          ),
          content: const [SizedBox(height: 2000)],
        ),
      ),
    );
    await tester.pumpAndSettle();
    // `outside` has been laid out while visible, so it sits under the sheet's relayout boundary.
    expect(tester.renderObject<RenderBox>(find.byKey(outsideKey)).hasSize, isTrue);

    controller.setState(ThreeStateSheet.expanded);
    await tester.pumpAndSettle();
    expect(controller.state, ThreeStateSheet.expanded);

    // First relayout dirties `outside`; the second one used to hit the assert.
    outsideHeight.value = 60;
    await tester.pump();
    outsideHeight.value = 80;
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}
