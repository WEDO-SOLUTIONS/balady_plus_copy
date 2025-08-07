import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/shared/hooks/toggle_sheet_controller_hook.dart';
import 'package:mapness/shared/ui/error_widget/base_error_widget.dart';
import 'package:sheetify/sheetify.dart';

class ErrorSheetWidget extends HookConsumerWidget {
  /// action how to recover state
  final VoidCallback onRetry;

  /// button label (localized default: reload)
  final String? buttonLabel;

  /// error label (localized default: somethingWentWrong)
  final String? errorLabel;

  /// Add barrier to bottom sheet background
  final bool hasBarrier;

  /// Called on background barrier tap (cause not always context.pop is not enough)
  final VoidCallback? onBarrierTap;

  final ToggleSheetOnCloseCallback? onClose;

  const ErrorSheetWidget({
    required this.onRetry,
    this.buttonLabel,
    this.errorLabel,
    this.onClose,
    this.hasBarrier = false,
    this.onBarrierTap,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useToggleSheetController(
      onClose: (controller) {
        onClose?.call(controller);
      },
      heightModel: ToggleSheetHeightModel.fraction(0.35),
    );
    return Stack(
      children: [
        if (hasBarrier)
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                if (onBarrierTap != null) {
                  onBarrierTap!.call();
                } else {
                  context.router.popForced();
                }
              },
              child: ColoredBox(
                color: context.color.surfaceOverlayModal,
              ),
            ),
          ),
        ToggleSheet(
          backgroundColor: context.colors.backgroundSurface1,
          safeAreaColor: context.colors.backgroundSurface1,
          dragger: const SheetDragger(),
          content: [
            BaseErrorWidget(
              onRetry: onRetry,
              buttonLabel: buttonLabel,
              errorLabel: errorLabel,
            ),
          ],
          scrollController: scrollController,
        ),
      ],
    );
  }
}
