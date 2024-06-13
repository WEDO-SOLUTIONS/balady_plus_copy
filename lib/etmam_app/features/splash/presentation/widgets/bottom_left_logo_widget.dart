import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart' show IconPath;
import '../../../_shared_feature_/shared/shared_feature_exports.dart'
    show CustomHorizontalSpace, CustomSvgIconWidget;
import '../../splash_exports.dart' show SplashAnimation;

class BottomLeftLogoWidget extends StatelessWidget {
  final SplashAnimation _animation;
  const BottomLeftLogoWidget({Key? key, required SplashAnimation animation})
      : _animation = animation,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.only(bottom: 30),
        child: Transform(
          transform: Matrix4.translationValues(
            0.0,
            (_animation.bottomLeftShapeTranslation.value),
            0.0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CustomSvgIconWidget(
                IconPath.splashVision,
                iconHeight: 40,
                iconWidth: 60,
              ),
              CustomHorizontalSpace(width: 24),
              CustomSvgIconWidget(
                IconPath.splash2030,
                iconHeight: 40,
                iconWidth: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
