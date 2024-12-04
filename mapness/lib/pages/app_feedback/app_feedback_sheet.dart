import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/features/app_feedback/app_feedback_canpop.dart';
import 'package:mapness/features/app_feedback/send_feedback.dart';
import 'package:mapness/shared/hooks/stateless_botomsheet_controller_hook.dart';
import 'package:mapness/widgets/app_feedback/app_feedback_error.dart';
import 'package:mapness/widgets/app_feedback/app_feedback_loading.dart';
import 'package:mapness/widgets/app_feedback/app_feedback_success.dart';
import 'package:mapness/widgets/app_feedback/v2/app_feedback_main.dart';

@RoutePage()
class AppFeedbackSheet extends HookConsumerWidget {
  const AppFeedbackSheet({super.key});

  static const _sheetPadding = EdgeInsets.symmetric(vertical: 29);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sendFeedbackState = ref.watch(sendFeedbackProvider);

    ref.watch(appFeedbackCanPopProvider);

    void onCloseBottomSheet(StatelessBottomSheetController controller) {
      final feedbackCanpop = ref.read(appFeedbackCanPopProvider);
      if (feedbackCanpop) {
        context.router.popForced();
      } else {
        controller.open();
      }
    }

    final scrollController = useStatelessBottomsheetController(onClose: onCloseBottomSheet);

    return StatelessBottomSheet(
      animateOpening: false,
      scrollController: scrollController,
      onWillPop: Future.value(false),
      content: [
        sendFeedbackState.when(
          data: (data) => switch (data) {
            AppFeedbackState.initial => const AppFeedbackMain(),
            AppFeedbackState.loading => const AppFeedbackLoading(),
            AppFeedbackState.success => const Padding(
                padding: _sheetPadding,
                child: AppFeedbackSuccess(),
              ),
            AppFeedbackState.error => Padding(
                padding: _sheetPadding,
                child: AppFeedbackError(
                  onRetry: ref.read(sendFeedbackProvider.notifier).retry,
                ),
              ),
          },
          loading: () => const AppFeedbackLoading(),
          error: (error, _) => Padding(
            padding: _sheetPadding,
            child: AppFeedbackError(
              onRetry: ref.read(sendFeedbackProvider.notifier).retry,
            ),
          ),
        ),
      ],
    );
  }
}
