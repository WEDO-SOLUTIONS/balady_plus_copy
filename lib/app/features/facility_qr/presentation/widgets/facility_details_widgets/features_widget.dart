import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show CustomTextWidget, CustomHorizontalSpace;

class FeaturesWidget extends StatelessWidget {
  final bool available;
  final String title;

  const FeaturesWidget({Key? key, required this.title, required this.available})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Wrap(
        children: [
          Image.asset(
            !available ? IconPath.qrNotAvailableIcon : IconPath.qrAvailableIcon,
            height: 14,
            width: 14,
          ),
          const CustomHorizontalSpace(
            width: 4,
          ),
          CustomTextWidget(
            title,
            fontColor: AppColor.black500,
            fontSize: 13,
            fontWeight: AppFontWeight.medium,
          ),
        ],
      ),
    );
  }
}
