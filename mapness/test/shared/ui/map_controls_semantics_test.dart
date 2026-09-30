import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/shared/ui/map_controls/map_controls_column.dart';
import 'package:sheetify/sheetify.dart';

/// Keeps marking its layout dirty every frame, like a control animating its size (e.g. the compass).
class _Pulsing extends StatefulWidget {
  const _Pulsing();

  @override
  State<_Pulsing> createState() => _PulsingState();
}

class _PulsingState extends State<_Pulsing> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300))..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizeTransition(
    sizeFactor: _controller,
    child: Semantics(button: true, label: 'control', child: const SizedBox.square(dimension: 48)),
  );
}

Widget _controls({required double height}) => Directionality(
  textDirection: TextDirection.ltr,
  child: Align(
    alignment: Alignment.topLeft,
    child: SizedBox(
      height: height,
      child: MapControlsColumn(
        children: [
          MapControlsItem(
            priority: 10,
            child: Semantics(button: true, label: 'low', child: const SizedBox.square(dimension: 48)),
          ),
          MapControlsItem(
            priority: 100,
            slot: MapControlsSlot.bottom,
            child: Semantics(button: true, label: 'high', child: const SizedBox.square(dimension: 48)),
          ),
        ],
      ),
    ),
  ),
);

void main() {
  testWidgets('MapControlsColumn keeps semantics in sync when controls are dropped', (tester) async {
    final semantics = tester.ensureSemantics();

    await tester.pumpWidget(_controls(height: 200));
    // `find.semantics` searches the live semantics tree (a widget finder would also match stale, detached nodes).
    expect(find.semantics.byLabel('low'), findsOne);
    expect(find.semantics.byLabel('high'), findsOne);

    // Only room for one control: the low-priority one is dropped, from semantics too.
    await tester.pumpWidget(_controls(height: 60));
    expect(tester.takeException(), isNull);
    expect(find.semantics.byLabel('low'), findsNothing);
    expect(find.semantics.byLabel('high'), findsOne);

    await tester.pumpWidget(_controls(height: 200));
    expect(find.semantics.byLabel('low'), findsOne);
    semantics.dispose();
  });

  testWidgets('a transparent sheet outside is skipped by semantics while its layout is stale', (tester) async {
    final semantics = tester.ensureSemantics();
    final controller = MultiStateSheetController<ThreeStateSheet>(
      initialState: ThreeStateSheet.open,
      behavior: FractionSnappingBehavior(fractions: {0.1, 0.5, 0.9}),
      stateMapper: const ThreeStateMapper(),
    );
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MultiStateSheet<ThreeStateSheet>(
            scrollController: controller,
            outside: const Align(alignment: Alignment.topLeft, child: _Pulsing()),
            // Fully transparent: the sheet does not lay the outside out at all.
            outsideOpacityDelegate: const StatefulSheetDelegateValue<double>(value: 0),
            content: const [SizedBox(height: 400)],
          ),
        ),
      ),
    );

    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 50));
      expect(tester.takeException(), isNull);
    }
    semantics.dispose();
  });
}
