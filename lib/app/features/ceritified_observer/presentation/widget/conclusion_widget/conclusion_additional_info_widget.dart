import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/card_parameter.dart';
import 'package:balady_plus/app/features/ceritified_observer/domain/lookups.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/blocs/choose_muncipality_bloc.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/widget/expandable_with_controller_widget.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class AdditionalInfoConclusionWidget extends StatelessWidget {
  final ChooseMuncipalityState state;

  const AdditionalInfoConclusionWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return ExpandableWithControllerWidget(
      title: 'additional_info'.tr(),
      controller: ExpandableController(),
      expanded: Column(
        children: [
          CardParameter(
            title: SurveyQuestion.surveyQuestion1.name.tr(),
            value: state.requestData!.surveyQuestion1! ? "yes".tr() : "no".tr(),
          ),
          CardParameter(
            title: SurveyQuestion.surveyQuestion2.name.tr(),
            value: state.requestData!.surveyQuestion2! ? "yes".tr() : "no".tr(),
          ),
          CardParameter(
            title: SurveyQuestion.surveyQuestion3.name.tr(),
            value: state.requestData!.surveyQuestion3! ? "yes".tr() : "no".tr(),
          ),
          CardParameter(
            title: SurveyQuestion.surveyQuestion4.name.tr(),
            value: state.requestData!.surveyQuestion4! ? "yes".tr() : "no".tr(),
          ),
        ],
      ),
    );
  }
}
