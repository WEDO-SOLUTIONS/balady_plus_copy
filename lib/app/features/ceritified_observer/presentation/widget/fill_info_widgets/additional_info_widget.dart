import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/expandable_card.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/fields/read_only_field.dart';
import 'package:balady_plus/app/features/ceritified_observer/domain/lookups.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/blocs/choose_muncipality_bloc.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/widget/fill_info_widgets/survey_question_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class AdditionalInfoWidget extends StatelessWidget {
  final ChooseMuncipalityState state;

  const AdditionalInfoWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      title: 'vd_user_info'.tr(),
      children: [
        SurveyQuestionWidget(
          name: SurveyQuestion.surveyQuestion1.name,
          groupValue: state.requestData?.surveyQuestion1,
          onChange: (value) {
            context.read<ChooseMuncipalityBloc>().add(
                  SetRequestDataEvent(
                    dataModel: state.requestData!.copyWith(
                      surveyQuestion1: value,
                    ),
                  ),
                );
          },
        ),
        SurveyQuestionWidget(
          name: SurveyQuestion.surveyQuestion2.name,
          groupValue: state.requestData?.surveyQuestion2,
          onChange: (value) {
            context.read<ChooseMuncipalityBloc>().add(
                  SetRequestDataEvent(
                    dataModel: state.requestData!.copyWith(
                      surveyQuestion2: value,
                    ),
                  ),
                );
          },
        ),
        SurveyQuestionWidget(
          name: SurveyQuestion.surveyQuestion3.name,
          groupValue: state.requestData?.surveyQuestion3,
          onChange: (value) {
            context.read<ChooseMuncipalityBloc>().add(
                  SetRequestDataEvent(
                    dataModel: state.requestData!.copyWith(
                      surveyQuestion3: value,
                    ),
                  ),
                );
          },
        ),

        SurveyQuestionWidget(
          name: SurveyQuestion.surveyQuestion4.name,
          groupValue: state.requestData?.surveyQuestion4,
          onChange: (value) {
            context.read<ChooseMuncipalityBloc>().add(
                  SetRequestDataEvent(
                    dataModel: state.requestData!.copyWith(
                      surveyQuestion4: value,
                    ),
                  ),
                );
          },
        ),
      ],
    );
  }
}
