import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/app_feedback/app_feedback_payload.dart';
import 'package:mapness/entities/app_feedback/app_feedback_tag_mapper.dart';
import 'package:mapness/features/app_feedback/app_feedback_canpop.dart';
import 'package:mapness/features/app_feedback/app_feedback_source_provider.dart';
import 'package:mapness/features/app_feedback/collect_feedback.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/buttons/app_close_button.dart';
import 'package:mapness/widgets/app_feedback/v2/rating_bar.dart';
import 'package:mapness/widgets/app_feedback/v2/tag_cloud.dart';

class AppFeedbackMain extends HookConsumerWidget {
  final int? initialRating;
  final VoidCallback? onNeedPopConfirm;

  const AppFeedbackMain({
    super.key,
    this.onNeedPopConfirm,
    this.initialRating,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rating = useState(initialRating ?? 0);
    final selectedTags = useState<Set<Tag>>({});
    final feedbackTextController = useTextEditingController();

    /// Get the feedback source
    /// Must putting in the [AppFeedbackRoute]
    final source = FeedbackSourceProvider.of(context).source;

    final collectFeedback = ref.read(collectFeedbackProvider.notifier);
    final canPop = ref.read(appFeedbackCanPopProvider.notifier);

    void onRatingChanged() {
      if (rating.value != 0) {
        canPop.disable();
      } else {
        canPop.enable();
      }
    }

    useEffect(() {
      rating.addListener(onRatingChanged);

      return () => rating.removeListener(onRatingChanged);
    }, [rating]);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: CustomCloseButton(
              onClose: () {
                if (rating.value == (initialRating ?? 0)) {
                  context.router.popForced();
                } else {
                  onNeedPopConfirm?.call();
                }
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
          child: Text(
            source == FeedbackSource.navi
                ? context.l10n.appFeedbackNavigationExperience
                : context.l10n.appFeedbackAppExperience,
            textAlign: TextAlign.center,
            style: context.textStyleV3.h3SemiBold.copyWith(
              color: context.colorsV2.foregroundDefault,
            ),
          ),
        ),
        const SizedBox(height: Spacing.$4x),
        ValueListenableBuilder(
          valueListenable: rating,
          builder: (context, ratingValue, _) => RatingBar(
            rating: ratingValue,
            onRatingChanged: (value) {
              rating.value = value;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(Spacing.$4x),
          child: ValueListenableBuilder(
            valueListenable: rating,
            builder: (context, ratingValue, _) => Text(
              _ratingText(context.l10n, rating.value),
              textAlign: TextAlign.center,
              maxLines: 1,
              style: context.textStyleV3.bodyLargeRegular.copyWith(
                color: context.colorsV2.foregroundSoft,
              ),
            ),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: rating,
          builder: (context, ratingValue, _) => AnimatedSwitcher(
              duration: Durations.short3,
              child: ratingValue > 0
                  ? TagCloud(
                      key: ValueKey(ratingValue),
                      rating: ratingValue,
                      onTagsChanged: (tags) => selectedTags.value = tags,
                    )
                  : const SizedBox.shrink()),
        ),
        ValueListenableBuilder(
          valueListenable: rating,
          builder: (context, ratingValue, _) {
            if (ratingValue <= 0) {
              return const SizedBox.shrink();
            }
            return Padding(
              key: const ValueKey('app-feedback-balady-input'),
              padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x).copyWith(top: Spacing.$4x),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  /// change feedback text
                  final result =
                      await context.router.push(AppFeedbackInputSheet(initialText: feedbackTextController.text));
                  if (result != null && result is String) {
                    feedbackTextController.text = result;
                  }
                },
                child: IgnorePointer(
                  child: BaladyTextInput(
                    inputState: BaladyInputState.readOnly,
                    controller: feedbackTextController,
                    config: BaladyInputConfig(
                      hintText: context.l10n.appFeedbackHintText,
                      maxLines: 4,
                      isDisposed: false,
                      onChanged: (_) {},
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: Spacing.$6x),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
          child: ValueListenableBuilder(
              valueListenable: rating,
              builder: (context, ratingValue, _) {
                final canSend = ratingValue > 0;
                final buttonState = !canSend ? ButtonColorScheme.tertiary : ButtonColorScheme.primary;
                return SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    buttonColorScheme: buttonState,
                    onTap: !canSend
                        ? null
                        : () async {
                            final text = feedbackTextController.text;
                            await collectFeedback.collectFeedback(
                              stars: ratingValue,
                              // Convert tag labels to source tags
                              tags:
                                  selectedTags.value.map((tag) => AppFeedbackTagMapper.getSourceTagText(tag)).toList(),
                              text: text.isEmpty ? null : feedbackTextController.text,
                              source: source,
                            );
                            openInAppReviewRating(ratingValue);
                          },
                    primaryLabel: context.l10n.appFeedbackSubmitButton,
                  ),
                );
              }),
        ),
        const SizedBox(height: Spacing.$8x),
      ],
    );
  }


  void openInAppReviewRating (ratingValue) async {
    if(ratingValue > 3) {
      final InAppReview inAppReview = InAppReview.instance;
      try {
        final available = await inAppReview.isAvailable();
        if (available) {
          await inAppReview.requestReview();
        } else {
          // await inAppReview.openStoreListing();
        }
      } catch (e) {
        // await inAppReview.openStoreListing();
      }
    }
  }

  String _ratingText(AppLocalizations l10n, int rating) => switch (rating) {
        1 => l10n.appFeedbackRating1,
        2 => l10n.appFeedbackRating2,
        3 => l10n.appFeedbackRating3,
        4 => l10n.appFeedbackRating4,
        5 => l10n.appFeedbackRating5,
        _ => l10n.appFeedbackRatingDefault,
      };
}
