import 'package:flutter/material.dart';

import '../../../municipal_advisor_exports.dart'
    show
        ActivitySelector,
        ConfirmLocation,
        LocationSelector,
        MunicipalAdvisorSteps,
        TopicSelector;

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
      case MunicipalAdvisorSteps.confirmLocation:
        return const ConfirmLocation();
      case MunicipalAdvisorSteps.activity:
        return const ActivitySelector();
    }
  }
}
