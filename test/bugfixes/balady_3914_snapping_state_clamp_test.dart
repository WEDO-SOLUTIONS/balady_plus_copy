import 'dart:collection';

import 'package:flutter_test/flutter_test.dart';
import 'package:sheetify/sheetify.dart';

/// BALADY-3914: `snappingOffsets` is a deduplicated `SplayTreeSet` of clamped
/// values, so it can hold fewer entries than the sheet has states (keyboard
/// insets collapse neighbouring snap positions; a POI card without photos
/// registers one offset less than its state enum has entries). `stateToIndex`
/// then produced a negative index and `elementAtOrNull` throws `RangeError`
/// on negative indices — crashing `_RenderMultiStateSheet` layout in release.
void main() {
  SnappingBehavior collapsedBehavior() {
    // 3-state sheet whose distinct snap positions collapsed to 2.
    final behavior = FractionSnappingBehavior<int>(fractions: {0.0, 0.5, 1.0})
      ..avaliableSpace = 600
      ..maxOffset = 600
      ..lastMaxOffset = 600
      ..snappingOffsets = SplayTreeSet.of([0.0, 100.0]);
    return behavior;
  }

  group('BALADY-3914 SnappingBehavior.stateToIndex clamping', () {
    test('state beyond the collapsed offsets maps to the top snap', () {
      final behavior = collapsedBehavior();

      // 2 offsets, state index 2 (`expanded` of a 3-state sheet):
      // length - 1 - state == -1 before the fix -> RangeError.
      expect(behavior.stateToIndex(2), 0);
      expect(behavior.offsetFromState(2), 0.0);
    });

    test('negative state maps to the bottom snap', () {
      final behavior = collapsedBehavior();

      // `indexOf`-style -1 used to map to `length` (out of range the other
      // way); now it clamps to the least expanded position.
      expect(behavior.stateToIndex(-1), 1);
      expect(behavior.offsetFromState(-1), 100.0);
    });

    test('in-range states keep their exact mapping', () {
      final behavior = collapsedBehavior();

      expect(behavior.stateToIndex(0), 1);
      expect(behavior.stateToIndex(1), 0);
      expect(behavior.offsetFromState(0), 100.0);
      expect(behavior.offsetFromState(1), 0.0);
    });

    test('empty offsets still resolve to index 0 and offset 0.0', () {
      final behavior = FractionSnappingBehavior<int>(fractions: {0.0, 1.0})..snappingOffsets = SplayTreeSet();

      expect(behavior.stateToIndex(3), 0);
      expect(behavior.offsetFromState(3), 0.0);
    });
  });
}
