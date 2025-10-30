import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../municipal_advisor_exports.dart'
    show
        ChatBubbleRadioSelector,
        MunicipalAdvisorBloc,
        MunicipalAdvisorSelectSalamaEvent;

class SalamaSelectorSummary extends StatelessWidget {
  const SalamaSelectorSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return ChatBubbleRadioSelector(
      items: [
        'yes'.tr(),
        'no'.tr(),
      ],
      onChoose: (value) {
        context.read<MunicipalAdvisorBloc>().add(
              MunicipalAdvisorSelectSalamaEvent(
                hasSalama: value == 'yes'.tr(),
              ),
            );
      },
    );
  }
}
