import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/entities/app_feedback/feedback_source.dart';
import 'package:mapness/features/app_feedback/app_feedback_canpop.dart';
import 'package:mapness/features/app_feedback/app_feedback_source_provider.dart';
import 'package:mapness/features/app_feedback/send_feedback.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/stateless_botomsheet_controller_hook.dart';
import 'package:mapness/shared/ui/safe_area_padding.dart';
import 'package:mapness/widgets/app_feedback/app_feedback_error.dart';
import 'package:mapness/widgets/app_feedback/app_feedback_loading.dart';
import 'package:mapness/widgets/app_feedback/app_feedback_success.dart';
import 'package:mapness/widgets/app_feedback/v2/app_feedback_main.dart';

@RoutePage()
class AppFeedbackSheet extends HookConsumerWidget {
  final int? initialRating;
  final FeedbackSource source;

  const AppFeedbackSheet({
    this.initialRating,
    this.source = const FeedbackSource.main(),
    super.key,
  });

  void _showConfirmDialog(BuildContext context) {
    if (!context.mounted) {
      return;
    }
    showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
              title: Text(context.l10n.appFeedbackUnsavedChanges),
              content: Text(context.l10n.appFeedbackIfYouGoBackNowYourTextWillBeLostAreYouSureYouWantToLeave),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text(context.l10n.appFeedbackStay),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                ),
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  child: Text(context.l10n.appFeedbackLeave),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    context.router.popForced();
                  },
                ),
              ],
            ));
  }
  static const _sheetPadding =  EdgeInsets.only(top: Spacing.$6x);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sendFeedbackState = ref.watch(sendFeedbackProvider);

    ref.watch(appFeedbackCanPopProvider.select((_) => null));

    void onCloseBottomSheet(StatelessBottomSheetController controller) {
      final feedbackCanpop = ref.read(appFeedbackCanPopProvider);
      final isInitial = ref.read(sendFeedbackProvider).valueOrNull == AppFeedbackState.initial;

      if (feedbackCanpop || !isInitial) {
        context.router.popForced();
      } else {
        controller.open();
        _showConfirmDialog(context);
      }
    }

    final scrollController = useStatelessBottomsheetController(onClose: onCloseBottomSheet);
    final backgroundColorDelegate = StatelessSheetDelegateFunction<Color?>(
      function: (controller) => AppColor.black.withOpacity(0.4 * (1 - controller.interpolation)),
    );
    final backgroundColor = context.colorsV3.backgroundSurface4;

    return FeedbackSourceProvider(
      source: source,
      child: SafeAreaPadding(
        bottom: false,
        child: StatelessBottomSheet(
          scrollController: scrollController,
          safeAreaColor: context.colorsV3.backgroundSurface1,
          backgroundColor: backgroundColor,
          draggerColor: backgroundColor,
          startConfig: BottomSheetStart.instant,
          onWillPop: Future.value(source is FeedbackSourceOffer),
          backgroundColorDelegate: source is FeedbackSourceOffer ? backgroundColorDelegate : null,
          content: [
            sendFeedbackState.when(
              data: (data) => switch (data) {
                AppFeedbackState.initial => AppFeedbackMain(
                    initialRating: initialRating,
                    onNeedPopConfirm: source is! FeedbackSourceOffer ? () => _showConfirmDialog(context) : null,
                  ),
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
              error: (_, __) => Padding(
                padding: _sheetPadding,
                child: AppFeedbackError(
                  onRetry: ref.read(sendFeedbackProvider.notifier).retry,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
