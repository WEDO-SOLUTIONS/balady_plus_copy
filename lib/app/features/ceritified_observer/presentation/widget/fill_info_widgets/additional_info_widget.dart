import 'package:balady_plus/app/features/ceritified_observer/domain/lookups.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/blocs/choose_muncipality_bloc.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/widget/expandable_with_controller_widget.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/widget/fill_info_widgets/survey_question_widget.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class AdditionalInfoWidget extends StatelessWidget {
  final ChooseMuncipalityState state;
  final ExpandableController expandableController;

  const AdditionalInfoWidget({
    super.key,
    required this.state,
    required this.expandableController,
  });

  @override
  Widget build(BuildContext context) {
    return ExpandableWithControllerWidget(
      title: 'additional_info'.tr(),
      controller: expandableController,
      expanded: Column(
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
      ),
    );
  }
}
