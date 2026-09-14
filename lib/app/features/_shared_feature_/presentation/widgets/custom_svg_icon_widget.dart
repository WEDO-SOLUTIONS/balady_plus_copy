import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart' show SvgPicture;
import 'package:shimmer/shimmer.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../entry_point/presentation/cubit/auth_cubit.dart';

class CustomSvgIconWidget extends StatelessWidget {
  final String iconPath;
  final double? iconSize;
  final double? iconWidth;
  final double? iconHeight;
  final Color? iconColor;
  final AlignmentGeometry? iconAlignment;
  final BoxFit? iconFit;

  const CustomSvgIconWidget(
    this.iconPath, {
    super.key,
    this.iconSize,
    this.iconWidth,
    this.iconHeight,
    this.iconColor,
    this.iconAlignment,
    this.iconFit,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      iconPath,
      color: iconColor,
      width: iconWidth ?? iconSize,
      height: iconHeight ?? iconSize,
      alignment: iconAlignment ?? Alignment.center,
      fit: iconFit ?? BoxFit.contain,
    );
  }
}

class CustomNetworkImageWidget extends StatefulWidget {
  final String imagePath;
  final double? imageWidth;
  final double? imageHeight;
  final Color? imageColor;
  final Alignment imageAlignment;
  final BoxFit imageFit;
  final Widget? placeHolderWidget;
  final bool isVerifyingKey;
  final bool sso;
  final bool addHeader;

  const CustomNetworkImageWidget(
    this.imagePath, {
    super.key,
    this.imageWidth,
    this.imageHeight,
    this.imageColor,
    this.imageAlignment = Alignment.center,
    this.imageFit = BoxFit.cover,
    this.placeHolderWidget,
    this.isVerifyingKey = false,
    this.sso = false,
    this.addHeader = false,
  });

  @override
  State<CustomNetworkImageWidget> createState() => _CustomNetworkImageWidgetState();
}

class _CustomNetworkImageWidgetState extends State<CustomNetworkImageWidget> {
  @override
  Widget build(BuildContext context) {
    bool isSvgIcon = widget.imagePath.contains(".svg");
    bool isUrl = widget.imagePath.startsWith("http");

    final header = widget.sso
        ? {"Authorization": "Bearer ${CommonProperties.token}"}
        : widget.isVerifyingKey
        ? //null
          {
            "verifyingKEY": CommonFunctions.hashRequest(widget.imagePath, "GET"),

            //  "Authorization":
            //      "Bearer ${locator<AuthService>().accessToken}"
          }
        : !widget
              .isVerifyingKey //MM
        ? {'Authorization': 'Bearer ${sl<EntryPointCubit>().state.apigeeToken?.accessToken}'}
        : null;

    if (widget.addHeader == true && header != null) {
      header.addAll({"X-Service-Id": "2"});
    }

    return isUrl
        ? isSvgIcon
              ? SvgPicture.network(
                  widget.imagePath,
                  width: widget.imageWidth,
                  height: widget.imageHeight,
                  fit: widget.imageFit,
                  placeholderBuilder: (BuildContext context) {
                    return widget.placeHolderWidget ??
                        _DefaultImageSkeleton(
                          width: widget.imageWidth,
                          height: widget.imageHeight,
                          borderRadius: BorderRadius.circular(12),
                        );
                  },
                )
              : CachedNetworkImage(
                  imageUrl: widget.imagePath,
                  httpHeaders: header,
                  width: widget.imageWidth,
                  height: widget.imageHeight,
                  fit: widget.imageFit,
                  fadeInDuration: const Duration(milliseconds: 140),
                  fadeOutDuration: const Duration(milliseconds: 120),
                  useOldImageOnUrlChange: true,
                  placeholder: (context, url) {
                    return widget.placeHolderWidget ??
                        _DefaultImageSkeleton(
                          width: widget.imageWidth,
                          height: widget.imageHeight,
                          borderRadius: BorderRadius.circular(12),
                        );
                  },
                  errorWidget: (context, url, error) {
                    return widget.placeHolderWidget ??
                        _DefaultImageError(
                          width: widget.imageWidth,
                          height: widget.imageHeight,
                          borderRadius: BorderRadius.circular(12),
                        );
                  },
                )
        : widget.placeHolderWidget ??
              _DefaultImageSkeleton(
                width: widget.imageWidth,
                height: widget.imageHeight,
                borderRadius: BorderRadius.circular(12),
              );
  }
}

