import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart'
    show AppColor, CommonFunctions, StringIconChecker;
import 'package:flutter_svg/flutter_svg.dart' show SvgPicture;
import 'package:cached_network_image/cached_network_image.dart';

class CustomIconWidget extends StatelessWidget {
  final String icon;
  final double? iconSize;
  final double? iconWidth;
  final double? iconHeight;
  final Color? iconColor;
  final Alignment iconAlignment;
  final BoxFit iconFit;
  final Widget? placeHolderWidget;
  final bool withRotation;

  const CustomIconWidget(this.icon,
      {Key? key,
      this.iconSize,
      this.iconWidth,
      this.iconHeight,
      this.iconColor,
      this.iconAlignment = Alignment.center,
      this.iconFit = BoxFit.contain,
      this.placeHolderWidget,
      this.withRotation = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.flip(
      flipX: withRotation
          ? CommonFunctions.isAppAR
              ? false
              : true
          : false,
      child: icon.isNotEmpty
          ? !icon.isUrl
              ? icon.isSvgIcon
                  ? CustomSvgIconWidget(
                      icon,
                      iconColor: iconColor,
                      iconWidth: iconWidth ?? iconSize,
                      iconHeight: iconHeight ?? iconSize,
                      iconAlignment: iconAlignment,
                      iconFit: iconFit,
                      placeHolderWidget: placeHolderWidget,
                    )
                  : Image.asset(
                      icon,
                      color: iconColor,
                      width: iconWidth ?? iconSize,
                      height: iconHeight ?? iconSize,
                      alignment: iconAlignment,
                      fit: iconFit,
                      errorBuilder: (context, o, a) {
                        return placeHolderWidget ??
                            PlaceHolderIcon(
                              imageWidth: iconWidth ?? iconSize,
                              imageHeight: iconHeight ?? iconSize,
                            );
                      },
                    )
              : CustomNetworkImageWidget(
                  icon,
                  imageColor: iconColor,
                  imageHeight: iconHeight ?? iconSize,
                  imageWidth: iconWidth ?? iconSize,
                  imageFit: iconFit,
                  imageAlignment: iconAlignment,
                  placeHolderWidget: placeHolderWidget,
                )
          : placeHolderWidget ??
              PlaceHolderIcon(
                imageWidth: iconWidth ?? iconSize,
                imageHeight: iconHeight ?? iconSize,
              ),
    );
  }
}

class CustomSvgIconWidget extends StatelessWidget {
  final String iconPath;
  final double? iconSize;
  final double? iconWidth;
  final double? iconHeight;
  final AlignmentGeometry? iconAlignment;
  final BoxFit? iconFit;
  final Widget? placeHolderWidget;
  final Color? iconColor;

  const CustomSvgIconWidget(this.iconPath,
      {super.key,
      this.iconSize,
      this.iconWidth,
      this.iconHeight,
      this.iconAlignment,
      this.iconFit,
      this.placeHolderWidget,
      this.iconColor});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      iconPath,
      color: iconColor,
      width: iconWidth ?? iconSize,
      height: iconHeight ?? iconSize,
      alignment: iconAlignment ?? Alignment.center,
      fit: iconFit ?? BoxFit.contain,
      placeholderBuilder: (context) {
        return placeHolderWidget ??
            PlaceHolderIcon(
              imageWidth: iconWidth ?? iconSize,
              imageHeight: iconHeight ?? iconSize,
            );
      },
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

  const CustomNetworkImageWidget(this.imagePath,
      {Key? key,
      this.imageWidth,
      this.imageHeight,
      this.imageColor,
      this.imageAlignment = Alignment.center,
      this.imageFit = BoxFit.contain,
      this.placeHolderWidget})
      : super(key: key);

  @override
  State<CustomNetworkImageWidget> createState() => _CustomNetworkImageWidget();
}

class _CustomNetworkImageWidget extends State<CustomNetworkImageWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.imagePath.isUrl
        ? widget.imagePath.isSvgIcon
            ? SvgPicture.network(
                widget.imagePath,
                width: widget.imageWidth,
                height: widget.imageHeight,
                fit: widget.imageFit,
                placeholderBuilder: (BuildContext context) {
                  return widget.placeHolderWidget ??
                      PlaceHolderIcon(
                          imageWidth: widget.imageWidth,
                          imageHeight: widget.imageHeight);
                },
              )
            : CachedNetworkImage(
                imageUrl: widget.imagePath,
                width: widget.imageWidth,
                height: widget.imageHeight,
                fit: widget.imageFit,
                placeholder: (context, url) {
                  return widget.placeHolderWidget ??
                      PlaceHolderIcon(
                          imageWidth: widget.imageWidth,
                          imageHeight: widget.imageHeight);
                },
                errorWidget: (context, url, error) {
                  return widget.placeHolderWidget ??
                      PlaceHolderIcon(
                          imageWidth: widget.imageWidth,
                          imageHeight: widget.imageHeight);
                })
        : widget.placeHolderWidget ??
            PlaceHolderIcon(
              imageWidth: widget.imageWidth,
              imageHeight: widget.imageHeight,
            );
  }
}

class PlaceHolderIcon extends StatelessWidget {
  final double? imageWidth;
  final double? imageHeight;

  const PlaceHolderIcon({Key? key, this.imageWidth, this.imageHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.blue,
      width: imageWidth,
      height: imageHeight,
    );
  }
}
