import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/utils_exports.dart' show RouteName;
import '../../../municipal_advisor_exports.dart'
    show
        ChatBubbleRadioSelector,
        MunicipalAdvisorBloc,
        MunicipalAdvisorRemoveLastChatEvent,
        MunicipalAdvisorAddMessageEvent,
        MunicipalAdvisorSteps;

class ConfirmLocation extends StatelessWidget {
  const ConfirmLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return ChatBubbleRadioSelector(
      items: [
        'municipalAdvisorLocationCorrectAnswer1'.tr(),
        'municipalAdvisorLocationCorrectAnswer2'.tr(),
      ],
      onChoose: (value) {
        if (value == 'municipalAdvisorLocationCorrectAnswer1'.tr()) {
          context.read<MunicipalAdvisorBloc>().add(
                MunicipalAdvisorAddMessageEvent(
                  message: value,
                  step: MunicipalAdvisorSteps.confirmLocation,
                ),
              );
        } else {
          Navigator.of(context).pushNamed(
            RouteName.locationPage,
            arguments: context.read<MunicipalAdvisorBloc>(),
          );
          context.read<MunicipalAdvisorBloc>().add(
                const MunicipalAdvisorRemoveLastChatEvent(count: 2),
              );
        }
      },
    );
  }
}
