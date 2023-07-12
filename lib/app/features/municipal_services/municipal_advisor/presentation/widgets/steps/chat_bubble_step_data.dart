import 'package:flutter/material.dart';

import '../../../municipal_advisor_exports.dart'
    show InputSummary, MunicipalAdvisorSteps;

class ChatBubbleStepData extends StatelessWidget {
  final MunicipalAdvisorSteps step;

  const ChatBubbleStepData({
    super.key,
    required this.step,
  });

  @override
  Widget build(BuildContext context) {
    switch (step) {
      case MunicipalAdvisorSteps.inputSummary:
        return const InputSummary();
      default:
        return const SizedBox.shrink();
    }
  }
}
