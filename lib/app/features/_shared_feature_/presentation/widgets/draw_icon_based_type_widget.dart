import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart' show AppColor, StringIconChecker;
import '../../shared_feature_exports.dart' show CustomSvgIconWidget;

class DrawIconBasedTypeWidget extends StatelessWidget {
  final Object icon;
  final double iconSize;
  final Color? iconColor;
  const DrawIconBasedTypeWidget({super.key, required this.icon, this.iconSize = 18.0, this.iconColor});

  @override
  Widget build(BuildContext context) {
    if (icon is String && (icon as String).isSvgIcon) {
      return CustomSvgIconWidget(icon as String, iconSize: iconSize, iconColor: iconColor);
    } else if (icon is String && (icon as String).isImgIcon) {
      return Image.asset(icon as String, height: iconSize, width: iconSize, color: iconColor);
    } else if (icon is IconData) {
      return Icon((icon as IconData), size: iconSize, color: iconColor);
    } else {
      return Icon(Icons.error, size: iconSize, color: AppColor.error);
    }
  }
}
