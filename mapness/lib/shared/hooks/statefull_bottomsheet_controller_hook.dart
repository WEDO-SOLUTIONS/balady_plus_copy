import 'package:balady_uikit/components.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Creates a [StatefulBottomSheetController] that will be disposed automatically.
///
/// See also:
/// - [StatefulBottomSheetController]
StatefulBottomSheetController<T> useStatefulBottomsheetController<T>({
  required SnappingBehavior behavior,
  required BottomSheetStateMapper<T> mapper,
  T? initialState,
  List<Object?>? keys,
  double? durationMultiplier,
  bool? resetContentScrollOnHiddenState,
}) =>
    use(
      _StatefulBottomSheetControllerHook<T>(
        keys: keys,
        behavior: behavior,
        mapper: mapper,
        durationMultiplier: durationMultiplier,
        resetContentScrollOnHiddenState: resetContentScrollOnHiddenState,
        initialState: initialState,
      ),
    );

class _StatefulBottomSheetControllerHook<T> extends Hook<StatefulBottomSheetController<T>> {
  final SnappingBehavior behavior;
  final BottomSheetStateMapper<T> mapper;
  final double? durationMultiplier;
  final bool? resetContentScrollOnHiddenState;
  final T? initialState;

  const _StatefulBottomSheetControllerHook({
    required this.behavior,
    required this.mapper,
    this.initialState,
    this.durationMultiplier,
    this.resetContentScrollOnHiddenState,
    List<Object?>? keys,
  }) : super(keys: keys);

  @override
  HookState<StatefulBottomSheetController<T>, Hook<StatefulBottomSheetController<T>>> createState() =>
      _StatefulBottomSheetControllerHookState<T>();
}

class _StatefulBottomSheetControllerHookState<T>
    extends HookState<StatefulBottomSheetController<T>, _StatefulBottomSheetControllerHook<T>> {
  late final controller = StatefulBottomSheetController<T>(
    durationMultiplier: hook.durationMultiplier ?? 1.0,
    behavior: hook.behavior,
    stateMapper: hook.mapper,
    resetContentScrollOnHiddenState: hook.resetContentScrollOnHiddenState ?? false,
    initialState: hook.initialState,
  );

  @override
  StatefulBottomSheetController<T> build(BuildContext context) => controller;

  @override
  void dispose() => controller.dispose();

  @override
  String get debugLabel => 'useStatefulBottomSheetController';
}
