import 'package:balady_uikit/components.dart';
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
import 'package:mapness/shared/ui/sheets/loading_thanks_sheet.dart';
import 'package:mapness/widgets/iwish/ui/iwish_feedback_mood.dart';
import 'package:mapness/widgets/iwish/ui/iwish_feedback_tags.dart';

class IwishFeedback extends ConsumerStatefulWidget {
  final String iwishId;
  final VoidCallback onFeedbackSent;

  const IwishFeedback({
    required this.iwishId,
    required this.onFeedbackSent,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _IwishFeedbackState();
}

class _IwishFeedbackState extends ConsumerState<IwishFeedback> {
  void _toggleTag(String id) => ref.read(iwishFeedbackProvider(widget.iwishId).notifier).toggleTag(id);

  @override
  Widget build(BuildContext context) {
    final entityState = ref.watch(iwishEntityProvider(widget.iwishId));
    final feedbackNotifier = ref.watch(iwishFeedbackProvider(widget.iwishId).notifier);
    final feedbackState = ref.watch(iwishFeedbackProvider(widget.iwishId));

    final hasError = entityState.hasError || feedbackState.hasError;
    if (hasError) {
      return ErrorSheet(
        onRetry: feedbackNotifier.submitFeedback,
        buttonLabel: context.l10n.reload,
        onClose: () => context.pop(),
      );
    }

    final isLoading = entityState.isLoading || feedbackState.isLoading;
    final didSentFeedback = entityState.value?.feedbackSent ?? false;
    final isFeedbackComplited = entityState.value?.state == IwishState.completed;
    final isSetMood = feedbackState.valueOrNull?.mood != null;
    final hasFeedback = entityState.hasValue && entityState.requireValue.feedbackSent;

    if (isLoading && (!didSentFeedback || !isSetMood) && !isFeedbackComplited) {
      return const Align(
        alignment: Alignment.bottomCenter,
        child: LoadingSheet(),
      );
    }

    if (feedbackState.isLoading || hasFeedback) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 24.0, left: 16.0, right: 16.0),
          child: LoadingThanksSheet(
            isLoading: entityState.isLoading || feedbackState.isLoading,
            onComplete: widget.onFeedbackSent,
            showValuableOpinionMessage: true,
            triggerOnComplete: feedbackState.valueOrNull?.mood == IwishFeedbackMoodType.happy,
            onClose: () {
              if (mounted) {
                IwishCardRoute(iwishId: widget.iwishId).replace(context);
              }
            },
          ),
        ),
      );
    }

    final entity = entityState.requireValue;
    final feedback = feedbackState.requireValue;
    final isCompleted = entity.state == IwishState.completed;
    final isPlanned = entity.state == IwishState.planned;
    final tags = iwishTags(context.l10n, entity.parkSize);

    final title = isCompleted ? context.l10n.shareYourFeelingsAboutPark : context.l10n.voteWhatDoYouWantToHaveInThePark;
    final onPressedSubmit = () async {
      await CommonFunctions.authOrOpen(
        context,
        callback: feedbackNotifier.submitFeedback,
      );
    };

    return LabeledDraggableSheet(
      onClose: context.pop,
      title: title,
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
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
                BaladyInput(
                  hintText: context.l10n.shareYourFeedback,
                  initialValue: feedbackState.value?.comment ?? feedback.comment,
                  onTap: () => IwishFeedbackCommentRoute(iwishId: widget.iwishId).replace(context),
                ),
                const SizedBox(height: 16),
                LabeledElevatedButton(
                  onPressed: onPressedSubmit,
                  label: context.l10n.sendFeedback,
                ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
