import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../data/models/regulation_clause_response.dart';

class ViolationDetailsWidget extends StatelessWidget {
  final RegulationClauseItem item;
  const ViolationDetailsWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColor.grayLight100,
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 14,
          ),
          Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: CustomTextWidget(
                      item.regulationClauseText ?? "",
                      maxLines: 30,
                      textStyle: AppStyle.violationListTitleStyle,
                    ),
                  ),
                ]),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColor.primary100Light,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomTextWidget(
                  'start_from'.tr(),
                  fontColor: AppColor.black800,
                  fontWeight: AppFontWeight.bold,
                  fontSize: 12,
                ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomTextWidget(
                        item.baseFineAmount ?? "",
                        fontColor: AppColor.primary900Light,
                        fontWeight: AppFontWeight.bold,
                        fontSize: 14,
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
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: AppColor.blackModern600Light,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
