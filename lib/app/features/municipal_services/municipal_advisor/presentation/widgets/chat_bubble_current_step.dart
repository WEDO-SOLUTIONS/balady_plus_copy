import 'package:flutter/material.dart';

import '../../municipal_advisor_exports.dart'
    show LocationSelector, MunicipalAdvisorSteps, TopicSelector;

class ChatBubbleCurrentStep extends StatelessWidget {
  final MunicipalAdvisorSteps step;

  const ChatBubbleCurrentStep({
    super.key,
    required this.step,
  });

  @override
  Widget build(BuildContext context) {
    switch (step) {
      case MunicipalAdvisorSteps.start:
        return const SizedBox.shrink();
      case MunicipalAdvisorSteps.topic:
        return const TopicSelector();
      case MunicipalAdvisorSteps.location:
        return const LocationSelector();
    }
  }
}
