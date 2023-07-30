import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show DrawLineWidget, CustomTextWidget, CustomSvgIconWidget;
import 'package:flutter/material.dart';

class ProfileItem extends StatelessWidget {
  final String title;
  final bool showBottomLine;
  final Function onPressed;
  final double topPadding;

  const ProfileItem(
      {Key? key,
      required this.title,
      this.showBottomLine = false,
      required this.onPressed,
      this.topPadding = 21})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            onPressed();
          },
          child: Container(
            padding: EdgeInsets.only(top: topPadding, bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomTextWidget(
                  title,
                  fontColor: AppColor.black,
                  fontSize: 16,
                  fontWeight: AppFontWeight.medium,
                ),
                const CustomSvgIconWidget(
                  IconPath.leftArrow,
                  iconSize: 24,
                ),
              ],
            ),
          ),
        ),
        if (showBottomLine)
          const DrawLineWidget(
            lineColor: AppColor.lightGray,
            lineHeight: 0.5,
          )
      ],
    );
  }
}
