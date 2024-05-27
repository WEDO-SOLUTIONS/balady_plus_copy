import 'package:balady_plus/app/features/facility_qr/facility_qr_exports.dart';
import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/utils/common_functions.dart';
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
    if (CommonFunctions.changeSpalsh()) {
      return Image.asset(
        "assets/images/eid-splash.png",
        fit: BoxFit.fill,
      );

      // return Gif(
      //   image: const AssetImage("assets/images/splash-screen.gif"),
      //   // controller:
      //   //    _controller, // if duration and fps is null, original gif fps will be used.
      //   /// fps: 30,
      //
      //   fit: BoxFit.cover,
      //
      //   //   duration: const Duration(seconds: 3),
      //   autostart: Autostart.once,
      //   onFetchCompleted: () {},
      // );
    }
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
        ));
  }
}
