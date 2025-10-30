import 'package:flutter/material.dart';

import '../../../../../../app/core/utils/constants/app_colors.dart';
import '../../../../../../app/core/utils/constants/constants.dart';
import '../../../../../../app/core/utils/enums/enums.dart';
import '../../../../../../app/features/_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';

class CustomIconButtonWidget extends StatelessWidget {
  final Color backgroundColor;
  final Color borderColor;
  final double borderRadius;
  final double borderWidth;
  final double btnWidth;
  final double btnHeight;
  final VoidCallback btnPressed;
  final String? svgIcon;
  final double svgIconHeight;
  final double svgIconWidth;
  final Color? svgIconColor;
  final IconData? materialIcon;
  final MATERIAL_ICON_DIRECTION materialIconDirection;
  final Color materialIconColor;
  final double materialIconSize;
  final String image;
  final Color? imageColor;
  final bool isVisible;

  const CustomIconButtonWidget(
      {Key? key,
      this.backgroundColor = Colors.transparent,
      this.borderColor = Colors.transparent,
      this.borderRadius = 4.0,
      this.borderWidth = 1.0,
      this.btnHeight = 24.0,
      this.btnWidth = 24.0,
      this.image = "",
      required this.btnPressed,
      this.svgIcon,
      this.svgIconHeight = 24.0,
      this.svgIconWidth = 24.0,
      this.svgIconColor,
      this.materialIcon,
      this.materialIconDirection = MATERIAL_ICON_DIRECTION.left,
      this.materialIconColor = AppColor.black,
      this.materialIconSize = 18.0,
      this.imageColor,
      this.isVisible = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Container(
        width: btnWidth,
        height: btnHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: borderColor, width: borderWidth),
        ),
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: btnPressed,
          child: svgIcon != null
              ? CustomSvgIconWidget(
                  svgIcon!,
                  iconHeight: svgIconHeight,
                  iconWidth: svgIconWidth,
                  iconColor: svgIconColor,
                )
              : RotatedBox(
                  quarterTurns: _getMaterialIconDirection(),
                  child: image.isNotEmpty
                      ? Image.asset(
                          Constants.imgPath + image,
                          color: imageColor,
                        )
                      : Icon(
                          materialIcon ?? Icons.arrow_back_ios_new,
                          color: materialIconColor,
                          size: materialIconSize,
                        ),
                ),
        ),
      ),
    );
  }

  int _getMaterialIconDirection() {
    switch (materialIconDirection) {
      case MATERIAL_ICON_DIRECTION.left:
        return 0;
      case MATERIAL_ICON_DIRECTION.up:
        return 1;
      case MATERIAL_ICON_DIRECTION.right:
        return 2;
      case MATERIAL_ICON_DIRECTION.down:
        return 3;
    }
  }
}
