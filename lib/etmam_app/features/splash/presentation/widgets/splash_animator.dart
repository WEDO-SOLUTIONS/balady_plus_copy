import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart' show AppColorsTheme;
import '../../splash_exports.dart'
    show
        BottomLeftLogoWidget,
        CenterLogoWidget,
        SplashAnimation,
        TopRightLogoWidget;

class SplashAnimator extends StatelessWidget {
  final SplashAnimation _animation;

  SplashAnimator({Key? key, required AnimationController controller})
      : _animation = SplashAnimation(controller),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsTheme.primary700,
      body: AnimatedBuilder(
        animation: _animation.controller,
        // Leave it as a Stack widget to have a flexibility
        // of adding Logo above shapes or another widgets
        // or move widgets in the fly space
        builder: (_, __) => Stack(
          fit: StackFit.expand,
          children: [
            // Center Logo widget
            CenterLogoWidget(animation: _animation),
          ],
        ),
      ),
    );
  }
}

class SecondSplashAnimator extends StatelessWidget {
  final SplashAnimation _animation;

  SecondSplashAnimator({Key? key, required AnimationController controller})
      : _animation = SplashAnimation(controller),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsTheme.primary700,
      body: AnimatedBuilder(
        animation: _animation.controller,
        // Leave it as a Stack widget to have a flexibility
        // of adding Logo above shapes or another widgets
        // or move widgets in the fly space
        builder: (_, __) => Stack(
          fit: StackFit.expand,
          children: [
            // Bottom Left Light Shape widget
            BottomLeftLogoWidget(animation: _animation),
            // Bottom Left Dark Shape widget
            TopRightLogoWidget(animation: _animation),
          ],
        ),
      ),
    );
  }
}
