import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart' show AppColor;
import '../../splash_exports.dart' show SplashAnimation;

class TopRightLogoWidget extends StatelessWidget {
  final SplashAnimation _animation;
  const TopRightLogoWidget({super.key, required SplashAnimation animation})
      : _animation = animation;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Transform(
        transform: Matrix4.translationValues(
          _animation.topRightShapeTranslation.value,
          -(_animation.topRightShapeTranslation.value),
          0.0,
        ),
        child: Container(
          width: 100.0,
          height: 100.0,
          decoration: BoxDecoration(
            color: AppColor.orange.withOpacity(0.66),
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(24.0),
            ),
          ),
        ),
      ),
    );
  }
}