class CustomCachedNetworkImage extends StatefulWidget {
  final String imagePath;
  final double? imageWidth;
  final double? imageHeight;
  final Color? imageColor;
  final Alignment imageAlignment;
  final BoxFit imageFit;
  final Widget? placeHolderWidget;
  final bool ssoAuth;

  const CustomCachedNetworkImage(
    this.imagePath, {
    super.key,
    this.imageWidth,
    this.imageHeight,
    this.imageColor,
    this.imageAlignment = Alignment.center,
    this.imageFit = BoxFit.cover,
    this.placeHolderWidget,
    this.ssoAuth = false,
  });

  @override
  State<CustomCachedNetworkImage> createState() => _CustomCachedNetworkImage();
}

class _CustomCachedNetworkImage extends State<CustomCachedNetworkImage> {
  @override
  Widget build(BuildContext context) {
    bool isUrl = widget.imagePath.startsWith("http");
    return isUrl
        ? CachedNetworkImage(
            imageUrl: widget.imagePath,
            httpHeaders: {"verifyingKEY": CommonFunctions.hashRequest(widget.imagePath, "GET")},
            width: widget.imageWidth,
            height: widget.imageHeight,
            fit: widget.imageFit,
            placeholder: (context, url) {
              return widget.placeHolderWidget ??
                  _DefaultImageSkeleton(
                    width: widget.imageWidth,
                    height: widget.imageHeight,
                    borderRadius: BorderRadius.circular(12),
                  );
            },
            errorWidget: (context, url, error) {
              return widget.placeHolderWidget ??
                  _DefaultImageError(
                    width: widget.imageWidth,
                    height: widget.imageHeight,
                    borderRadius: BorderRadius.circular(12),
                  );
            },
          )
        : widget.placeHolderWidget ??
              _DefaultImageSkeleton(
                width: widget.imageWidth,
                height: widget.imageHeight,
                borderRadius: BorderRadius.circular(12),
              );
  }
}

class _DefaultImageSkeleton extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius borderRadius;

  const _DefaultImageSkeleton({
    this.width,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final base = isDark ? const Color(0xFF243042) : const Color(0xFFF0F2F6);
    final highlight = isDark ? const Color(0xFF34455E) : Colors.white;

    return ClipRRect(
      borderRadius: borderRadius,
      child: Shimmer.fromColors(
        baseColor: base,
        highlightColor: highlight,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: base,
            border: Border.all(color: (isDark ? Colors.white : Colors.black).withOpacity(0.06), width: 1),
          ),
        ),
      ),
    );
  }
}

class _DefaultImageError extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius borderRadius;

  const _DefaultImageError({this.width, this.height, this.borderRadius = const BorderRadius.all(Radius.circular(12))});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? const Color(0xFF1D2430) : const Color(0xFFF6F7FA);
    final iconColor = isDark ? Colors.white70 : Colors.black45;

    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        width: width,
        height: height,
        color: surface,
        alignment: Alignment.center,
        child: Icon(
          Icons.image_not_supported_outlined,
          size: (height != null) ? (height! * 0.55).clamp(16, 28) : 22,
          color: iconColor,
        ),
      ),
    );
  }
}

class CustomSvgIconWithBackgroundWidget extends StatelessWidget {
  final String iconPath;
  final double iconWidth;
  final double iconHeight;
  final Color? iconColor;
  final Alignment iconAlignment;
  final BoxFit iconFit;
  final double width;
  final double height;
  final Color? backgroundColor;
  final BoxShape backgroundShape;

  const CustomSvgIconWithBackgroundWidget(
    this.iconPath, {
    super.key,
    this.iconWidth = 16,
    this.iconHeight = 16,
    this.iconColor,
    this.iconAlignment = Alignment.center,
    this.iconFit = BoxFit.none,
    this.backgroundColor,
    this.width = 60.0,
    this.height = 60.0,
    this.backgroundShape = BoxShape.circle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: backgroundShape,
        // color: backgroundColor ?? AppColor.black200.withOpacity(0.3),
        color: backgroundColor ?? AppColor.white6,
      ),
      child: SvgPicture.asset(
        iconPath,
        color: iconColor,
        width: iconWidth,
        height: iconHeight,
        alignment: iconAlignment,
        fit: iconFit,
      ),
    );
  }
}
