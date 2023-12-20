import 'package:balady_plus/app/core/services/local/navigation_services.dart';
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

class SelfRatingResultCompleted extends StatelessWidget {
  final RatingSelfSuccessResult result;
  const SelfRatingResultCompleted({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SelfRatingResultSection(
        result: result,
      ),
      CustomVerticalSpace(
        height: 24,
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          CustomTextWidget(
            "rating_late_description".tr(),
            fontColor: AppColor.blackModern600Light,
            height: 1.64,
            maxLines: 90,
            fontSize: 14,
            fontWeight: AppFontWeight.bold,
          ),
          CustomVerticalSpace(height: 28),
          CustomTextWidget(
            "rating_last_description2".tr(),
            fontColor: AppColor.secondary900Light,
            height: 1.71,
            maxLines: 90,
            fontSize: 14,
            fontWeight: AppFontWeight.medium,
          ),
          CustomVerticalSpace(height: 16),
          ElevatedButtonWidget.primaryCustom(
              text: "complinace_isue".tr(),
              onPressed: () {
                NavigationService.navigatorKey.currentState!
                    .pushNamed(RouteName.createCompliancePage);
              })
        ]),
      ),
    ]);
  }
}
