import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sheetify/sheetify.dart';

/// BALADY-3958: the BALADY-3978 bug in `ToggleSheet` — a transparent `outside` was not laid out, so a relayout
/// inside it (map controls dropping or fading out as the sheet grows) stayed dirty under the sheet. With semantics
/// enabled it surfaced as `!childSemantics.renderObject._needsLayout` in the semantics flush.
void main() {
  Future<void> pumpSheet(
    WidgetTester tester, {
    required ToggleSheetController controller,
    required ValueNotifier<bool> outsideVisible,
    required ValueNotifier<double> outsideHeight,
  }) => tester.pumpWidget(
    MaterialApp(
      home: ToggleSheet(
        scrollController: controller,
        startConfig: ToggleSheetStart.instant,
        useSafeArea: false,
        outsideOpacityDelegate: ToggleSheetDelegateFunction<double>(function: (_) => outsideVisible.value ? 1 : 0),
        outside: Align(
          alignment: Alignment.topCenter,
          child: ValueListenableBuilder<double>(
            valueListenable: outsideHeight,
            builder: (context, height, _) => Semantics(
              button: true,
              label: 'control',
              child: SizedBox(key: const ValueKey('outside'), width: 40, height: height),
            ),
          ),
        ),
        content: const [SizedBox(height: 400)],
      ),
    ),
  );

  testWidgets('BALADY-3958 relayout inside a ToggleSheet outside that turned transparent', (tester) async {
    final semantics = tester.ensureSemantics();
    final controller = ToggleSheetController();
    addTearDown(controller.dispose);
    final outsideVisible = ValueNotifier<bool>(true);
    addTearDown(outsideVisible.dispose);
    final outsideHeight = ValueNotifier<double>(40);
    addTearDown(outsideHeight.dispose);

    await pumpSheet(tester, controller: controller, outsideVisible: outsideVisible, outsideHeight: outsideHeight);
    await tester.pumpAndSettle();
    // `outside` has been laid out while visible, so it sits under the sheet's relayout boundary.
    expect(tester.renderObject<RenderBox>(find.byKey(const ValueKey('outside'))).hasSize, isTrue);

    // The next sheet layout reads the opacity as 0.
    outsideVisible.value = false;
    outsideHeight.value = 50;
    await tester.pump();

    // Relayouts inside the now transparent `outside`; the second one used to hit the assert.
    outsideHeight.value = 60;
    await tester.pump();
    outsideHeight.value = 80;
    await tester.pump();

    expect(tester.takeException(), isNull);
    semantics.dispose();
  });

  testWidgets('BALADY-3958 relayout inside a ToggleSheet outside that is transparent from the start', (tester) async {
    final semantics = tester.ensureSemantics();
    final controller = ToggleSheetController();
    addTearDown(controller.dispose);
    final outsideVisible = ValueNotifier<bool>(false);
    addTearDown(outsideVisible.dispose);
    final outsideHeight = ValueNotifier<double>(40);
    addTearDown(outsideHeight.dispose);

    await pumpSheet(tester, controller: controller, outsideVisible: outsideVisible, outsideHeight: outsideHeight);
    await tester.pumpAndSettle();

    outsideHeight.value = 60;
    await tester.pump();
    outsideHeight.value = 80;
    await tester.pump();

    expect(tester.takeException(), isNull);
    semantics.dispose();
  });
}
