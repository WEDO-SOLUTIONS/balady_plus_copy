import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

void showVoteDialog(
  BuildContext context,
  ConfettiGeneratorConfig config,
  BoxConstraints constaraints, {
  bool showLoading = false,
}) {
  showDialog(
      context: context,
      routeSettings: const RouteSettings(name: 'vote_dialog'),
      barrierColor: Colors.transparent,
      builder: (context) {
        return SizedBox(
          width: 366,
          height: 660,
          child: VoteDialog(
            config: config,
            constaraints: constaraints,
            showLoadingDialog: showLoading,
          ),
        );
      });
}

class VoteDialog extends StatefulWidget {
  final ConfettiGeneratorConfig config;
  final BoxConstraints constaraints;
  final bool showLoadingDialog;

  const VoteDialog({
    required this.config,
    required this.constaraints,
    required this.showLoadingDialog,
    super.key,
  });

  @override
  State<VoteDialog> createState() => _VoteDialogState();
}

class _VoteDialogState extends State<VoteDialog> with TickerProviderStateMixin {
  late final AnimationController confettiController;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    confettiController = AnimationController(vsync: this);

    if (!widget.showLoadingDialog) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        confettiController
            .animateTo(1, duration: widget.config.animationDuration, curve: widget.config.animationCurve)
            .whenCompleteOrCancel(() {
          if (mounted) {
            Navigator.of(context).popUntil((route) => route.settings.name != 'vote_dialog');
          }
        });
      });
    }
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: RepaintBoundary(
            child: ClipRRect(
              child: ConstrainedBox(
                  constraints: widget.constaraints,
                  child: ConfettiAnimation(animationController: confettiController, config: widget.config)),
            ),
          ),
        ),
        if (widget.showLoadingDialog)
          Container(
            color: Colors.transparent,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Animate(
                effects: const [
                  FadeEffect(duration: Duration(milliseconds: 200)),
                ],
                child: Container(
                  height: 444,
                  width: 344,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 200,
                          height: 146,
                          child: FeedbackConfirmationIndicator(
                            isLoading: isLoading,
                            color: context.colors.accentDefault,
                            onComplete: () {
                              if (mounted && !isLoading) {
                                confettiController
                                    .animateTo(
                                  1,
                                  duration: widget.config.animationDuration,
                                  curve: widget.config.animationCurve,
                                )
                                    .whenCompleteOrCancel(() {
                                  if (mounted) {
                                    confettiController.value = 0;
                                  }
                                });
                              }
                            },
                          ),
                        ),
                        Text(
                          'Thanks for your time and feedback',
                          style: context.textStyles.h2SemiBold.copyWith(color: context.colors.foregroundDefault),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Your opinion is very valuable to us, and we will definitely take it into account to improve our parks',
                          textAlign: TextAlign.center,
                          style: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundDefault),
                        ),
                        const SizedBox(height: 24),
                        GestureDetector(
                            onTap: () {
                              if (isLoading) {
                                setState(() {
                                  isLoading = false;
                                });
                              } else {
                                setState(() {
                                  isLoading = true;
                                });
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: context.colors.accentDefault,
                              ),
                              width: 200,
                              height: 40,
                              child: const Center(child: Text('Play animation')),
                            )),
                        const SizedBox(height: 24),
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: context.colors.accentDefault,
                              ),
                              width: 200,
                              height: 40,
                              child: const Center(child: Text('Complete')),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
