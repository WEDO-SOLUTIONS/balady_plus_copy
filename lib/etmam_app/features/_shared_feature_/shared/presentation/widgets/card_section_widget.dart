import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show AppColor, AppFontWeight;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show CustomHorizontalSpace, CustomSvgIconWidget, CustomTextWidget;
import 'package:flutter/material.dart';

class CardSectionWidget extends StatelessWidget {
  final String? icon;
  final double iconHeight;
  final double iconWidth;
  final String label;
  final double labelSize;
  final Color labelColor;
  final VoidCallback? onPressed;

  const CardSectionWidget(
      {Key? key,
      this.icon,
      required this.label,
      this.iconHeight = 17.0,
      this.iconWidth = 17.0,
      this.labelSize = 16.0,
      this.labelColor = AppColor.hunterGreen,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        child: Row(
          children: [
            if (icon != null)
              CustomSvgIconWidget(
                icon!,
                iconHeight: iconHeight,
                iconWidth: iconWidth,
              ),
            CustomHorizontalSpace(width: 12),
            Expanded(
              child: CustomTextWidget(
                label,
                fontSize: labelSize,
                fontColor: labelColor,
                fontWeight: AppFontWeight.medium,
                textAlign: TextAlign.start,
              ),
            )
          ],
        ),
      ),
    );
  }
}
