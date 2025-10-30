import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../municipal_advisor_exports.dart'
    show
        ChatBubbleRadioSelector,
        MunicipalAdvisorBloc,
        MunicipalAdvisorChangeStepEvent,
        MunicipalAdvisorSteps;

class ChangeInformation extends StatelessWidget {
  const ChangeInformation({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      'loaction'.tr(),
      'isicActivity'.tr(),
      'subActivity'.tr(),
      'facilityArea'.tr(),
    ];
    return ChatBubbleRadioSelector(
      items: items,
      onChoose: (value) {
        final index = items.indexOf(value);
        switch (index) {
          case 0:
            context.read<MunicipalAdvisorBloc>().add(
                  MunicipalAdvisorChangeStepEvent(
                    message: value,
                    step: MunicipalAdvisorSteps.topic,
                  ),
                );
            break;
          case 1:
            context.read<MunicipalAdvisorBloc>().add(
                  MunicipalAdvisorChangeStepEvent(
                    message: value,
                    step: MunicipalAdvisorSteps.confirmLocation,
                  ),
                );
            break;
          case 2:
            context.read<MunicipalAdvisorBloc>().add(
                  MunicipalAdvisorChangeStepEvent(
                    message: value,
                    step: MunicipalAdvisorSteps.activity,
                  ),
                );
            break;
          case 3:
            context.read<MunicipalAdvisorBloc>().add(
                  MunicipalAdvisorChangeStepEvent(
                    message: value,
                    step: MunicipalAdvisorSteps.subActivity,
                  ),
                );
            break;
        }
      },
    );
  }
}
