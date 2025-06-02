import 'package:balady_uikit/components.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Creates a [StatelessBottomSheetController] that will be disposed automatically.
///
/// See also:
/// - [StatelessBottomSheetController]
StatelessBottomSheetController useStatelessBottomsheetController({
  BottomSheetOnCloseCallback? onClose,
  List<Object?>? keys,
  double? durationMultiplier,
  bool isInteractive = true,
  bool clipByHeader = false,
  bool resetContentScrollOnClosed = false,
  BottomSheetHeightModel? heightModel,
}) =>
    use(
      _StatelessBottomSheetControllerHook(
        keys: keys,
        durationMultiplier: durationMultiplier,
        onClose: onClose,
        resetContentScrollOnClosed: resetContentScrollOnClosed,
        isInteractive: isInteractive,
        heightModel: heightModel,
        clipByHeader: clipByHeader,
      ),
    );

class _StatelessBottomSheetControllerHook extends Hook<StatelessBottomSheetController> {
  final double? durationMultiplier;
  final BottomSheetOnCloseCallback? onClose;
  final bool isInteractive;
  final BottomSheetHeightModel? heightModel;
  final bool clipByHeader;
  final bool resetContentScrollOnClosed;

  const _StatelessBottomSheetControllerHook({
    this.onClose,
    this.durationMultiplier,
    this.isInteractive = true,
    this.clipByHeader = false,
    this.resetContentScrollOnClosed = false,
    this.heightModel,
    List<Object?>? keys,
  }) : super(keys: keys);

  @override
  HookState<StatelessBottomSheetController, Hook<StatelessBottomSheetController>> createState() =>
      _StatelessBottomSheetControllerHookState();
}

class _StatelessBottomSheetControllerHookState
    extends HookState<StatelessBottomSheetController, _StatelessBottomSheetControllerHook> {
  late final controller = hook.onClose == null
      ? StatelessBottomSheetController(
          durationMultiplier: hook.durationMultiplier ?? 1.0,
          isInteractive: hook.isInteractive,
          heightModel: hook.heightModel,
          clipByHeader: hook.clipByHeader,
          resetContentScrollOnClosed: hook.resetContentScrollOnClosed,
        )
      : StatelessBottomSheetController(
          durationMultiplier: hook.durationMultiplier ?? 1.0,
          onClose: hook.onClose!,
          isInteractive: hook.isInteractive,
          heightModel: hook.heightModel,
          clipByHeader: hook.clipByHeader,
          resetContentScrollOnClosed: hook.resetContentScrollOnClosed,
        );

  @override
  StatelessBottomSheetController build(BuildContext context) => controller;

  @override
  void dispose() => controller.dispose();

  @override
  String get debugLabel => 'useStatelessBottomSheetController';
}
