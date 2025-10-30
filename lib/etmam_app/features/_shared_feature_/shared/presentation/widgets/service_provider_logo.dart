import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show ProviderLogoIcon;
import 'package:flutter/material.dart';

class ServiceProviderLogo extends StatelessWidget {
  double width;
  double height;
  String image;

  ServiceProviderLogo(
      {Key? key, this.height = 48, required this.image, this.width = 48})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderLogoIcon(
      imageUrl: image,
      imageSize: height,
    );
  }
}
