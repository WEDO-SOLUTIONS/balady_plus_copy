import 'package:flutter/material.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../splash_exports.dart' show BottomLogoWidget, CenterLogoWidget;
import '../widgets/splash_screen_animation.dart';

class SplashScreenAnimator extends StatelessWidget {
  final SplashScreenAnimation animation;
  SplashScreenAnimator({Key? key, required AnimationController controller})
      : animation = SplashScreenAnimation(controller),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary900Light,
      body: AnimatedBuilder(
        animation: animation.controller,
        builder: (context, _) {
          return Stack(
            children: [
              BottomLogoWidget(animation: animation),
              CenterLogoWidget(animation: animation),
            ],
          );
        },
      ),
    );
  }
}
