import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/app_feedback/app_feedback_payload.dart';
import 'package:mapness/entities/app_feedback/app_feedback_tag_mapper.dart';
import 'package:mapness/features/app_feedback/app_feedback_source.dart';
import 'package:mapness/features/app_feedback/collect_feedback.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/buttons/app_close_button.dart';
import 'package:mapness/widgets/app_feedback/v2/rating_bar.dart';
import 'package:mapness/widgets/app_feedback/v2/tag_cloud.dart';

class AppFeedbackMain extends HookConsumerWidget {
  const AppFeedbackMain({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rating = useState(0);
    final selectedTags = useState<Set<String>>({});
    final feedbackTextController = useTextEditingController();

    /// Get the feedback source
    /// Must putting in the [AppFeedbackRoute]
    final source = FeedbackSourceProvider.of(context).source;

    final collectFeedback = ref.read(collectFeedbackProvider.notifier);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: CustomCloseButton(
              onClose: context.router.popForced,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
          child: Text(
            switch (source) {
              FeedbackSource.navi => context.l10n.appFeedbackNavigationExperience,
              _ => context.l10n.appFeedbackAppExperience,
            },
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
        const SizedBox(height: Spacing.$4x),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x).copyWith(bottom: Spacing.$4x),
          child: ValueListenableBuilder(
            valueListenable: rating,
            builder: (context, ratingValue, _) => Text(
              _ratingText(context.l10n, rating.value),
              textAlign: TextAlign.center,
              style: context.textStyleV3.bodyLargeRegular.copyWith(
                color: context.colorsV2.foregroundSoft,
              ),
            ),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: rating,
          builder: (context, ratingValue, _) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
            child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: ratingValue > 0
                    ? TagCloud(
                        key: ValueKey(ratingValue),
                        rating: ratingValue,
                        onTagsChanged: (tags) => selectedTags.value = tags,
                      )
                    : const SizedBox.shrink()),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: rating,
          builder: (context, ratingValue, _) => ratingValue > 0
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x).copyWith(top: Spacing.$4x),
                  child: GestureDetector(
                    onTap: () async {
                      /// change feedback text
                      final result =
                          await context.router.push(AppFeedbackInputSheet(initalText: feedbackTextController.text));
                      if (result != null && result is String) {
                        feedbackTextController.text = result;
                      }
                    },
                    child: BaladyInput(
                      controller: feedbackTextController,
                      hintText: context.l10n.appFeedbackHintText,
                      maxLines: 4,
                      enabled: false,
                      onChanged: (_) {},
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
        const SizedBox(height: Spacing.$6x),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
          child: ValueListenableBuilder(
              valueListenable: rating,
              builder: (context, ratingValue, _) {
                final buttonState = ratingValue == 0 ? ButtonColorScheme.tertiary : ButtonColorScheme.primary;
                return SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    buttonColorScheme: buttonState,
                    onTap: () async {
                      await collectFeedback.collectFeedback(
                        stars: ratingValue,
                        // Convert tag labels to source tags
                        tags: selectedTags.value.map((tag) => AppFeedbackTagMapper.getSourceTagText(tag)).toList(),
                        text: feedbackTextController.text,
                        source: source,
                      );
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

  String _ratingText(AppLocalizations l10n, int rating) => switch (rating) {
        1 => l10n.appFeedbackRating1,
        2 => l10n.appFeedbackRating2,
        3 => l10n.appFeedbackRating3,
        4 => l10n.appFeedbackRating4,
        5 => l10n.appFeedbackRating5,
        _ => l10n.appFeedbackRatingDefault,
      };
}
