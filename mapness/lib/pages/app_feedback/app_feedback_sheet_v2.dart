import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/app_feedback/app_feedback_tag_mapper_v2.dart';
import 'package:mapness/features/app_feedback/collect_feedback.dart';
import 'package:mapness/features/app_feedback/send_feedback.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/extensions/tag_group_type_icons_ext.dart';
import 'package:mapness/shared/ui/buttons/app_close_button.dart';
import 'package:mapness/widgets/app_feedback/app_feedback_error.dart';
import 'package:mapness/widgets/app_feedback/app_feedback_loading.dart';
import 'package:mapness/widgets/app_feedback/app_feedback_success.dart';
import 'package:mapness/widgets/app_feedback/v2/rating_bar.dart';
import 'package:sheetify/sheetify.dart';

/// V2 because v1 will be replaced with it in future
@RoutePage()
class AppFeedbackSheetV2 extends ConsumerStatefulWidget {
  final int? rating;

  const AppFeedbackSheetV2({
    required this.rating,
    super.key,
  });

  @override
  ConsumerState<AppFeedbackSheetV2> createState() => _AppFeedbackSheetV2State();
}

class _AppFeedbackSheetV2State extends ConsumerState<AppFeedbackSheetV2> {
  late final ToggleSheetController scrollController;
  final ValueNotifier<int> rating = ValueNotifier(0);
  Set<TagV2> selectedTags = Set.identity();
  String feedbackText = '';

  @override
  void initState() {
    super.initState();
    scrollController = ToggleSheetController(
      onClose: (_) => context.router.popForced(),
      heightModel: ToggleSheetHeightModel.fraction(1),
    );
    rating.value = widget.rating ?? 0;
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sendFeedbackState = ref.watch(sendFeedbackProvider);
    ref.listen(
      sendFeedbackProvider,
      (previous, next) {
        scrollController.updateHeightModel(
          ToggleSheetHeightModel.fraction(.5),
        );
      },
    );

    return ToggleSheet(
      scrollController: scrollController,
      backgroundColor: context.colors.backgroundSurface4,
      safeAreaColor: context.colors.backgroundSurface4,
      dragger: SheetDragger(
        backgroundColor: context.colors.backgroundSurface4,
      ),
      header: BaladyTopBar(
        useSafeArea: false,
        trailing: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
          child: CustomCloseButton(
            onClose: () => context.router.popForced(),
          ),
        ),
      ),
      content: [
        switch (sendFeedbackState) {
          AppFeedbackState.initial => Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
              child: Column(
                children: [
                  const SizedBox(height: Spacing.$2x),
                  ValueListenableBuilder(
                    valueListenable: rating,
                    builder: (context, value, _) => RatingBar(
                      rating: value,
                      onRatingChanged: (value) {
                        setState(() {
                          rating.value = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: Spacing.$3x),
                  Text(
                    context.l10n.shareYourFeedback,
                    style: context.textStyles.h3SemiBold,
                  ),
                  const SizedBox(height: Spacing.$2x),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
                    child: Text(
                      context.l10n.yourOpinionHelpUsImproveUserExperience,
                      style: context.textStyles.bodySmallRegular.copyWith(
                        color: context.colors.foregroundSoft,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: Spacing.$8x),
                  ValueListenableBuilder(
                    valueListenable: rating,
                    builder: (context, value, _) => _FeedbackInput(
                      rating: value,
                      onTagsChanged: (tags) {
                        selectedTags = tags;
                      },
                      onTextChanged: (text) {
                        feedbackText = text;
                      },
                    ),
                  ),
                  const SizedBox(height: Spacing.$8x),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      buttonColorScheme: ButtonColorScheme.accentSecondary,
                      size: ButtonSize.large,
                      primaryLabel: context.l10n.appFeedbackSubmitButton,
                      onTap: () {
                        ref.read(collectFeedbackProvider.notifier).collectFeedback(
                              stars: rating.value,
                              tags: selectedTags
                                  .map(
                                    (tag) => AppFeedbackTagMapperV2.getSourceTagText(
                                      tag,
                                    ),
                                  )
                                  .toList(),
                              text: feedbackText,
                            );
                      },
                    ),
                  ),
                  const SizedBox(height: Spacing.$4x),
                ],
              ),
            ),
          AppFeedbackState.loading => const AppFeedbackLoading(),
          AppFeedbackState.success => const Padding(
              padding: EdgeInsets.symmetric(horizontal: Spacing.$4x),
              child: AppFeedbackSuccess(),
            ),
          AppFeedbackState.error => Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
              child: AppFeedbackError(
                onRetry: ref.read(sendFeedbackProvider.notifier).retry,
              ),
            ),
        },
      ],
    );
  }
}

