
import 'package:flutter/material.dart';
import 'package:mapness/balady_uikit/components/stateful_bottom_sheet/bottom_sheet_animate_components/bottom_sheet_state_notifier.dart';

/// A function type used to build animated bottom sheet components.
///
/// - [context]: The [BuildContext] for the widget.
/// - [state]: The current state of the bottom sheet.
/// - [interpolation]: A value between `0.0` and `1.0` representing the animation progress.
/// - [child]: An optional child widget to optimize builds.
typedef BottomSheetComponentBuilder<StateType> = Widget Function(
  BuildContext context,
  StateType state,
  double interpolation,
  Widget? child,
);

/// A widget that builds a bottom sheet component based on a given builder function.
///
/// This widget simplifies the creation of animated bottom sheet components by
/// delegating the build logic to a [BottomSheetComponentBuilder].
final class BottomSheetStateBuilder<StateType> extends BottomSheetStateComponent<StateType> {
  /// Constructs a [BottomSheetStateBuilder].
  ///
  /// - [builder]: The function responsible for building the component based on the
  ///   current state and animation progress.
  /// - [defaultState]: The initial or fallback state for the bottom sheet.
  /// - [child]: An optional child widget for optimized builds.
  const BottomSheetStateBuilder({
    required BottomSheetComponentBuilder<StateType> builder,
    required super.defaultState,
    super.key,
    Widget? child,
  })  : _builder = builder,
        _child = child;

  /// The builder function for creating the bottom sheet component.
  final BottomSheetComponentBuilder<StateType> _builder;

  /// An optional child widget for optimized builds.
  final Widget? _child;

  @override
  Widget build(
    BuildContext context,
    StateType state,
    double interpolation,
  ) =>
      _builder(context, state, interpolation, _child);
}

/// A base class for creating stateless animated components in a bottom sheet.
///
/// This class provides a structure for building bottom sheet components that
/// respond to state changes and animations.
abstract class BottomSheetStateComponent<StateType> extends BottomSheetStateComponentStatefulWidget {
  /// The default state used when no state is available.
  final StateType defaultState;

  /// Constructs a [BottomSheetStateComponent].
  ///
  /// - [defaultState]: The initial or fallback state for the component.
  const BottomSheetStateComponent({required this.defaultState, super.key});

  /// Builds the widget based on the current state and animation interpolation.
  ///
  /// - [context]: The [BuildContext] for the widget.
  /// - [state]: The current state of the bottom sheet.
  /// - [interpolation]: A value between `0.0` and `1.0` representing the animation progress.
  Widget build(
    BuildContext context,
    StateType state,
    double interpolation,
  );

  @override
  _BottomSheetComponentState<StateType> createState() => _BottomSheetComponentState<StateType>();
}

/// The state for a stateful bottom sheet component.
///
/// This class provides the context to access the bottom sheet's current state and interpolation.
class _BottomSheetComponentState<StateType> extends BottomSheetComponentState<BottomSheetStateComponent<StateType>> {
  @override
  Widget build(BuildContext context) {
    final state = BottomSheetStateNotifier.of<StateType>(context);

    return widget.build(
      context,
      state?.state ?? widget.defaultState, // Use the notifier's state or fallback to the default.
      state?.stateInterpolation ?? 0.0, // Default interpolation is `0.0` when unavailable.
    );
  }
}

/// A base class for creating stateful bottom sheet animated widgets.
///
/// This class serves as the foundation for all animated widgets that interact with
/// the bottom sheet's state and respond to state changes.
abstract class BottomSheetStateComponentStatefulWidget extends StatefulWidget {
  const BottomSheetStateComponentStatefulWidget({super.key});

  @override
  BottomSheetComponentState createState();
}

/// A base class for the state of bottom sheet animated widgets.
///
/// This class provides the structure for managing the state of animated widgets
/// in the bottom sheet and allows access to the widget instance.
abstract class BottomSheetComponentState<T extends BottomSheetStateComponentStatefulWidget> extends State<T> {}
