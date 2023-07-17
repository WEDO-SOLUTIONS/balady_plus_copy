import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../municipal_advisor_exports.dart'
    show
        ChatMessage,
        InputSummary,
        LicenseCostResponse,
        MunicipalAdvisorBloc,
        MunicipalAdvisorState,
        MunicipalAdvisorSteps,
        PermitsCost,
        RequirementsList,
        SupervisingAuthorities,
        TotalCost,
        TradeLicenseCost;

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
              requirements: state.issuingPredefinedConditions ?? [],
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
              requirements:
                  state.licensePermits?.map((e) => e.name).toList() ?? [],
            );
          },
        );
      case MunicipalAdvisorSteps.civilDefensePredefinedConditions:
        return BlocBuilder<MunicipalAdvisorBloc, MunicipalAdvisorState>(
          buildWhen: (previous, current) =>
              previous.civilDefensePredefinedConditions !=
              current.civilDefensePredefinedConditions,
          builder: (context, state) {
            return RequirementsList(
              number: 4,
              title: "municipalAdvisorCivilDefenseTitle".tr(),
              requirements: state.civilDefensePredefinedConditions ?? [],
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
              number: 8,
              title: "municipalAdvisorAdvertisingOfficesTitle".tr(),
              requirements:
                  state.commercialOffices?.map((e) => e.officeName).toList() ??
                      [],
            );
          },
        );
      case MunicipalAdvisorSteps.licenseCost:
        if (chatMessage.data == 'tradeLicense') {
          return const TradeLicenseCost();
        } else if (chatMessage.data == 'permits') {
          return const PermitsCost();
        } else if (chatMessage.data == 'total') {
          return const TotalCost();
        }
        return const SizedBox.shrink();
      default:
        return const SizedBox.shrink();
    }
  }
}
