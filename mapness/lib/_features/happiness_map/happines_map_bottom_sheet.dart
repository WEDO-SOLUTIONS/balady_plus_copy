import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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
import 'package:mapness/shared/ui/sheets/thanks_sheet.dart';

import 'data/happines_manager.dart';

class HappinessBottomSheet extends ConsumerStatefulWidget {
  final void Function(double height) onHeightChange;

  const HappinessBottomSheet({
    required this.onHeightChange,
    required this.onClose,
    required this.biggestHeight,
    Key? key,
  }) : super(key: key);

  final VoidCallback onClose;
  final double biggestHeight;

  @override
  ConsumerState<HappinessBottomSheet> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<HappinessBottomSheet> {
  late final DraggableScrollableController _draggableScrollableController;

  double childHeightCollapsed = 100;
  double childHeightExpanded = 100;
  double childPortion(double height) => min(height / widget.biggestHeight, 1);

  void onSubmit() {
    final happinesManager = ref.read(happinessManagerProvider.notifier);
    happinesManager.submitFeedback();
    // widget.onClose();
  }

  @override
  void initState() {
    super.initState();
    _draggableScrollableController = DraggableScrollableController()
      ..addListener(() {
        // ref.read(cameraPositionProvider.notifier);
        widget.onHeightChange(_draggableScrollableController.size);
      });
  }

  onButtonTap(HappinessFeedback feedback) {
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

    if (requestState is AsyncLoading) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: LoadingSheet(text: context.l10n.sending),
      );
    }

    if (requestState is AsyncError) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: ErrorSheet(
          onRetry: () =>
              ref.read(happinessManagerProvider.notifier).submitFeedback(),
          buttonLabel: context.l10n.reload,
          onClose: widget.onClose,
        ),
      );
    }

    if (requestState.requireValue) {
      Future.delayed(const Duration(seconds: 5), () => widget.onClose());
      return const Align(
        alignment: Alignment.bottomCenter,
        child: ThanksSheet(),
      );
    }

    return DraggableScrollableSheet(
      controller: _draggableScrollableController,
      initialChildSize: childPortion(childHeightCollapsed),
      minChildSize: childPortion(childHeightCollapsed),
      maxChildSize: isCollapsed
          ? childPortion(childHeightCollapsed)
          : childPortion(childHeightExpanded),
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(16.0),
              topLeft: Radius.circular(16.0),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      Container(
                        height: 4,
                        width: 26,
                        decoration: const BoxDecoration(
                          color: Color(0xFFDDE4EE),
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Material(
                        color: Colors.transparent,
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      context.l10n.shareYourFeelings,
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFF1D2A36),
                                        fontSize: 19,
                                        fontWeight: FontWeight.w600,
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
                                  color: const Color(0xffE8E9EA),
                                  borderRadius: BorderRadius.circular(8),
                                  child: InkWell(
                                    onTap: () =>
                                        const HappinessMapCommentRoute()
                                            .replace(context),
                                    // IwishFeedbackCommentRoute(iwishId: widget.iwishId)
                                    //     .replace(context),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 16,
                                      ),
                                      child: Text(
                                        state.comment.isEmpty
                                            ? context.l10n.shareYourFeedback
                                            : state.comment,
                                        style: GoogleFonts.inter(
                                          color: const Color(0xFF1D2A36),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                HappinessSubmitButton(onPress: onSubmit),
                                const SizedBox(height: 21),
                              ]
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
        );
      },
    );
  }
}
