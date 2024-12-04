import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/shared/hooks/stateless_botomsheet_controller_hook.dart';
import 'package:mapness/widgets/app_feedback/v2/app_feedback_main.dart';

@RoutePage()
class AppFeedbackSheet extends HookConsumerWidget {
  const AppFeedbackSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useStatelessBottomsheetController(
      onClose: context.router.popForced,
    );

    return StatelessBottomSheet(
      scrollController: scrollController,
      onWillPop: Future.value(false),
      content: [
        AppFeedbackMain(),
        // AppFeedbackLoading(),
        // Padding(
        //   padding: EdgeInsets.symmetric(vertical: 29),
        //   child: AppFeedbackSuccess(),
        // )
        // Padding(
        //   padding: const EdgeInsets.symmetric(vertical: 29),
        //   child: AppFeedbackError(
        //     onRetry: () => context.pop(),
        //   ),
        // ),
      ],
    );
  }
}
