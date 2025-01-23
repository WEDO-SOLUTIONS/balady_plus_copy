import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/utils/utils_exports.dart'
    show StringIconChecker;

class NetworkIconBasedTypeWidget extends StatelessWidget {
  final Object icon;
  final double iconSize;
  final Color? iconColor;
  const NetworkIconBasedTypeWidget({
    super.key,
    required this.icon,
    this.iconSize = 18.0,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    if (icon is String && (icon as String).isSvgIcon) {
      return SvgPicture.network(
        icon as String,
        height: iconSize,
        width: iconSize,
        color: iconColor,
      );
    } else {
      return Image.network(
        icon as String,
        height: iconSize,
        width: iconSize,
        color: iconColor,
      );
    }
  }
}
