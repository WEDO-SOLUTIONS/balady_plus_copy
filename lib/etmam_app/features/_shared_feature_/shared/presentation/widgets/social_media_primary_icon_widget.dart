import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColorsTheme, AppColor, SocialMediaTypes;
import '../../shared_feature_exports.dart' show CustomSvgIconWidget;

class SocialMediaPrimaryIconWidget extends StatelessWidget {
  final SocialMediaTypes type;
  final double containerSize;

  const SocialMediaPrimaryIconWidget(
      {Key? key, required this.type, this.containerSize = 44})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: containerSize,
        height: containerSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColor.black100, width: 0.5),
        ),
        child: Center(
            child: CustomSvgIconWidget(
          type.icon,
          iconFit: BoxFit.fill,
          iconHeight: type.height,
          iconWidth: type.width,
          iconColor: AppColor.baladyDarkGreen2,
        )));
  }
}
