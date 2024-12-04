import 'package:balady_uikit/components.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Creates a [StatefulBottomSheetController] that will be disposed automatically.
///
/// See also:
/// - [StatefulBottomSheetController]
StatefulBottomSheetController useStatefulBottomsheetController({
  required SnappingBehavior behavior,
  required BottomSheetStateMapper mapper,
  initialState,
  List<Object?>? keys,
  double? durationMulitplier,
  bool? resetContentScrollOnHiddenState,
}) =>
    use(
      _StatefulBottomSheetControllerHook(
        keys: keys,
        behavior: behavior,
        mapper: mapper,
        durationMultiplier: durationMulitplier,
        resetContentScrollOnHiddenState: resetContentScrollOnHiddenState,
        initialState: initialState,
      ),
    );

class _StatefulBottomSheetControllerHook extends Hook<StatefulBottomSheetController> {
  final SnappingBehavior behavior;
  final BottomSheetStateMapper mapper;
  final double? durationMultiplier;
  final bool? resetContentScrollOnHiddenState;
  final dynamic initialState;

  const _StatefulBottomSheetControllerHook({
    required this.behavior,
    required this.mapper,
    this.durationMultiplier,
    this.resetContentScrollOnHiddenState,
    this.initialState,
    List<Object?>? keys,
  }) : super(keys: keys);

  @override
  HookState<StatefulBottomSheetController, Hook<StatefulBottomSheetController>> createState() =>
      _StatefulBottomSheetControllerHookState();
}

class _StatefulBottomSheetControllerHookState
    extends HookState<StatefulBottomSheetController, _StatefulBottomSheetControllerHook> {
  late final controller = StatefulBottomSheetController(
    durationMultiplier: hook.durationMultiplier ?? 1.0,
    behavior: hook.behavior,
    stateMapper: hook.mapper,
    resetContentScrollOnHiddenState: hook.resetContentScrollOnHiddenState ?? false,
    initialState: hook.initialState,
  );

  @override
  StatefulBottomSheetController build(BuildContext context) => controller;

  @override
  void dispose() => controller.dispose();

  @override
  String get debugLabel => 'useStatefulBottomSheetController';
}
