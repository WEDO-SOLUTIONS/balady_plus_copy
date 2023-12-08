import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/constants/dialog_names.dart';
import '../../../municipal_advisor_exports.dart'
    show
        AdditionalInformation,
        AttachmentEntity,
        AttachmentRequired,
        ChatMessage,
        InputSummary,
        MunicipalAdvisorBloc,
        MunicipalAdvisorState,
        MunicipalAdvisorSteps,
        PermitsCost,
        RequestFlow,
        RequirementsList,
        SelectedAdditionalActivities,
        SupervisingAuthorities,
        TotalCost,
        TradeLicenseCost,
        UserAttachmentsRequest;

class ChatBubbleStepData extends StatelessWidget {
  final ChatMessage chatMessage;

  const ChatBubbleStepData({
    super.key,
    required this.chatMessage,
  });

  @override
  Widget build(BuildContext context) {
    switch (chatMessage.step) {
      case MunicipalAdvisorSteps.inputSummary:
        return const InputSummary();
      case MunicipalAdvisorSteps.issuingPredefinedConditions:
        return BlocBuilder<MunicipalAdvisorBloc, MunicipalAdvisorState>(
          buildWhen: (previous, current) =>
              previous.issuingPredefinedConditions !=
              current.issuingPredefinedConditions,
          builder: (context, state) {
            return RequirementsList(
              number: 1,
              title: "municipalAdvisorRequirementsTitle".tr(),
              requirements: state.issuingPredefinedConditions,
            );
          },
        );
      case MunicipalAdvisorSteps.licensePermits:
        return BlocBuilder<MunicipalAdvisorBloc, MunicipalAdvisorState>(
          buildWhen: (previous, current) =>
              previous.licensePermits != current.licensePermits,
          builder: (context, state) {
            return RequirementsList(
              number: 2,
              title: "municipalAdvisorPermitsTitle".tr(),
              requirements: state.licensePermits.map((e) => e.name).toList(),
            );
          },
        );
      case MunicipalAdvisorSteps.selectedAdditionalActivities:
        return const SelectedAdditionalActivities();
      case MunicipalAdvisorSteps.civilDefensePredefinedConditions:
        return BlocBuilder<MunicipalAdvisorBloc, MunicipalAdvisorState>(
          buildWhen: (previous, current) =>
              previous.civilDefensePredefinedConditions !=
              current.civilDefensePredefinedConditions,
          builder: (context, state) {
            return RequirementsList(
              number: 4,
              title: "municipalAdvisorCivilDefenseTitle".tr(),
              requirements: state.civilDefensePredefinedConditions,
            );
          },
        );
      case MunicipalAdvisorSteps.supervisingAuthorities:
        return const SupervisingAuthorities();
      case MunicipalAdvisorSteps.cleaningMechanisms:
        return BlocBuilder<MunicipalAdvisorBloc, MunicipalAdvisorState>(
          buildWhen: (previous, current) =>
              previous.cleaningMechanisms != current.cleaningMechanisms,
          builder: (context, state) {
            return RequirementsList(
              number: 6,
              title: "municipalAdvisorCleaningMechanismsTitle".tr(),
              requirements:
                  state.cleaningMechanisms.map((e) => e.name).toList(),
            );
          },
        );
      case MunicipalAdvisorSteps.commercialOffices:
        return BlocBuilder<MunicipalAdvisorBloc, MunicipalAdvisorState>(
          buildWhen: (previous, current) =>
              previous.commercialOffices != current.commercialOffices,
          builder: (context, state) {
            return RequirementsList(
              number: 7,
              title: "municipalAdvisorAdvertisingOfficesTitle".tr(),
              requirements:
                  state.commercialOffices.map((e) => e.officeName).toList(),
            );
          },
        );
      case MunicipalAdvisorSteps.engineeringOffices:
        return BlocBuilder<MunicipalAdvisorBloc, MunicipalAdvisorState>(
          buildWhen: (previous, current) =>
              previous.engineeringOffices != current.engineeringOffices,
          builder: (context, state) {
            return RequirementsList(
              number: 8,
              title: "municipalAdvisorEngineeringOfficesTitle".tr(),
              requirements:
                  state.engineeringOffices.map((e) => e.officeName).toList(),
            );
          },
        );
      case MunicipalAdvisorSteps.additionalInformation:
        return const AdditionalInformation();
      case MunicipalAdvisorSteps.licenseCost:
        if (chatMessage.data == 'tradeLicense') {
          return const TradeLicenseCost();
        } else if (chatMessage.data == 'permits') {
          return const PermitsCost();
        } else if (chatMessage.data == 'total') {
          return const TotalCost();
        }
        return const SizedBox.shrink();
      case MunicipalAdvisorSteps.attachmentsRequired:
        if (chatMessage.data is AttachmentEntity) {
          return AttachmentRequired(
            attachment: chatMessage.data as AttachmentEntity,
          );
        } else if (!chatMessage.isResponse) {
          return const UserAttachmentsRequest();
        }
        return const SizedBox.shrink();
      case MunicipalAdvisorSteps.requestPath:
        return BlocBuilder<MunicipalAdvisorBloc, MunicipalAdvisorState>(
          builder: (context, state) {
            if (chatMessage.data == 'requestPath') {
              return RequestFlow(steps: state.requestFlow);
            } else if (chatMessage.data ==
                'municipalAdvisorRequestPathSuggestions') {
              return RequirementsList(
                title: '',
                requirements: state.requestFlowRecommendations,
              );
            }
            return const SizedBox.shrink();
          },
        );

      case MunicipalAdvisorSteps.imtethal:
        return BlocBuilder<MunicipalAdvisorBloc, MunicipalAdvisorState>(
          buildWhen: (previous, current) =>
              previous.buildingComplince != current.buildingComplince,
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 10),
              child: ElevatedIconButtonWidget.download(
                onPressed: () async {
                  await BottomSheetDialog.showDraggableSheet(
                    context,
                    dialogKeyName: DialogName.buildingComplianceDialog,
                    currentRouteName: RouteName.municipalAdvisor,
                    child: BuildingRequirementsDialog(),
                  );
                },
                text: "downloadImtethalDocumwnt".tr(),
              ),
            );
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
