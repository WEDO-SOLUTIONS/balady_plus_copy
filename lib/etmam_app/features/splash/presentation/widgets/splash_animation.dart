import 'package:flutter/material.dart';

class SplashAnimation {
  late final AnimationController controller;
  late final AnimationController secondController;
  late final Animation<double> bottomLeftShapeTranslation;
  late final Animation<double> topRightShapeTranslation;
  late final Animation<double> centerShapeSize;
  late final Animation<double> centerLogoFade;

  SplashAnimation(this.controller)
      : bottomLeftShapeTranslation = Tween<double>(begin: 20, end: 0.0).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeOut)),
        topRightShapeTranslation = Tween<double>(begin: -20, end: 0).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeOut)),
        centerShapeSize = Tween<double>(begin: 1, end: 20).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeOut)),
        centerLogoFade = Tween<double>(begin: 3, end: 0).animate(
          CurvedAnimation(parent: controller, curve: Curves.easeOut),
        );
}
