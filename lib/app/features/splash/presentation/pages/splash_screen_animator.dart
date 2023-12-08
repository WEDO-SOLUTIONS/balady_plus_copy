import 'package:balady_plus/app/features/facility_qr/facility_qr_exports.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../splash_exports.dart' show BottomLogoWidget, CenterLogoWidget;
import '../widgets/splash_screen_animation.dart';

class SplashScreenAnimator extends StatelessWidget {
  final SplashScreenAnimation animation;
  final AnimationController controller;
  SplashScreenAnimator({Key? key, required this.controller})
      : animation = SplashScreenAnimation(controller),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary900Light,
      body: AnimatedBuilder(
        animation: animation.controller,
        builder: (context, _) {
          return Center(
            child: Lottie.asset(
              'assets/animation/logo.json',
              fit: BoxFit.fill,
              height: 168,
              width: 228,
              controller: controller,
            ),
          );
        },
      ),
    );
  }
}
