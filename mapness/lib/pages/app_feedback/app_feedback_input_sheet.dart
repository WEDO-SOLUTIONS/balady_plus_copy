import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/src/components/stateless_bottom_sheet/bottom_sheet_height_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/stateless_botomsheet_controller_hook.dart';
import 'package:mapness/widgets/app_feedback/app_feedback_input.dart';
import 'package:mapness/widgets/app_feedback/v2/app_feedback_sheet_header.dart';

@RoutePage()
class AppFeedbackInputSheet extends HookConsumerWidget {
  final String initalText;
  const AppFeedbackInputSheet({super.key, this.initalText = ''});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useStatelessBottomsheetController(
      onClose: (controller) {
        context.router.popForced();
      },
      heightModel: BottomSheetHeightModel.aspect(0.9),
    );

    final textEditingController = useTextEditingController(text: initalText);

    return StatelessBottomSheet(
      scrollController: scrollController,
      header: AppFeedbackSheetHeader(
        onBackTap: context.router.popForced,
        title: context.l10n.appFeedbackInputTitle,
      ),
      content: [
        AppFeedbackInput(
          textController: textEditingController,
        ),
      ],
      footer: Padding(
        padding: const EdgeInsets.all(Spacing.$4x).copyWith(bottom: Spacing.$8x),
        child: SizedBox(
          width: double.infinity,
          child: AppButton(
            primaryLabel: context.l10n.appFeedbackAddNote,
            buttonColorScheme: ButtonColorScheme.primary,
            onTap: () {
              context.router.popForced(textEditingController.text);
            },
          ),
        ),
      ),
    );
  }
}
