import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/self_ratiing/presentation/widgets/self_rating_result_widgets/self_rating_result_section.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../data/models/rating_self_success_result.dart';
import 'self_rating_result_violation.dart';

class SelfRatingResultNotCompleted extends StatelessWidget {
  final RatingSelfSuccessResult result;
  const SelfRatingResultNotCompleted({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SelfRatingResultSection(
        result: result,
      ),
      CustomVerticalSpace(
        height: 24,
      ),
      CustomTextWidget(
        "violations".tr(),
        fontWeight: AppFontWeight.bold,
        fontSize: 16,
        fontColor: AppColor.blackModern900Light,
      ),
      CustomVerticalSpace(height: 16),
      ListView.builder(
          itemCount: result.complianes.length ?? 0,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (ctx, index) {
            return SelfRatingResultViolation(
                title: result.complianes[index].condition,
                procdures: result.complianes[index].procedure);
          }),
      ElevatedButtonWidget.primaryCustom(
          text: "rating_again".tr(),
          onPressed: () {
            Navigator.pushReplacementNamed(
                context, RouteName.selfRatingMainPage);
          })
    ]);
  }
}
