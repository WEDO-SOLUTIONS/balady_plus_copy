import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../data/models/regulation_clause_response.dart';

class ViolationDetailsWidget extends StatelessWidget {
  final RegulationClauseItem item;
  const ViolationDetailsWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 14,
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColor.grayLight100,
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              flex: 2,
              child: CustomTextWidget(
                item.regulationClauseText ?? "",
                maxLines: 10,
                textStyle: AppStyle.violationListTitleStyle,
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextWidget(
                    'start_from'.tr(),
                    textStyle: AppStyle.violationStartFromStyle,
                  ),
                  Row(
                    children: [
                      CustomTextWidget(
                        item.baseFineAmount ?? "",
                        textStyle: AppStyle.violationNumberStyle1,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Flexible(
                        child: CustomTextWidget(
                          item.unit ?? "",
                          maxLines: 2,
                          textStyle: AppStyle.violationRiyalPerWorkerStyle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ]),
        ),
      ],
    );
  }
}
