import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sheetify/sheetify.dart';

/// Creates a [ToggleSheetController] that will be disposed automatically.
///
/// See also:
/// - [ToggleSheetController]
ToggleSheetController useToggleSheetController({
  ToggleSheetOnCloseCallback? onClose,
  List<Object?>? keys,
  double? durationMultiplier,
  bool isInteractive = true,
  bool clipByHeader = false,
  bool resetContentScrollOnClosed = false,
  ToggleSheetHeightModel? heightModel,
}) =>
    use(
      _ToggleSheetControllerHook(
        keys: keys,
        durationMultiplier: durationMultiplier,
        onClose: onClose,
        resetContentScrollOnClosed: resetContentScrollOnClosed,
        isInteractive: isInteractive,
        heightModel: heightModel,
        clipByHeader: clipByHeader,
      ),
    );

class _ToggleSheetControllerHook extends Hook<ToggleSheetController> {
  final double? durationMultiplier;
  final ToggleSheetOnCloseCallback? onClose;
  final bool isInteractive;
  final ToggleSheetHeightModel? heightModel;
  final bool clipByHeader;
  final bool resetContentScrollOnClosed;

  const _ToggleSheetControllerHook({
    this.onClose,
    this.durationMultiplier,
    this.isInteractive = true,
    this.clipByHeader = false,
    this.resetContentScrollOnClosed = false,
    this.heightModel,
    List<Object?>? keys,
  }) : super(keys: keys);

  @override
  HookState<ToggleSheetController, Hook<ToggleSheetController>> createState() => _ToggleSheetControllerHookState();
}

class _ToggleSheetControllerHookState extends HookState<ToggleSheetController, _ToggleSheetControllerHook> {
  late final controller = hook.onClose == null
      ? ToggleSheetController(
          durationMultiplier: hook.durationMultiplier ?? 1.0,
          isInteractive: hook.isInteractive,
          heightModel: hook.heightModel,
          clipByHeader: hook.clipByHeader,
          resetContentScrollOnClosed: hook.resetContentScrollOnClosed,
          onClose: (c) => c.open(),
        )
      : ToggleSheetController(
          durationMultiplier: hook.durationMultiplier ?? 1.0,
          onClose: hook.onClose,
          isInteractive: hook.isInteractive,
          heightModel: hook.heightModel,
          clipByHeader: hook.clipByHeader,
          resetContentScrollOnClosed: hook.resetContentScrollOnClosed,
        );

  @override
  ToggleSheetController build(BuildContext context) => controller;

  @override
  void dispose() => controller.dispose();

  @override
  String get debugLabel => 'useToggleSheetController';
}
