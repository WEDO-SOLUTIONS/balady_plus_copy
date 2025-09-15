import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/extensions/str_conversion.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_svg_image/cached_network_svg_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/utils/common_function.dart';

class ImageIconBasedTypeWidget extends StatelessWidget {
  final String icon;
  final String? type;
  final double iconSize;
  final Color? iconColor;
  final BoxFit fit;

  const ImageIconBasedTypeWidget({
    super.key,
    required this.icon,
    this.type,
    this.iconSize = 18.0,
    this.iconColor = AppColor.primary900Light,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    if (!icon.contains("http")) {
      // Local asset icons
      if ((icon).isSvgIcon) {

        return SvgPicture.asset(
          icon,
          height: iconSize,
          width: iconSize,
          colorFilter: iconColor != null
              ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
              : null,
          fit: fit,
        );
      } else if ((icon).isImgIcon) {

        return Image.asset(
          icon,
          height: iconSize,
          width: iconSize,
          color: iconColor,
          colorBlendMode: BlendMode.srcIn,
          fit: fit,
        );
      }
    } else {
      // Remote icons
      if ((icon).isSvgIcon || type == "svg") {

        return CachedNetworkSVGImage(
          icon,
          placeholder: const SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(),
          ),
          headers: {
            "verifyingKEY": hashRequest(icon, "GET"),
          },
          errorWidget: ImageIconBasedTypeWidget(
            icon: IconPath.serviceIcon(icon.split("/").last),
            iconSize: iconSize,
            iconColor: iconColor,
            fit: fit,
          ),
          width: iconSize,
          height: iconSize,
          fadeDuration: const Duration(milliseconds: 500),
          colorFilter: iconColor != null
              ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
              : null,
        );
      } else {

        return CachedNetworkImage(
          imageUrl: icon,
          httpHeaders: {
            "verifyingKEY": hashRequest(icon, "GET"),
          },
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
          color: iconColor,
          colorBlendMode: BlendMode.srcIn,
        );
      }
    }

    return const SizedBox();
  }
}
