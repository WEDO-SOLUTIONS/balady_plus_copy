import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/radio_custom.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../domain/entities/comliance_request_details.dart';

class ComplianceImageWidget extends StatelessWidget {
  EmtithalItem? item;
  final Function onChange;

  ComplianceImageWidget({super.key, this.item, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16, top: 16),
      padding: const EdgeInsets.only(bottom: 16, top: 16, left: 8, right: 8),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(3.9),
      ),
      child: Column(
        children: [
          /*Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                ImagePath.complianceFirstImage,
                width: 149,
              ),
              const SizedBox(
                width: 6,
              ),
              Image.asset(
                ImagePath.complianceSecondImage,
                width: 149,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),*/
          CustomTextWidget(
            item?.itemDesc ?? "",
            textStyle: AppStyle.complianceClausesTextStyle,
            maxLines: 10,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleRatioOption(
                value: 1,
                selected: (item?.submitterAnswer == true) ? 1 : 0,
                title: 'compliance'.tr(),
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.05,
                titleStyle: AppStyle.complianceClausesOptionStyle,
                onChanged: (int val) {
                  item?.submitterAnswer = val;
                  onChange(item);
                },
              ),
              const SizedBox(
                width: 6,
              ),
              SingleRatioOption(
                title: 'nonـcompliance'.tr(),
                value: 2,
                selected: (item?.submitterAnswer == false) ? 2 : 0,
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.05,
                titleStyle: AppStyle.complianceClausesOptionStyle,
                onChanged: (int val) {
                  item?.submitterAnswer = val;
                  onChange(item);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
