import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/toggle_sheet_controller_hook.dart';
import 'package:mapness/widgets/app_feedback/app_feedback_input.dart';
import 'package:mapness/widgets/app_feedback/v2/app_feedback_sheet_header.dart';
import 'package:sheetify/sheetify.dart';

@RoutePage()
class AppFeedbackInputSheet extends HookConsumerWidget {
  final String initialText;
  final int maxCharsAllowed;

  const AppFeedbackInputSheet({
    super.key,
    this.initialText = '',
    this.maxCharsAllowed = 1000,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useToggleSheetController(
      onClose: (controller) {
        context.router.popForced();
      },
      heightModel: ToggleSheetHeightModel.fraction(.98),
    );

    final textEditingController = useTextEditingController(text: initialText);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: ToggleSheet(
        scrollController: scrollController,
        backgroundColor: context.colors.backgroundSurface4,
        safeAreaColor: context.colors.backgroundSurface4,
        dragger: SheetDragger(backgroundColor: context.colors.backgroundSurface4),
        shouldPop: (_) => false,
        header: AppFeedbackSheetHeader(
          onBackTap: context.router.popForced,
          title: context.l10n.appFeedbackInputTitle,
        ),
        content: [
          AppFeedbackInput(
            textController: textEditingController,
            textInputAction: TextInputAction.go,
            maxCharsAllowed: maxCharsAllowed,
          ),
        ],
        footer: Padding(
          padding: const EdgeInsets.all(Spacing.$4x).copyWith(
            bottom: Spacing.$8x,
          ),
          child: SizedBox(
            width: double.infinity,
            child: ListenableBuilder(
              listenable: textEditingController,
              builder: (context, child) => AppButton(
                primaryLabel: context.l10n.appFeedbackAddNote,
                buttonColorScheme: ButtonColorScheme.accentSecondary,
                buttonState: textEditingController.text.length > maxCharsAllowed
                    ? ButtonState.disabled
                    : ButtonState.defaultState,
                size: ButtonSize.large,
                onTap: () {
                  context.router.popForced(textEditingController.text);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
