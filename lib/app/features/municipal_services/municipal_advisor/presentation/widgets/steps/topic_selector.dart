import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle;
import '../../../../../_shared_feature_/shared_feature_exports.dart'
    show CustomTextWidget, ElevatedButtonWidget;
import '../../../municipal_advisor_exports.dart'
    show
        MunicipalAdvisorBloc,
        MunicipalAdvisorStartChatEvent,
        MunicipalAdvisorSteps;

class TopicSelector extends StatefulWidget {
  const TopicSelector({super.key});

  @override
  State<TopicSelector> createState() => _TopicSelectorState();
}

class _TopicSelectorState extends State<TopicSelector> {
  String? selectedValue;
  final List<String> items = [
    'municipalAdvisorTopicAnswer1'.tr(),
    'municipalAdvisorTopicAnswer2'.tr(),
    'municipalAdvisorTopicAnswer3'.tr(),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        CustomTextWidget(
          'municipalAdvisorTopicHint'.tr(),
          textStyle: AppStyle.subMessageTextStle,
        ),
        Column(
          children: [
            for (var item in items)
              InkWell(
                onTap: () => setState(() => selectedValue = item),
                child: Container(
                  height: 56,
                  padding: const EdgeInsetsDirectional.only(start: 12),
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColor.primary50Light50,
                  ),
                  child: Row(
                    children: [
                      CustomTextWidget(
                        item,
                        textStyle: AppStyle.listTitleTextStyle,
                        maxLines: 2,
                      ),
                      const Spacer(),
                      Radio(
                        value: item,
                        groupValue: selectedValue,
                        activeColor: AppColor.primary700Light,
                        onChanged: (_) => setState(() => selectedValue = item),
                      )
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButtonWidget.choose(
              onPressed: selectedValue == null
                  ? null
                  : () {
                      context.read<MunicipalAdvisorBloc>().add(
                            MunicipalAdvisorStartChatEvent(
                              message: selectedValue!,
                              step: MunicipalAdvisorSteps.topic,
                            ),
                          );
                    },
            ),
          ],
        ),
      ],
    );
  }
}
