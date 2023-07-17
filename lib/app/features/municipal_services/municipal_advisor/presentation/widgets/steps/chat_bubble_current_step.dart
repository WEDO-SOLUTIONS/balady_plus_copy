import 'package:flutter/material.dart';

import '../../../municipal_advisor_exports.dart'
    show
        ATMSelectorSummary,
        AccommodationTypeSelector,
        ActivitySelector,
        AreaSelector,
        ChangeInformation,
        ConfirmInputSummary,
        ConfirmLocation,
        ContinueToFinancial,
        LicenseCost,
        LocationSelector,
        MunicipalAdvisorSteps,
        SubActivitySelector,
        TopicSelector,
        UnitCountSelector;

class ChatBubbleCurrentStep extends StatelessWidget {
  final MunicipalAdvisorSteps step;
  final dynamic data;

  const ChatBubbleCurrentStep({
    super.key,
    required this.step,
    this.data,
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
      case MunicipalAdvisorSteps.accommodationType:
        return const AccommodationTypeSelector();
      case MunicipalAdvisorSteps.unitCount:
        return const UnitCountSelector();
      case MunicipalAdvisorSteps.area:
        return const AreaSelector();
      case MunicipalAdvisorSteps.atm:
        return const ATMSelectorSummary();
      case MunicipalAdvisorSteps.inputSummary:
        return const SizedBox.shrink();
      case MunicipalAdvisorSteps.confirmInformation:
        return const ConfirmInputSummary();
      case MunicipalAdvisorSteps.changeInformation:
        return const ChangeInformation();
      case MunicipalAdvisorSteps.requirements:
      case MunicipalAdvisorSteps.issuingPredefinedConditions:
      case MunicipalAdvisorSteps.licensePermits:
      case MunicipalAdvisorSteps.supervisingAuthorities:
      case MunicipalAdvisorSteps.civilDefensePredefinedConditions:
      case MunicipalAdvisorSteps.cleaningMechanisms:
      case MunicipalAdvisorSteps.commercialOffices:
      case MunicipalAdvisorSteps.endChat:
        return const SizedBox.shrink();
      case MunicipalAdvisorSteps.continueToFinancial:
        return const ContinueToFinancial();
      case MunicipalAdvisorSteps.licenseCost:
        return LicenseCost(
          license: data,
        );

      case MunicipalAdvisorSteps.addAttachments:
        return const ContinueToFinancial();
    }
  }
}