class _FeedbackInput extends ConsumerStatefulWidget {
  final int rating;
  final Function(Set<TagV2>) onTagsChanged;
  final Function(String) onTextChanged;

  const _FeedbackInput({
    required this.rating,
    required this.onTagsChanged,
    required this.onTextChanged,
  });

  @override
  ConsumerState<_FeedbackInput> createState() => _FeedbackInputState();
}

class _FeedbackInputState extends ConsumerState<_FeedbackInput> {
  final feedbackTextController = TextEditingController();
  final Set<TagV2> selectedTags = Set.identity();

  @override
  void didUpdateWidget(covariant _FeedbackInput oldWidget) {
    if (oldWidget.rating != widget.rating) {
      selectedTags.clear();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final tags = AppFeedbackTagMapperV2.getTags(widget.rating);

    return ContentWrapper(
      children: [
        Padding(
          padding: const EdgeInsets.all(Spacing.$4x),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.rating > 3 ? context.l10n.appFeedbackGoodRatingV2 : context.l10n.appFeedbackBadRatingV2,
                style: context.textStyles.bodyLargeSemiBold,
              ),
              const SizedBox(height: Spacing.$5x),
              for (final (index, tagGroup) in tags.indexed)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (tagGroup.type.icon != null)
                          Padding(
                            padding: const EdgeInsetsDirectional.only(end: Spacing.$2x, start: Spacing.$1x),
                            child: Icon(tagGroup.type.icon, color: context.colors.foregroundSoft),
                          ),
                        Text(
                          AppFeedbackTagMapperV2.getLocalizedTitle(context.l10n, tagGroup.type),
                          style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
                        ),
                      ],
                    ),
                    const SizedBox(height: Spacing.$3x),
                    Wrap(
                      runSpacing: Spacing.$2x,
                      spacing: Spacing.$2x,
                      children: [
                        for (final tag in tagGroup.tags)
                          Chips(
                            isSelected: selectedTags.contains(tag),
                            onPressed: () {
                              setState(() {
                                if (selectedTags.contains(tag)) {
                                  selectedTags.remove(tag);
                                } else {
                                  selectedTags.add(tag);
                                }
                                widget.onTagsChanged(Set.from(selectedTags));
                              });
                            },
                            type: ChipsType.neutral,
                            options: ChipsLabelOptions(
                              labelFirst: AppFeedbackTagMapperV2.getLocalizedText(
                                context.l10n,
                                tag,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (index != tags.length - 1) const Divider(height: Spacing.$8x),
                  ],
                ),
              const SizedBox(height: Spacing.$5x),
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 85),
                child: GestureDetector(
                  onTap: () async {
                    final result = await context.router.push(
                      AppFeedbackInputSheet(
                        initialText: feedbackTextController.text,
                        maxCharsAllowed: 500,
                      ),
                    );

                    if (result is String) {
                      widget.onTextChanged(result);
                      feedbackTextController.text = result;
                    }
                  },
                  behavior: HitTestBehavior.opaque,
                  child: IgnorePointer(
                    child: BaladyTextInput(
                      inputStyle: BaladyInputStyle.multiline,
                      controller: feedbackTextController,
                      config: BaladyInputConfig(
                        maxLines: 4,
                        hintText: context.l10n.appFeedbackHintText,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
