import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show AppColor;
import 'package:flutter/material.dart';

import 'custom_network_icon_widget.dart';

class ProviderLogoIcon extends StatelessWidget {
  final String imageUrl;
  final double imageSize;
  final EdgeInsetsGeometry? imageMargin;
  final double radius;

  const ProviderLogoIcon(
      {Key? key,
      required this.imageUrl,
      this.imageSize = 48,
      this.imageMargin,
      this.radius = 12})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: imageSize,
        width: imageSize,
        decoration: BoxDecoration(
            border: Border.all(
              width: 0.5,
              color: AppColor.bottomNavigationShadow,
            ),
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x14484b52),
                  offset: Offset(-2, 4),
                  blurRadius: 8,
                  spreadRadius: 0),
            ]),
        margin: imageMargin,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          child: CustomNetworkImageWidget(
            imageUrl,
            imageHeight: imageSize,
            imageWidth: imageSize,
            imageFit: BoxFit.fill,
          ),
        ));
  }
}

class EtmamProviderLogoIcon extends StatelessWidget {
  final String imageUrl;
  final double imageSize;
  final EdgeInsetsGeometry? imageMargin;

  const EtmamProviderLogoIcon({
    Key? key,
    required this.imageUrl,
    this.imageSize = 58,
    this.imageMargin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: imageMargin,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: CustomNetworkImageWidget(
          imageUrl,
          imageHeight: imageSize,
          imageWidth: imageSize,
          imageFit: BoxFit.fill,
        ),
      ),
    );
  }
}
