import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:mapness/pages/iwish/iwish_feedback.dart';

@RoutePage()
class IwishFeedbackContainerPage extends StatefulWidget {
  final String iwishId;

  const IwishFeedbackContainerPage({required this.iwishId, super.key});

  @override
  State<IwishFeedbackContainerPage> createState() => _IwishFeedbackContainerPageState();
}

class _IwishFeedbackContainerPageState extends State<IwishFeedbackContainerPage> with TickerProviderStateMixin {
  late final AnimationController confettiController;

  final ConfettiGeneratorConfig config = ConfettiGeneratorConfig.confetti();

  void playConfettiAnimation() =>
      confettiController.animateTo(1, duration: config.animationDuration, curve: config.animationCurve);

  @override
  void initState() {
    super.initState();
    confettiController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          ConfettiAnimation(
            animationController: confettiController,
            config: ConfettiGeneratorConfig.confetti(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: IwishFeedback(
              iwishId: widget.iwishId,
              onFeedbackSent: () {
                playConfettiAnimation();
              },
            ),
          ),
        ],
      );
}
