import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/extensions/str_conversion.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_svg_image/cached_network_svg_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


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
    if (!icon.contains("http")) {
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
    } else {
      if ((icon).isSvgIcon) {
        return CachedNetworkSVGImage(
          icon,
          placeholder: const SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(),
          ),
          errorWidget: ImageIconBasedTypeWidget(
            icon: IconPath.serviceIcon(icon.split("/").last),
            iconSize: iconSize,
            iconColor: iconColor,
            fit: fit,
          ),
          width: iconSize,
          height: iconSize,
          fadeDuration: const Duration(milliseconds: 500),
          color: iconColor,
        );
      } else {
        return CachedNetworkImage(
          imageUrl: icon,
          progressIndicatorBuilder: (context, url, downloadProgress) {
            return SizedBox(
              width: 40,
              height: 40,
              child:
              CircularProgressIndicator(value: downloadProgress.progress),
            );
          },
          errorWidget: (context, url, error) {
            return ImageIconBasedTypeWidget(
              icon: IconPath.serviceIcon(icon.split("/").last),
              iconSize: iconSize,
              iconColor: iconColor,
              fit: fit,
            );
          },
          width: iconSize,
          height: iconSize,
          fit: fit,
        );
      }
    }

    return const SizedBox();
  }
}
