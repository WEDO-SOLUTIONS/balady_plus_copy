import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/features/app_feedback/collect_feedback.dart';
import 'package:mapness/features/app_feedback/send_feedback.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/app_feedback/app_feedback_error.dart';
import 'package:mapness/widgets/app_feedback/app_feedback_input.dart';
import 'package:mapness/widgets/app_feedback/app_feedback_success.dart';

@RoutePage()
class AppFeedbackPage extends HookConsumerWidget {
  const AppFeedbackPage({super.key});

  void _showConfirmDialog(BuildContext context) {
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isValid = useState<bool>(false);
    final isBackConfirmation = useState<bool>(false);
    final textController = useTextEditingController();

    final feedbackState = ref.watch(sendFeedbackProvider);

    void backConfirmation() {
      if (textController.text.isNotEmpty) {
        isBackConfirmation.value = true;
      }
    }

    useEffect(() {
      textController.addListener(backConfirmation);
      return () => textController.removeListener(backConfirmation);
    }, [textController]);

    final isControlEnabled = feedbackState.valueOrNull == null ||
        feedbackState.maybeWhen(
          data: (data) => data == AppFeedbackState.initial,
          error: (_, __) => true,
          orElse: () => false,
        );

    final isSuccess = feedbackState.maybeWhen(
      data: (data) => data == AppFeedbackState.success,
      orElse: () => false,
    );

    final isErrorState = feedbackState.maybeWhen(
      error: (_, __) => true,
      orElse: () => false,
    );

    return ValueListenableBuilder<bool>(
      key: ValueKey(feedbackState.valueOrNull ?? 'initial'),
      valueListenable: isValid,
      builder: (context, isValidValue, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: ValueListenableBuilder(
            valueListenable: isBackConfirmation,
            builder: (context, isBackConfirmationValue, _) => PopScope(
                  onPopInvokedWithResult: (didPop, _) {
                    // Show ios alert dialog with title = Unsaved Changes
                    // subtitle = If you go back now, your text will be lost. Are you sure you want to leave?
                    // actions = [Stay, Leave]

                    if (!didPop) {
                      _showConfirmDialog(context);
                    }
                  },
                  canPop: false,
                  child: Scaffold(
                    backgroundColor: context.colorsV2.backgroundScreen,
                    appBar: BaladyTopBar.iconAndText(
                      title: isControlEnabled && !isErrorState ? context.l10n.appFeedbackShareFeedback : null,
                      leading: isSuccess
                          ? null
                          : ActionModel(
                              icon: SystemIcons.arrowCornerLeftLarge,
                              onPressed: () {
                                if (isBackConfirmationValue && textController.text.isNotEmpty) {
                                  _showConfirmDialog(context);
                                } else {
                                  context.router.popForced();
                                }
                              },
                            ),
                      trailing: isControlEnabled && !isErrorState
                          ? ActionModel(
                              text: context.l10n.send,
                              isEnabled: isValidValue,
                              onPressed: !isValidValue
                                  ? null
                                  : () async {
                                      await ref.read(collectFeedbackProvider.notifier).collectFeedback(
                                            textController.text,
                                          );

                                      await ref.read(sendFeedbackProvider.notifier).sendFeedback();
                                    },
                            )
                          : null,
                      colorEnabled: context.colorsV2.accentDefault,
                      colorDisabled: context.colorsV2.foregroundMuted,
                      key: ValueKey(isValidValue),
                    ),
                    body: feedbackState.when(
                      loading: () => Center(
                        child: Loading(
                          orientation: Axis.vertical,
                          size: LoaderSize.large,
                          color: context.colorsV2.accentDefault,
                          title: context.l10n.loading,
                        ),
                      ),
                      data: (data) => switch (data) {
                        AppFeedbackState.initial => AppFeedbackInput(
                            isValid: (v) => isValid.value = v,
                            textController: textController,
                          ),
                        AppFeedbackState.loading => Center(
                            child: Loading(
                              size: LoaderSize.large,
                              color: context.colorsV2.accentDefault,
                              title: context.l10n.loading,
                            ),
                          ),
                        AppFeedbackState.success => const AppFeedbackSuccess(),
                      },
                      error: (error, stackTrace) => AppFeedbackError(
                        onRetry: () {
                          ref.read(sendFeedbackProvider.notifier).sendFeedback();
                        },
                      ),
                    ),
                  ),
                )),
      ),
    );
  }
}
