import 'package:flutter/material.dart';

class SplashAnimation {
  late final AnimationController controller;
  late final Animation<double> bottomLeftShapeTranslation;
  late final Animation<double> topRightShapeTranslation;
  late final Animation<double> centerShapeSize;
  late final Animation<double> centerLogoFade;

  SplashAnimation(this.controller)
      : bottomLeftShapeTranslation =
            // Note that, 1000 is a fixed number
            // If you want to translate from top,
            // you need to know the actual screen height
            Tween<double>(begin: 1000, end: 0.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.000,
              0.650,
              curve: Curves.bounceOut,
            ),
          ),
        ),
        topRightShapeTranslation =
            Tween<double>(begin: 100.0, end: 0.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.000,
              0.350,
              curve: Curves.easeIn,
            ),
          ),
        ),
        centerShapeSize = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0,
              0.500,
              curve: Curves.easeInOut,
            ),
          ),
        ),
        centerLogoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.600,
              1.000,
              curve: Curves.elasticOut,
            ),
          ),
        );
}
