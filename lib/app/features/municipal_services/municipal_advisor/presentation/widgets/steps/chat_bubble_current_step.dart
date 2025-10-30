import 'package:balady_plus/app/features/municipal_services/municipal_advisor/presentation/widgets/steps/retry_location.dart';
import 'package:flutter/material.dart';

import '../../../municipal_advisor_exports.dart'
    show
        ATMSelectorSummary,
        AccommodationTypeSelector,
        ActivitySelector,
        AdditionalActivitiesSelector,
        AreaSelector,
        AttachmentsSelector,
        ChangeInformation,
        ConfirmInputSummary,
        ConfirmLocation,
        ContinueToAttachments,
        ContinueToFinancial,
        ContinueToRequestPath,
        LicenseCost,
        LocationSelector,
        MunicipalAdvisorSteps,
        SubActivitySelector,
        TopicSelector,
        UnitCountSelector;
import 'salama_selector.dart';

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
      case MunicipalAdvisorSteps.retryLocation:
        return const RetryLocation();
      case MunicipalAdvisorSteps.activity:
        return const ActivitySelector();
      case MunicipalAdvisorSteps.subActivity:
        return const SubActivitySelector();
      case MunicipalAdvisorSteps.additionalActivities:
        return const AdditionalActivitiesSelector();
      case MunicipalAdvisorSteps.accommodationType:
        return const AccommodationTypeSelector();
      case MunicipalAdvisorSteps.unitCount:
        return const UnitCountSelector();
      case MunicipalAdvisorSteps.area:
        return const AreaSelector();
      case MunicipalAdvisorSteps.atm:
        return const ATMSelectorSummary();
      case MunicipalAdvisorSteps.salamaPermitQuestion:
        return const SalamaSelectorSummary();
      case MunicipalAdvisorSteps.inputSummary:
        return const SizedBox.shrink();
      case MunicipalAdvisorSteps.confirmInformation:
        return const ConfirmInputSummary();
      case MunicipalAdvisorSteps.changeInformation:
        return const ChangeInformation();
      case MunicipalAdvisorSteps.requirements:
      case MunicipalAdvisorSteps.issuingPredefinedConditions:
      case MunicipalAdvisorSteps.licensePermits:
      case MunicipalAdvisorSteps.selectedAdditionalActivities:
      case MunicipalAdvisorSteps.supervisingAuthorities:
      case MunicipalAdvisorSteps.civilDefensePredefinedConditions:
      case MunicipalAdvisorSteps.cleaningMechanisms:
      case MunicipalAdvisorSteps.commercialOffices:
      case MunicipalAdvisorSteps.engineeringOffices:
      case MunicipalAdvisorSteps.additionalInformation:
      case MunicipalAdvisorSteps.attachmentsRequired:
      case MunicipalAdvisorSteps.requestPath:
      case MunicipalAdvisorSteps.endChat:
      case MunicipalAdvisorSteps.imtethal:
        return const SizedBox.shrink();
      case MunicipalAdvisorSteps.continueToFinancial:
        return const ContinueToFinancial();
      case MunicipalAdvisorSteps.licenseCost:
        return LicenseCost(license: data);
      case MunicipalAdvisorSteps.continueToAttachments:
        return const ContinueToAttachments();
      case MunicipalAdvisorSteps.attachments:
        return const AttachmentsSelector();
      case MunicipalAdvisorSteps.continueToRequestPath:
        return const ContinueToRequestPath();
    }
  }
}
