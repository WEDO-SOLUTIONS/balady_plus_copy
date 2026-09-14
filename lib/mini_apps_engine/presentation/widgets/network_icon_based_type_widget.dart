import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/extensions/str_conversion.dart';
import 'package:balady_plus/app/core/utils/constants/apis/env_types.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_svg_image/cached_network_svg_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:mapness/shared/utils/common_function.dart';

class ImageIconBasedTypeWidget extends StatelessWidget {
  final String icon;
  final String? type;
  final String? cdnLogoRef;
  final double iconSize;
  final Color? iconColor;
  final BoxFit fit;

  const ImageIconBasedTypeWidget({
    super.key,
    required this.icon,
    this.type,
    this.cdnLogoRef,
    this.iconSize = 18.0,
    this.iconColor = AppColor.primary900Light,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    // Build proper URL if icon is not a full URL
    String imageUrl = _buildImageUrl();

    if (!imageUrl.contains("http")) {
      // Local asset icons
      if ((imageUrl).isSvgIcon) {
        return SvgPicture.asset(
          imageUrl,
          height: iconSize,
          width: iconSize,
          colorFilter: iconColor != null ? ColorFilter.mode(iconColor!, BlendMode.srcIn) : null,
          fit: fit,
          placeholderBuilder: (context) => _buildFallbackIcon(),
        );
      } else if ((imageUrl).isImgIcon) {
        return Image.asset(
          imageUrl,
          height: iconSize,
          width: iconSize,
          color: iconColor,
          colorBlendMode: BlendMode.srcIn,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => _buildFallbackIcon(),
        );
      }
    } else {
      // Remote icons
      if ((imageUrl).isSvgIcon || type == "svg") {
        return CachedNetworkSVGImage(
          imageUrl,
          placeholder: SizedBox(
            width: iconSize,
            height: iconSize,
            child: const CircularProgressIndicator(strokeWidth: 2),
          ),
          headers: {"verifyingKEY": hashRequest(imageUrl, "GET")},
          errorWidget: _buildFallbackIcon(),
          width: iconSize,
          height: iconSize,
          fadeDuration: const Duration(milliseconds: 500),
          colorFilter: iconColor != null ? ColorFilter.mode(iconColor!, BlendMode.srcIn) : null,
        );
      } else {
        return CachedNetworkImage(
          imageUrl: imageUrl,
          httpHeaders: {"verifyingKEY": hashRequest(imageUrl, "GET")},
          progressIndicatorBuilder: (context, url, downloadProgress) {
            return SizedBox(
              width: iconSize,
              height: iconSize,
              child: CircularProgressIndicator(value: downloadProgress.progress, strokeWidth: 2),
            );
          },
          errorWidget: (context, url, error) => _buildFallbackIcon(),
          width: iconSize,
          height: iconSize,
          fit: fit,
          color: iconColor,
          colorBlendMode: BlendMode.srcIn,
        );
      }
    }

    return _buildFallbackIcon();
  }
  //!

  String _buildImageUrl() {
    // If icon is already a full URL, return as is
    if (icon.contains("http")) {
      return icon;
    }

    // If cdnLogoRef is provided and icon is not a local asset path, build URL
    if (cdnLogoRef != null && cdnLogoRef!.isNotEmpty && !icon.contains("assets/")) {
      try {
        final baseUrl = GetIt.instance<EnvType>().domain;
        return "${baseUrl}v1/balady-mini-apps/download/$cdnLogoRef";
      } catch (e) {
        // Fallback to original icon if EnvType is not available
        return icon;
      }
    }

    return icon;
  }

  Widget _buildFallbackIcon() {
    return Container(
      width: iconSize,
      height: iconSize,
      decoration: BoxDecoration(
        color: iconColor?.withValues(alpha: 0.1) ?? AppColor.primary900Light.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.apps, size: iconSize * 0.6, color: iconColor ?? AppColor.primary900Light),
    );
  }
}
