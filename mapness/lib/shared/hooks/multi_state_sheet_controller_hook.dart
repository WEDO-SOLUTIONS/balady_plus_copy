import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sheetify/sheetify.dart';

/// Creates a [MultiStateSheetController] that will be disposed automatically.
///
/// See also:
/// - [MultiStateSheetController]
MultiStateSheetController<T> useMultiStateSheetController<T>({
  required SnappingBehavior behavior,
  required SheetStateMapper<T> mapper,
  T? initialState,
  List<Object?>? keys,
  double? durationMultiplier,
  bool? resetContentScrollOnHiddenState,
}) =>
    use(
      _MultiStateSheetControllerHook<T>(
        keys: keys,
        behavior: behavior,
        mapper: mapper,
        durationMultiplier: durationMultiplier,
        resetContentScrollOnHiddenState: resetContentScrollOnHiddenState,
        initialState: initialState,
      ),
    );

class _MultiStateSheetControllerHook<T> extends Hook<MultiStateSheetController<T>> {
  final SnappingBehavior behavior;
  final SheetStateMapper<T> mapper;
  final double? durationMultiplier;
  final bool? resetContentScrollOnHiddenState;
  final T? initialState;

  const _MultiStateSheetControllerHook({
    required this.behavior,
    required this.mapper,
    this.initialState,
    this.durationMultiplier,
    this.resetContentScrollOnHiddenState,
    List<Object?>? keys,
  }) : super(keys: keys);

  @override
  HookState<MultiStateSheetController<T>, Hook<MultiStateSheetController<T>>> createState() =>
      _MultiStateSheetControllerHookState<T>();
}

class _MultiStateSheetControllerHookState<T>
    extends HookState<MultiStateSheetController<T>, _MultiStateSheetControllerHook<T>> {
  late final controller = MultiStateSheetController<T>(
    durationMultiplier: hook.durationMultiplier ?? 1.0,
    behavior: hook.behavior,
    stateMapper: hook.mapper,
    resetContentScrollOnHiddenState: hook.resetContentScrollOnHiddenState ?? false,
    initialState: hook.initialState,
  );

  @override
  MultiStateSheetController<T> build(BuildContext context) => controller;

  @override
  void dispose() => controller.dispose();

  @override
  String get debugLabel => 'useMultiStateSheetController';
}
