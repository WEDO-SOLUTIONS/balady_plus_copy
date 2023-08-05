import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../municipal_advisor_exports.dart'
    show
        ChatBubbleRadioSelector,
        MunicipalAdvisorBloc,
        MunicipalAdvisorAddMessageEvent,
        MunicipalAdvisorSteps;

class TopicSelector extends StatelessWidget {
  const TopicSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return ChatBubbleRadioSelector(
      items: [
        'municipalAdvisorTopicAnswer1'.tr(),
        // 'municipalAdvisorTopicAnswer4'.tr()
      ],
      onChoose: (value) {
        context.read<MunicipalAdvisorBloc>().add(
              MunicipalAdvisorAddMessageEvent(
                message: value,
                step: MunicipalAdvisorSteps.topic,
              ),
            );
      },
    );
  }
}
