import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart' show IconPath;
import '../../../_shared_feature_/shared/shared_feature_exports.dart'
    show CustomSvgIconWidget;
import '../../splash_exports.dart' show SplashAnimation;

class TopRightLogoWidget extends StatelessWidget {
  final SplashAnimation _animation;

  const TopRightLogoWidget({Key? key, required SplashAnimation animation})
      : _animation = animation,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Transform(
        transform: Matrix4.translationValues(
            0, _animation.topRightShapeTranslation.value, 0),
        child: const CustomSvgIconWidget(
          IconPath.splashLogo,
          iconSize: 96,
        ),
      ),
    );
  }
}
