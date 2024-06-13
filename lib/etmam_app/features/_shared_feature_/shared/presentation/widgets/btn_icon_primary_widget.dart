import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart' show AppColorsTheme;
import '../../shared_feature_exports.dart' show CustomSvgIconWidget;

class BtnIconPrimaryIconWidget extends StatelessWidget {
  final double containerSize;
  final String iconPath;
  final double iconSize;
  final Function onPressed;

  const BtnIconPrimaryIconWidget(
      {Key? key,
      this.containerSize = 32,
      required this.iconSize,
      required this.onPressed,
      required this.iconPath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed(),
      child: Container(
          width: containerSize,
          height: containerSize,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: Colors.white,
          ),
          child: Center(
              child: CustomSvgIconWidget(
            iconPath,
            iconFit: BoxFit.fill,
            iconSize: iconSize,
            //  iconColor: AppColorsTheme.primary700,
          ))),
    );
  }
}
