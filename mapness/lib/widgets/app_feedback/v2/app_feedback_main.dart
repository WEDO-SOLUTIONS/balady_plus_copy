import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/app_feedback/app_feedback_tag_mapper.dart';
import 'package:mapness/entities/app_feedback/feedback_source.dart';
import 'package:mapness/features/app_feedback/app_feedback_canpop.dart';
import 'package:mapness/features/app_feedback/app_feedback_source_provider.dart';
import 'package:mapness/features/app_feedback/collect_feedback.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/buttons/app_close_button.dart';
import 'package:mapness/shared/utils/detach.dart';
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
                if (rating.value == (initialRating ?? 0) || onNeedPopConfirm == null) {
                  context.router.pop();
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
            switch (source) {
              FeedbackSourceMain() => context.l10n.appFeedbackAppExperience,
              FeedbackSourceNavi() => context.l10n.appFeedbackNavigationExperience,
              FeedbackSourceOffer() => context.l10n.doYouLikeOffer,
            },
            textAlign: TextAlign.center,
            style: context.textStyles.h3SemiBold.copyWith(
              color: context.colors.foregroundDefault,
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
        ValueListenableBuilder(
          valueListenable: rating,
          builder: (context, ratingValue, _) => source is! FeedbackSourceOffer || ratingValue == 0
              ? Padding(
                  padding: const EdgeInsets.only(left: Spacing.$4x, top: Spacing.$4x, right: Spacing.$4x),
                  child: Text(
                    _feedbackSubtitleText(context.l10n, rating.value, source),
                    textAlign: TextAlign.center,
                    style: context.textStyles.bodyLargeRegular.copyWith(
                      color: context.colors.foregroundSoft,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
        ValueListenableBuilder(
          valueListenable: rating,
          builder: (context, ratingValue, _) => AnimatedSwitcher(
            duration: Durations.short3,
            child: ratingValue > 0 && source is! FeedbackSourceOffer
                ? Padding(
                    padding: const EdgeInsets.only(top: Spacing.$4x),
                    child: TagCloud(
                      key: ValueKey(ratingValue),
                      rating: ratingValue,
                      onTagsChanged: (tags) => selectedTags.value = tags,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: rating,
          builder: (context, ratingValue, _) {
            if (ratingValue <= 0) {
              return const SizedBox.shrink();
            }
            return Padding(
              key: const ValueKey('app-feedback-balady-input'),
              padding: const EdgeInsets.only(left: Spacing.$4x, top: Spacing.$4x, right: Spacing.$4x),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  /// change feedback text
                  final result = await context.router.push(
                    AppFeedbackInputSheet(initialText: feedbackTextController.text),
                  );
                  if (result != null && result is String) {
                    feedbackTextController.text = result;
                  }
                },
                child: IgnorePointer(
                  child: BaladyTextInput(
                    inputState: BaladyInputState.readOnly,
                    controller: feedbackTextController,
                    config: BaladyInputConfig(
                      background: BaladyInputBackground.color,
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
              final buttonState = !canSend ? ButtonState.disabled : ButtonState.defaultState;
              return SizedBox(
                width: double.infinity,
                child: AppButton(
                  buttonColorScheme: ButtonColorScheme.accentSecondary,
                  buttonState: buttonState,
                  size: ButtonSize.large,
                  onTap: !canSend
                      ? null
                      : () async {
                          final text = feedbackTextController.text;
                          await collectFeedback.collectFeedback(
                            stars: ratingValue,
                            source: source,
                            // Convert tag labels to source tags
                            tags: selectedTags.value.map((tag) => AppFeedbackTagMapper.getSourceTagText(tag)).toList(),
                            text: text.isEmpty ? null : feedbackTextController.text,
                          );
                          // Unawaited for not freezed HMS
                          detach(openInAppReviewRating(ratingValue), tag: 'appFeedbackMain.openInAppReviewRating');
                        },
                  primaryLabel: context.l10n.appFeedbackSubmitButton,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: Spacing.$4x),
      ],
    );
  }

  String _feedbackSubtitleText(AppLocalizations l10n, int rating, FeedbackSource source) =>
      source is FeedbackSourceOffer ? l10n.offerFeedbackMessage : _ratingText(l10n, rating);

  Future<void> openInAppReviewRating(int ratingValue) async {
    if (ratingValue > 3) {
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
