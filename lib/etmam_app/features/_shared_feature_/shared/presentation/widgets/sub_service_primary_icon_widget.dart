import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppColorsTheme;
import '../../shared_feature_exports.dart' show CustomNetworkImageWidget;

class SubServicePrimaryIconWidget extends StatelessWidget {
  final String icon;
  final double containerSize;
  final double iconSize;
  final EdgeInsetsGeometry? margin;

  const SubServicePrimaryIconWidget(
      {Key? key,
      required this.icon,
      this.containerSize = 40,
      this.iconSize = 24,
      this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 40,
        height: 40,
        margin: margin ?? const EdgeInsetsDirectional.only(start: 12),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            color: AppColorsTheme.primary700,
            boxShadow: [
              BoxShadow(
                  color: const Color(0xff484B52).withOpacity(0.08),
                  offset: const Offset(-4, 8),
                  blurRadius: 16,
                  spreadRadius: 0)
            ]),
        child: Center(
            child: CustomNetworkImageWidget(
          icon,
          imageHeight: iconSize,
          imageWidth: iconSize,
          imageFit: BoxFit.fill,
        )));
  }
}

class EtmamSubServicePrimaryIconWidget extends StatelessWidget {
  final String icon;
  final double containerSize;
  final double iconSize;
  final EdgeInsetsGeometry? margin;

  const EtmamSubServicePrimaryIconWidget(
      {Key? key,
      required this.icon,
      this.containerSize = 58,
      this.iconSize = 32,
      this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: containerSize,
        height: containerSize,
        decoration: const BoxDecoration(
          color: AppColor.white5,
          shape: BoxShape.circle,
        ),
        child: Center(
            child: CustomNetworkImageWidget(
          icon,
          imageHeight: iconSize,
          imageWidth: iconSize,
          imageFit: BoxFit.fill,
        )));
  }
}
