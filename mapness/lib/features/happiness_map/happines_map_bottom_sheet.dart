import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/happiness_map/domain/happiness_feedback.dart';
import 'package:mapness/features/happiness_map/presentation/close_happiness_button.dart';
import 'package:mapness/features/happiness_map/presentation/hapiness_tags_grid.dart';
import 'package:mapness/features/happiness_map/presentation/happiness_feedback_button.dart';
import 'package:mapness/features/happiness_map/presentation/happiness_submit_button.dart';
import 'package:mapness/features/happiness_map/presentation/happiness_text_field.dart';
import 'package:mapness/features/landing/providers/map_controls.dart';

import 'data/happines_manager.dart';

class HappinessBottomSheet extends ConsumerStatefulWidget {
  final VoidCallback onClose;
  const HappinessBottomSheet({required this.onClose, Key? key})
      : super(key: key);

  @override
  ConsumerState<HappinessBottomSheet> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<HappinessBottomSheet> {
  late final DraggableScrollableController _draggableScrollableController;

  void onSubmit(WidgetRef ref) {
    final happinesManager = ref.read(happinessManagerProvider.notifier);
    happinesManager.submitFeedback();
    widget.onClose();
  }

  @override
  void initState() {
    _draggableScrollableController = DraggableScrollableController()
      ..addListener(() {
        if (_draggableScrollableController.size > .1) {
          ref.read(mapControlsProvider.notifier).update(
                MapControlsState.happinessMap,
              );
        } else {
          ref.read(mapControlsProvider.notifier).update(
                MapControlsState.idle,
              );
        }
      });
    super.initState();
  }

  onButtonTap(HappinessFeedback feedback) {
    ref.read(happinessManagerProvider.notifier).onFeedbackPressed(feedback);
    Future.delayed(
      const Duration(milliseconds: 100),
      () => _draggableScrollableController.jumpTo(.6),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(happinessManagerProvider);

    return DraggableScrollableSheet(
      controller: _draggableScrollableController,
      initialChildSize: .15,
      minChildSize: .1,
      maxChildSize: state.feedback == null ? .2 : .6,
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
            children:
                // true
                // ? [HappinessBottomSheet()]
                // :
                [
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
                      height: 8,
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
                                const Expanded(
                                  child: Text(
                                    "Share your feelings",
                                    style: TextStyle(
                                      color: Color(0xFF022224),
                                      fontSize: 22,
                                      fontFamily: 'TT Commons',
                                      fontWeight: FontWeight.w500,
                                      height: 0.06,
                                      letterSpacing: 0.22,
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
                                      onPressed: onButtonTap),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: HappinesFeedbackButton(
                                      type: HappinessFeedback.like,
                                      state: state.feedback,
                                      onPressed: onButtonTap),
                                ),
                              ],
                            ),
                            if (state.feedback != null) ...[
                              const SizedBox(height: 16),
                              const HappinessTagsGrid(),
                              const SizedBox(height: 16),
                              const HappinessTextField(),
                              const SizedBox(height: 16),
                              HappinessSubmitButton(
                                  onPress: () => onSubmit(ref)),
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
