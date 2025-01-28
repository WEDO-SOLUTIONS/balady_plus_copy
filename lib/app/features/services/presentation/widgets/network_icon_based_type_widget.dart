import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_svg_image/cached_network_svg_image.dart';
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
    this.iconColor = const Color(0xff31C3B9),
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {

    if(!icon.contains("http")) {
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
          // color: iconColor,
          fit: fit,
        );
      }
    } else {;
      if ((icon).isSvgIcon) {
        return CachedNetworkSVGImage(
          icon,
          placeholder: const CircularProgressIndicator(color: Colors.green),
          errorWidget: const Icon(Icons.error, color: Colors.red),
          width: iconSize,
          height: iconSize,
          fadeDuration: const Duration(milliseconds: 500),
        );
        return SvgPicture.network(
          icon,
          height: iconSize,
          width: iconSize,
          color: iconColor,
          fit: fit,
        );
      } else {
        return CachedNetworkImage(
          imageUrl: icon,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              CircularProgressIndicator(value: downloadProgress.progress),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          width: iconSize,
          height: iconSize,
          fit: fit,
        );
        return Image.network(
          icon,
          height: iconSize,
          width: iconSize,
          // color: iconColor,
          fit: fit,
        );
      }
    }

    return const SizedBox();
  }
}
