import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapness/features/happiness_map/domain/happiness_feedback.dart';
import 'package:mapness/features/happiness_map/presentation/close_happiness_button.dart';
import 'package:mapness/features/happiness_map/presentation/hapiness_tags_grid.dart';
import 'package:mapness/features/happiness_map/presentation/happiness_feedback_button.dart';
import 'package:mapness/features/happiness_map/presentation/happiness_submit_button.dart';
import 'package:mapness/features/happiness_map/presentation/happiness_text_field.dart';
import 'package:mapness/features/landing/providers/map_controls.dart';

import 'data/happines_manager.dart';

class HappinessBottomSheet extends ConsumerStatefulWidget {
  const HappinessBottomSheet({
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

  double get _headerExtent => 150 / widget.biggestHeight;

  void onSubmit() {
    final happinesManager = ref.read(happinessManagerProvider.notifier);
    happinesManager.submitFeedback();
    widget.onClose();
  }

  @override
  void initState() {
    _draggableScrollableController = DraggableScrollableController();
    super.initState();
  }

  onButtonTap(HappinessFeedback feedback) {
    ref.read(happinessManagerProvider.notifier).onFeedbackPressed(feedback);
    Future.delayed(
      const Duration(milliseconds: 100),
      () => _draggableScrollableController.animateTo(
        .7,
        duration: const Duration(milliseconds: 250),
        curve: Curves.linear,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(happinessManagerProvider);

    return DraggableScrollableSheet(
      controller: _draggableScrollableController,
      initialChildSize: _headerExtent,
      minChildSize: _headerExtent,
      maxChildSize: state.feedback == null ? _headerExtent : .7,
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
              Padding(
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
                                    "Share your feelings",
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFF1D2A36),
                                      fontSize: 19,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                CloseHappinessButton(onPressed: widget.onClose),
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
                            if (state.feedback != null) ...[
                              const SizedBox(height: 20),
                              const HappinessTagsGrid(),
                              const SizedBox(height: 20),
                              const HappinessTextField(),
                              const SizedBox(height: 16),
                              HappinessSubmitButton(onPress: onSubmit),
                            ]
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
