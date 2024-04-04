import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/app/routes/iwish.dart';
import 'package:mapness/entities/iwish/models/iwish_entity.dart';
import 'package:mapness/features/iwish/providers/iwish_entity.dart';
import 'package:mapness/features/iwish/providers/iwish_feedback.dart';
import 'package:mapness/features/iwish/providers/iwish_tags.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/ui/buttons/labeled_elevated_button.dart';
import 'package:mapness/shared/ui/sheets/error_sheet.dart';
import 'package:mapness/shared/ui/sheets/labeled_draggable_sheet.dart';
import 'package:mapness/shared/ui/sheets/loading_sheet.dart';
import 'package:mapness/shared/ui/sheets/thanks_sheet.dart';
import 'package:mapness/widgets/iwish/ui/iwish_feedback_mood.dart';
import 'package:mapness/widgets/iwish/ui/iwish_feedback_tags.dart';

class IwishFeedback extends ConsumerStatefulWidget {

  const IwishFeedback({required this.iwishId, super.key});
  final String iwishId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _IwishFeedbackState();
}

class _IwishFeedbackState extends ConsumerState<IwishFeedback> {
  void _toggleTag(String id) =>
      ref.read(iwishFeedbackProvider(widget.iwishId).notifier).toggleTag(id);

  @override
  Widget build(BuildContext context) {
    final entityState = ref.watch(iwishEntityProvider(widget.iwishId));
    final feedbackNotifier =
        ref.watch(iwishFeedbackProvider(widget.iwishId).notifier);
    final feedbackState = ref.watch(iwishFeedbackProvider(widget.iwishId));

    if (entityState.isLoading || feedbackState.isLoading) {
      return LoadingSheet(text: context.l10n.sending);
    }
    if (entityState.hasError || feedbackState.hasError) {
      return ErrorSheet(
        onRetry: feedbackNotifier.submitFeedback,
        buttonLabel: context.l10n.reload,
        onClose: () => context.pop(),
      );
    }

    final entity = entityState.requireValue;
    final feedback = feedbackState.requireValue;
    final isCompleted = entity.state == IwishState.completed;
    final isPlanned = entity.state == IwishState.planned;
    final tags = iwishTags(context.l10n, entity.parkSize);

    if (entity.feedbackSent) {
      Future.delayed(
        const Duration(seconds: 5),
        () {
          if (!mounted) return;
          IwishCardRoute(iwishId: widget.iwishId).replace(context);
        },
      );
      return const ThanksSheet();
    }

    return LabeledDraggableSheet(
      onClose: () => context.pop(),
      title: isCompleted
          ? context.l10n.shareYourFeelingsAboutPark
          : context.l10n.voteWhatDoYouWantToHaveInThePark,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isCompleted)
              IwishFeedbackMood(
                selectedMood: feedback.mood,
                onMoodSelected: feedbackNotifier.updateMood,
              ),
            if (feedback.mood != null || isPlanned) ...[
              const SizedBox(height: 16),
              IwishFeedbackTags(
                tags: tags,
                selectedTags: feedback.tags,
                onTagToggled: _toggleTag,
              ),
              const SizedBox(height: 16),
              Material(
                color: context.color.surfaceBasePrimary,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  onTap: () =>
                      IwishFeedbackCommentRoute(iwishId: widget.iwishId)
                          .replace(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    child: Builder(builder: (context) {
                      final textStyle =
                          Theme.of(context).extension<ThemeTextStyles>()!.text;
                      final color =
                          feedback.comment == null || feedback.comment!.isEmpty
                              ? context.color.textAndIconsBaseTertiary
                              : context.color.textAndIconsBasePrimary;
                      final style = textStyle.copyWith(color: color);
                      final text =
                          feedback.comment ?? context.l10n.shareYourFeedback;

                      return Text(
                        text,
                        style: style,
                        overflow: TextOverflow.ellipsis,
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              LabeledElevatedButton(
                onPressed: () async {
                  await CommonFunctions.authOrOpen(context, callback: feedbackNotifier.submitFeedback,);
                },
                label: context.l10n.sendFeedback,
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
