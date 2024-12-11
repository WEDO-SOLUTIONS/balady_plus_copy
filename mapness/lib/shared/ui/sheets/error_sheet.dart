import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/shared/hooks/stateless_botomsheet_controller_hook.dart';
import 'package:mapness/shared/ui/error_widget/base_error_widget.dart';

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

  final BottomSheetOnCloseCallback? onClose;

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
    final scrollController = useStatelessBottomsheetController(
      onClose: (controller) {
        onClose?.call(controller);
      },
      heightModel: BottomSheetHeightModel.aspect(0.35),
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
        StatelessBottomSheet(
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
