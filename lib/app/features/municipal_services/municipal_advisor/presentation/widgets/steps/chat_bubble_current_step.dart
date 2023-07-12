import 'package:flutter/material.dart';

import '../../../municipal_advisor_exports.dart'
    show
        ActivitySelector,
        AreaSelector,
        ChangeInformation,
        ConfirmInputSummary,
        ConfirmLocation,
        LocationSelector,
        MunicipalAdvisorSteps,
        SubActivitySelector,
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
      case MunicipalAdvisorSteps.subActivity:
        return const SubActivitySelector();
      case MunicipalAdvisorSteps.area:
        return const AreaSelector();
      case MunicipalAdvisorSteps.inputSummary:
        return const SizedBox.shrink();
      case MunicipalAdvisorSteps.confirmInformation:
        return const ConfirmInputSummary();
      case MunicipalAdvisorSteps.changeInformation:
        return const ChangeInformation();
      case MunicipalAdvisorSteps.requirements:
        return const SizedBox.shrink();
    }
  }
}
