import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, PrimaryIcons, trans;
import 'package:balady_plus/etmam_app/features/providers/providers_exports.dart'
    show EvaluatorsHorizontalList;
import 'package:flutter/material.dart';

import '../../../../_shared_feature_/shared/shared_feature_exports.dart'
    show
        CustomVerticalSpace,
        HeaderWithViewAllWidget,
        RatingEvaluationWidget,
        SectionTitleWidget;

class ProviderEvaluationSectionWidget extends StatelessWidget {
  const ProviderEvaluationSectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double rating = 0.7;
    double evaluation = 955;
    return Container(
        decoration: const BoxDecoration(
          color: AppColor.white,
          boxShadow: [
            BoxShadow(
                color: Color(0x14d1d5db),
                offset: Offset(-2, 4),
                blurRadius: 8,
                spreadRadius: 0)
          ],
        ),
        child: Container(
            padding: const EdgeInsets.all(16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SectionTitleWidget(
                title: trans('evaluations'),
                primaryIcon: PrimaryIcons.providerEvaluationIcon,
              ),
              RatingEvaluationWidget(
                rating: rating,
                totalEvaluation: evaluation,
                withEvaluationWord: true,
              ),
              HeaderWithViewAllWidget(
                headerText: trans('customer_evaluations'),
                headerTextColor: AppColor.greyText,
                headerTextSize: 14,
                headerFontWeight: AppFontWeight.medium,
                margin: const EdgeInsets.only(top: 17),
                btnPressed: () {
                  print('view all');
                },
              ),
              const CustomVerticalSpace(height: 24),
              const EvaluatorsHorizontalList(),
            ])));
  }
}
