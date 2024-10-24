import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart' show AppColor;
import '../../splash_exports.dart' show SplashAnimation;

class BottomLeftLogoWidget extends StatelessWidget {
  final SplashAnimation _animation;
  const BottomLeftLogoWidget({super.key, required SplashAnimation animation})
      : _animation = animation;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 20.0,
      bottom: 10.0,
      // alignment: Alignment.bottomLeft,
      child: Transform(
        transform: Matrix4.translationValues(
          0.0,
          -(_animation.bottomLeftShapeTranslation.value),
          0.0,
        ),
        child: Container(
          width: 64.0,
          height: 64.0,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColor.blue,
            shape: BoxShape.circle,
          ),
          child: Container(
            width: 24.0,
            height: 24.0,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColor.orange,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
