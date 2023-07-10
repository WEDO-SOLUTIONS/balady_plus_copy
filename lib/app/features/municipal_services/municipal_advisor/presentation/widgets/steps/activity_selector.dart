import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../municipal_advisor_exports.dart'
    show
        ChatBubbleRadioSelector,
        MunicipalAdvisorBloc,
        MunicipalAdvisorStartChatEvent,
        MunicipalAdvisorSteps;

class ActivitySelector extends StatelessWidget {
  const ActivitySelector({super.key});

  @override
  Widget build(BuildContext context) {
    return ChatBubbleRadioSelector(
      items: const [],
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
