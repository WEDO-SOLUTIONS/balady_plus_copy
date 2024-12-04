import 'package:balady_uikit/components.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Creates a [StatelessBottomSheetController] that will be disposed automatically.
///
/// See also:
/// - [StatelessBottomSheetController]
StatelessBottomSheetController useStatelessBottomsheetController({
  required BottomSheetOnCloseCallback onClose,
  List<Object?>? keys,
  double? durationMultiplier,
}) =>
    use(
      _StatelessBottomSheetControllerHook(
        keys: keys,
        durationMultiplier: durationMultiplier,
        onClose: onClose,
      ),
    );

class _StatelessBottomSheetControllerHook extends Hook<StatelessBottomSheetController> {
  final double? durationMultiplier;
  final BottomSheetOnCloseCallback onClose;

  const _StatelessBottomSheetControllerHook({
    required this.onClose,
    this.durationMultiplier,
    List<Object?>? keys,
  }) : super(keys: keys);

  @override
  HookState<StatelessBottomSheetController, Hook<StatelessBottomSheetController>> createState() =>
      _StatelessBottomSheetControllerHookState();
}

class _StatelessBottomSheetControllerHookState
    extends HookState<StatelessBottomSheetController, _StatelessBottomSheetControllerHook> {
  late final controller = StatelessBottomSheetController(
    durationMultiplier: hook.durationMultiplier ?? 1.0,
    onClose: hook.onClose,
  );

  @override
  StatelessBottomSheetController build(BuildContext context) => controller;

  @override
  void dispose() => controller.dispose();

  @override
  String get debugLabel => 'useStatelessBottomSheetController';
}
