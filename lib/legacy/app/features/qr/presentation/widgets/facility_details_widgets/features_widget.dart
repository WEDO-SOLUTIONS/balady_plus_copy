import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show CustomTextWidget, CustomHorizontalSpace, CustomSvgIconWidget;

class FeaturesWidget extends StatelessWidget {
  final bool available;
  final String title;
  final String icon;

  const FeaturesWidget(
      {Key? key,
      required this.title,
      required this.available,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6), color: AppColor.green60),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          CustomSvgIconWidget(
            icon,
            iconColor:
                available ? AppColor.primary600Light : AppColor.primary200Light,
          ),
          const CustomHorizontalSpace(
            width: 4,
          ),
          CustomTextWidget(
            title,
            fontColor: available
                ? AppColor.blackModern600Light
                : AppColor.primary200Light,
            fontSize: 12,
            fontWeight: AppFontWeight.bold,
          ),
        ],
      ),
    );
  }
}
