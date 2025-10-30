import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart' show IconPath;
import '../../splash_exports.dart' show SplashAnimation;

class CenterLogoWidget extends StatelessWidget {
  final SplashAnimation _animation;

  const CenterLogoWidget({Key? key, required SplashAnimation animation})
      : _animation = animation,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _animation.centerShapeSize.value,
          _animation.centerShapeSize.value,
          1.0,
        ),
        child: Container(
          height: 80,
          width: 125,
          alignment: Alignment.center,
          child: FadeTransition(
              opacity: _animation.centerLogoFade,
              child: CustomSvgIconWidget(
                IconPath.splashIcon,
                iconSize: _animation.centerShapeSize.value,
              )),
        ),
      ),
    );
  }
}
