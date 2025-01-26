import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/utils/utils_exports.dart'
    show StringIconChecker;

class ImageIconBasedTypeWidget extends StatelessWidget {
  final String icon;
  final double iconSize;
  final Color? iconColor;
  final BoxFit fit;
  const ImageIconBasedTypeWidget({
    super.key,
    required this.icon,
    this.iconSize = 18.0,
    this.iconColor,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    if(icon.contains("http")) {
      if ((icon).isSvgIcon) {
        return SvgPicture.asset(
          icon,
          height: iconSize,
          width: iconSize,
          color: iconColor,
          fit: fit,
        );
      } else if ((icon).isImgIcon) {
        return Image.asset(
          icon,
          height: iconSize,
          width: iconSize,
          color: iconColor,
          fit: fit,
        );
      }
    } else {
      if ((icon).isSvgIcon) {
        return SvgPicture.network(
          icon,
          height: iconSize,
          width: iconSize,
          color: iconColor,
          fit: fit,
        );
      } else {
        return Image.network(
          icon,
          height: iconSize,
          width: iconSize,
          color: iconColor,
          fit: fit,
        );
      }
    }

    return const SizedBox();
  }
}
