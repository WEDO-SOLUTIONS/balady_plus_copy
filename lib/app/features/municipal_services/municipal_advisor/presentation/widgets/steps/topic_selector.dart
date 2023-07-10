import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../municipal_advisor_exports.dart'
    show
        ChatBubbleRadioSelector,
        MunicipalAdvisorBloc,
        MunicipalAdvisorStartChatEvent,
        MunicipalAdvisorSteps;

class TopicSelector extends StatelessWidget {
  const TopicSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return ChatBubbleRadioSelector(
      items: [
        'municipalAdvisorTopicAnswer1'.tr(),
        'municipalAdvisorTopicAnswer2'.tr(),
        'municipalAdvisorTopicAnswer3'.tr(),
      ],
      onSelected: (value) {
        context.read<MunicipalAdvisorBloc>().add(
              MunicipalAdvisorStartChatEvent(
                message: value,
                step: MunicipalAdvisorSteps.topic,
              ),
            );
      },
    );
  }
}
