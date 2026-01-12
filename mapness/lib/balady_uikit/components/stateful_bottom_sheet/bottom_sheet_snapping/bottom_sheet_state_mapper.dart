import 'dart:math';
import 'dart:ui';

import 'package:mapness/balady_uikit/components/stateful_bottom_sheet/models/stateful_sheet_delegate.dart';
import 'package:mapness/balady_uikit/components/stateful_bottom_sheet/stateful_bottom_sheet.dart';

enum ThreeStateBottomSheet {
  /// Displays only the header
  hidden,

  /// Displays header with comfortably visible content
  open,

  /// Take all available space
  expanded,
}

enum FourStateBottomSheet {
  /// Displays only the header
  hidden,

  /// Displays header with a small part of content
  halfOpen,

  /// Displays header with comfortably visible content
  open,

  /// Take all available space
  expanded,
}

/// Base interface to create new state handlers for bottom sheet pages.
abstract interface class BottomSheetStateMapper<T> {
  const BottomSheetStateMapper();

  /// Returns mapped state for a given index.
  T state(int state);

  /// Returns state index for a given state.
  int index(T state);

  /// Controls how bottom sheet should react on `pop` events.
  bool shouldPopOn(StatefulBottomSheetController<T> controller);
}

/// State handler for pages that only have `3` different states.
///
/// Which are described in [ThreeStateBottomSheet] enum.
final class ThreeStateMapper implements BottomSheetStateMapper<ThreeStateBottomSheet> {
  const ThreeStateMapper();

  @override
  ThreeStateBottomSheet state(int state) => switch (state) {
    0 => ThreeStateBottomSheet.hidden,
    1 => ThreeStateBottomSheet.open,
    _ => ThreeStateBottomSheet.expanded,
  };

  @override
  int index(ThreeStateBottomSheet state) => state.index.clamp(0, 2);

  @override
  bool shouldPopOn(StatefulBottomSheetController<ThreeStateBottomSheet> controller) {
    switch (controller.closestState) {
      case ThreeStateBottomSheet.hidden:
        controller.reset();
        return true;

      case ThreeStateBottomSheet.open:
        controller.setState(ThreeStateBottomSheet.hidden);
        return false;

      case ThreeStateBottomSheet.expanded:
        controller.setState(ThreeStateBottomSheet.open);
        return false;
    }
  }
}

/// State handler for pages that only have `4` different states.
///
/// Which are described in [FourStateBottomSheet] enum.
final class FourStateMapper implements BottomSheetStateMapper<FourStateBottomSheet> {
  const FourStateMapper();

  @override
  FourStateBottomSheet state(int state) =>
      FourStateBottomSheet.values.elementAtOrNull(state) ?? FourStateBottomSheet.expanded;

  @override
  int index(FourStateBottomSheet state) => state.index;

  @override
  bool shouldPopOn(StatefulBottomSheetController<FourStateBottomSheet> controller) {
    switch (controller.closestState) {
      case FourStateBottomSheet.hidden:
        controller.reset();
        return true;

      case FourStateBottomSheet.halfOpen:
        controller.setState(FourStateBottomSheet.hidden);
        return false;
      case FourStateBottomSheet.open:
        controller.setState(FourStateBottomSheet.halfOpen);
        return false;

      case FourStateBottomSheet.expanded:
        controller.setState(FourStateBottomSheet.open);
        return false;
    }
  }

  /// Delegate method for calculate background fill color inside bottom sheet.
  static const StatefulSheetDelegateFunction<Color?, FourStateBottomSheet> backgroundColorDelegate =
      StatefulSheetDelegateFunction<Color?, FourStateBottomSheet>(function: _backgroundColorDelegate);

  static Color? _backgroundColorDelegate(StatefulBottomSheetController<FourStateBottomSheet> controller) {
    final state = controller.state;
    final interpolation = controller.interpolation;

    if (state == FourStateBottomSheet.hidden || state == FourStateBottomSheet.expanded) {
      return null;
    }

    const black = Color(0xff000000);
    if (state == FourStateBottomSheet.open) {
      return black.withOpacity(max(0.0, state.index - interpolation * 2 - 1) * 0.7);
    }

    return black.withOpacity((state.index + interpolation - 1) * 0.7);
  }
}

/// A generic state handler for cases where a page can use any number of states.
final class IntStateMapper implements BottomSheetStateMapper<int> {
  const IntStateMapper();

  @override
  int index(int state) => state;

  @override
  bool shouldPopOn(StatefulBottomSheetController<int> controller) {
    final closestState = controller.closestState;
    if (closestState == 0) {
      controller.reset();
      return true;
    } else {
      controller.setState(closestState - 1);
      return false;
    }
  }

  @override
  int state(int state) => state;
}
