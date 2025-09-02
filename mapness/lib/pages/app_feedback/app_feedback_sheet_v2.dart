import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/entities/app_feedback/app_feedback_payload.dart';
import 'package:mapness/entities/app_feedback/app_feedback_tag_mapper_v2.dart';
import 'package:mapness/features/app_feedback/app_feedback_source_provider.dart';
import 'package:mapness/features/app_feedback/collect_feedback.dart';
import 'package:mapness/features/app_feedback/send_feedback.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/buttons/app_close_button.dart';
import 'package:mapness/widgets/app_feedback/app_feedback_error.dart';
import 'package:mapness/widgets/app_feedback/app_feedback_loading.dart';
import 'package:mapness/widgets/app_feedback/app_feedback_success.dart';
import 'package:mapness/widgets/app_feedback/v2/rating_bar.dart';
import 'package:sheetify/sheetify.dart';

/// V2 because v1 will be replaced with it in future
class AppFeedbackSheetV2 extends ConsumerStatefulWidget {
  final int? rating;

  const AppFeedbackSheetV2({
    required this.rating,
    super.key,
  });

  static Future<void> show({
    required BuildContext context,
    required int? rating,
  }) =>
      context.router.pushNativeRoute(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              FeedbackSourceProvider(
            source: FeedbackSource.main,
            child: AppFeedbackSheetV2(rating: rating),
          ),
          opaque: false,
          barrierDismissible: true,
          fullscreenDialog: true,
          barrierColor: context.colors.screenOverlayDimming40,
          transitionsBuilder: (context, animation, _, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeInOutCubic;

            final tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));
            final offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
        ),
      );

  @override
  ConsumerState<AppFeedbackSheetV2> createState() => _AppFeedbackSheetV2State();
}

class _AppFeedbackSheetV2State extends ConsumerState<AppFeedbackSheetV2> {
  late final ToggleSheetController scrollController = ToggleSheetController(
    onClose: (_) => context.router.popForced(),
  );
  late int rating;
  Set<TagV2> selectedTags = Set.identity();
  String feedbackText = '';

  @override
  void initState() {
    super.initState();
    rating = widget.rating ?? 0;
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sendFeedbackState = ref.watch(sendFeedbackProvider);

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
                  RatingBar(
                    rating: rating,
                    onRatingChanged: (value) {
                      setState(() {
                        rating = value;
                      });
                    },
                  ),
                  const SizedBox(height: Spacing.$3x),
                  Text(
                    context.l10n.shareFeedback,
                    style: context.textStyles.h3SemiBold,
                  ),
                  const SizedBox(height: Spacing.$2x),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: Spacing.$4x),
                    child: Text(
                      context.l10n.yourOpinionHelpUsImproveUserExperience,
                      style: context.textStyles.bodySmallRegular.copyWith(
                        color: context.colors.foregroundSoft,
                      ),
                    ),
                  ),
                  const SizedBox(height: Spacing.$8x),
                  _FeedbackInput(
                    rating: rating,
                    onTagsChanged: (tags) {
                      selectedTags = tags;
                    },
                    onTextChanged: (text) {
                      feedbackText = text;
                    },
                  ),
                  const SizedBox(height: Spacing.$8x),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      buttonColorScheme: ButtonColorScheme.accentSecondary,
                      size: ButtonSize.large,
                      primaryLabel: context.l10n.appFeedbackSubmitButton,
                      onTap: () {
                        ref
                            .read(collectFeedbackProvider.notifier)
                            .collectFeedback(
                              stars: rating,
                              tags: selectedTags
                                  .map(
                                    (tag) =>
                                        AppFeedbackTagMapperV2.getSourceTagText(
                                      tag,
                                    ),
                                  )
                                  .toList(),
                              text: feedbackText,
                              source: FeedbackSourceProvider.of(context).source,
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
  void dispose() {
    feedbackTextController.dispose();
    super.dispose();
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
                widget.rating > 3
                    ? context.l10n.appFeedbackRating5
                    : context.l10n.appFeedbackRating1,
                style: context.textStyles.bodyLargeSemiBold,
              ),
              const SizedBox(height: Spacing.$5x),
              for (final (index, tagGroup) in tags.indexed)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppFeedbackTagMapperV2.getLocalizedTitle(
                          context.l10n, tagGroup.type),
                      style: context.textStyles.bodySmallRegular
                          .copyWith(color: context.colors.foregroundSoft),
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
                              labelFirst:
                                  AppFeedbackTagMapperV2.getLocalizedText(
                                context.l10n,
                                tag,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (index != tags.length - 1)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: Spacing.$4x),
                        child: Divider(),
                      ),
                  ],
                ),
              const SizedBox(height: Spacing.$5x),
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 85),
                child: BaladyTextInput(
                  inputStyle: BaladyInputStyle.multiline,
                  config: BaladyInputConfig(
                    onChanged: widget.onTextChanged,
                    maxLines: 4,
                    textInputAction: TextInputAction.newline,
                    hintText: context.l10n.appFeedbackHintText,
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
