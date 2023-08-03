import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CustomSvgIconWidget(
            IconPath.note2,
            iconSize: 52,
            iconColor: AppColor.primary200Light,
          ),
          const SizedBox(height: 6),
          CustomTextWidget(
            "noData".tr(),
            fontSize: 18,
            fontWeight: AppFontWeight.bold,
            fontColor: AppColor.blackModern600Light,
          ),
        ],
      ),
    );
  }
}
