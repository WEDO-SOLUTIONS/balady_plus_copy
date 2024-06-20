import 'dart:math';

import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/_features/happiness_map/data/happines_manager.dart';
import 'package:mapness/_features/happiness_map/data/happiness_repository.dart';
import 'package:mapness/_features/happiness_map/domain/happiness_feedback.dart';
import 'package:mapness/_features/happiness_map/presentation/close_happiness_button.dart';
import 'package:mapness/_features/happiness_map/presentation/hapiness_tags_grid.dart';
import 'package:mapness/_features/happiness_map/presentation/happiness_feedback_button.dart';
import 'package:mapness/_features/happiness_map/presentation/happiness_submit_button.dart';
import 'package:mapness/app/routes/happines_map.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/measure_size.dart';
import 'package:mapness/shared/ui/sheets/error_sheet.dart';
import 'package:mapness/shared/ui/sheets/loading_sheet.dart';
import 'package:mapness/shared/ui/sheets/loading_thanks_sheet.dart';

class HappinessBottomSheet extends ConsumerStatefulWidget {
  final bool isOpenedInitially;
  final void Function(double height) onHeightChange;

  final VoidCallback onClose;
  final VoidCallback onFeedbackSent;
  final double biggestHeight;

  const HappinessBottomSheet({
    required this.isOpenedInitially,
    required this.onHeightChange,
    required this.onClose,
    required this.onFeedbackSent,
    required this.biggestHeight,
    super.key,
  });

  @override
  ConsumerState<HappinessBottomSheet> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<HappinessBottomSheet> {
  late final DraggableScrollableController _draggableScrollableController;

  double childHeightCollapsed = 100;
  double childHeightExpanded = 100;
  double childPortion(double height) => min(height / widget.biggestHeight, 1);

  void onSubmit() => ref.read(happinessManagerProvider.notifier).submitFeedback();

  @override
  void initState() {
    super.initState();
    _draggableScrollableController = DraggableScrollableController()
      ..addListener(() {
        // ref.read(cameraPositionProvider.notifier);
        widget.onHeightChange(_draggableScrollableController.size);
      });
  }

  @override
  void dispose() {
    _draggableScrollableController.dispose();
    super.dispose();
  }

  void onButtonTap(HappinessFeedback feedback) {
    ref.read(happinessManagerProvider.notifier).onFeedbackPressed(feedback);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(
        const Duration(milliseconds: 100),
        () => _draggableScrollableController.animateTo(
          childPortion(childHeightExpanded),
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final requestState = ref.watch(happinessRepositoryProvider);
    final state = ref.watch(happinessManagerProvider);
    final isCollapsed = state.feedback == null;
    final directionality = ref.watch(uiDirectionProvider);

    if (requestState is AsyncError) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: ErrorSheet(
          onRetry: () => ref.read(happinessManagerProvider.notifier).submitFeedback(),
          buttonLabel: context.l10n.reload,
          onClose: widget.onClose,
        ),
      );
    }

    if (requestState is AsyncLoading && state.feedback == null) {
      return const Align(
        alignment: Alignment.bottomCenter,
        child: LoadingSheet(),
      );
    }

    if (requestState is AsyncLoading || requestState.requireValue == true) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 24.0, left: 16.0, right: 16.0),
          child: LoadingThanksSheet(
            isLoading: requestState is AsyncLoading || requestState.requireValue == false,
            onComplete: widget.onFeedbackSent,
            onClose: widget.onClose,
            triggerOnComplete: state.feedback == HappinessFeedback.like,
          ),
        ),
      );
    }

    return DraggableScrollableSheet(
      controller: _draggableScrollableController,
      initialChildSize: childPortion(childHeightExpanded),
      minChildSize: childPortion(childHeightCollapsed),
      maxChildSize: isCollapsed ? childPortion(childHeightCollapsed) : childPortion(childHeightExpanded),
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16),
            topLeft: Radius.circular(16),
          ),
        ),
        child: ListView(
          controller: scrollController,
          padding: EdgeInsets.zero,
          physics: const ClampingScrollPhysics(),
          children: [
            MeasureSize(
              onChange: (size) => setState(() {
                if (isCollapsed) {
                  childHeightCollapsed = size.height;
                  childHeightExpanded = size.height;
                } else {
                  childHeightExpanded = size.height;
                }
              }),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    Container(
                      height: 4,
                      width: 26,
                      decoration: BoxDecoration(
                        color: context.color.surfaceBasePrimary,
                        borderRadius: const BorderRadius.all(Radius.circular(24)),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Material(
                      color: Colors.transparent,
                      child: Directionality(
                        textDirection: directionality,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    context.l10n.shareYourFeelings,
                                    style: context.textStyle.heading1.copyWith(
                                      color: context.color.textAndIconsBasePrimary,
                                    ),
                                  ),
                                ),
                                CloseHappinessButton(
                                  onPressed: widget.onClose,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: HappinesFeedbackButton(
                                    type: HappinessFeedback.dislike,
                                    state: state.feedback,
                                    onPressed: onButtonTap,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: HappinesFeedbackButton(
                                    type: HappinessFeedback.like,
                                    state: state.feedback,
                                    onPressed: onButtonTap,
                                  ),
                                ),
                              ],
                            ),
                            if (isCollapsed) const SizedBox(height: 24),
                            if (!isCollapsed) ...[
                              const SizedBox(height: 20),
                              const HappinessTagsGrid(),
                              const SizedBox(height: 20),
                              Material(
                                color: context.color.surfaceBasePrimary,
                                borderRadius: BorderRadius.circular(8),
                                child: InkWell(
                                  onTap: () => const HappinessMapCommentRoute().push(context),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 16,
                                    ),
                                    child: Text(
                                      state.comment.isEmpty ? context.l10n.shareYourFeedback : state.comment,
                                      style: context.textStyle.text.copyWith(
                                        color: context.color.textAndIconsBasePrimary,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              HappinessSubmitButton(onPress: onSubmit),
                              const SizedBox(height: 21),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
