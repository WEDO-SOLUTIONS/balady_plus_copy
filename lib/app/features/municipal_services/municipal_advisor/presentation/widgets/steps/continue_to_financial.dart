import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../municipal_advisor_exports.dart'
    show
        ChatBubbleRadioSelector,
        MunicipalAdvisorBloc,
        MunicipalAdvisorAddMessageEvent,
        MunicipalAdvisorSteps;

class ContinueToFinancial extends StatelessWidget {
  const ContinueToFinancial({super.key});

  @override
  Widget build(BuildContext context) {
    return ChatBubbleRadioSelector(
      items: [
        'municipalAdvisorFinancialAnswer1'.tr(),
        'municipalAdvisorFinancialAnswer2'.tr(),
      ],
      onSelected: (value) {
        context.read<MunicipalAdvisorBloc>().add(
              MunicipalAdvisorAddMessageEvent(
                message: value,
                step: MunicipalAdvisorSteps.continueToFinancial,
              ),
            );
      },
    );
  }
}
