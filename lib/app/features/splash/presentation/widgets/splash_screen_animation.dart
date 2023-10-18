import 'package:flutter/material.dart';

class SplashScreenAnimation {
  late final AnimationController controller;
  // late final Animation<double> bottomIconYTranslation;
  late final Animation<double> centerIconOpacity;
  late final Animation<AlignmentGeometry> centerToRightIcon;
  late final Animation<double> centerIconResize;
  late final Animation<double> centerTextOpacity;

  /* SplashScreenAnimation(this.controller)
      : bottomIconYTranslation = Tween<double>(begin: -500.0, end: 0.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.000,
              0.650,
              curve: Curves.bounceOut,
            ),
          ),
        ),
        centerIconOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.450,
              1.000,
              curve: Curves.easeIn,
            ),
          ),
        ); */
  SplashScreenAnimation(this.controller)
      : centerIconOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.000,
              0.450,
              curve: Curves.easeIn,
            ),
          ),
        ),
        centerToRightIcon = Tween<AlignmentGeometry>(
          begin: Alignment.center,
          end: Alignment.centerRight,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.450,
              0.550,
              curve: Curves.easeIn,
            ),
          ),
        ),
        centerIconResize = Tween<double>(
          begin: 250.0,
          end: 100.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.450,
              0.550,
              curve: Curves.easeIn,
            ),
          ),
        ),
        centerTextOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.550,
              1.000,
              curve: Curves.easeIn,
            ),
          ),
        );
}
