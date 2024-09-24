import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../entry_point/presentation/cubit/auth_cubit.dart';
import '../widgets/splash_screen_animation.dart';

class SplashScreenAnimator extends StatefulWidget {
  final SplashScreenAnimation animation;
  final AnimationController controller;

  SplashScreenAnimator({Key? key, required this.controller})
      : animation = SplashScreenAnimation(controller),
        super(key: key);

  @override
  State<SplashScreenAnimator> createState() => _SplashScreenAnimatorState();
}

class _SplashScreenAnimatorState extends State<SplashScreenAnimator> with SingleTickerProviderStateMixin {


  @override
  Widget build(BuildContext context) {
    if (CommonFunctions.changeSpalsh()) {
      return Scaffold(
        backgroundColor: AppColor.primary900Light,
        body: SizedBox(
          width: double.maxFinite,
          height: double.maxFinite,
          child: Gif(
            image: const AssetImage("assets/images/splash-screen.gif"),
            // controller: GifController(vsync: this), // if duration and fps is null, original gif fps will be used.
            // fps: 30,
            // duration: const Duration(seconds: 10),
            fit: BoxFit.cover,
            autostart: Autostart.once,
            onFetchCompleted: () async {
              await Future.delayed(const Duration(seconds: 4));
              sl<EntryPointCubit>().hideSplash();
            },
          ),
        ),
      );

      // return Gif(
      //   image: const AssetImage("assets/images/splash-screen.gif"),
      //   // controller:
      //   //    _controller, // if duration and fps is null, original gif fps will be used.
      //   fps: 30,
      //
      //   fit: BoxFit.cover,
      //
      //   duration: const Duration(seconds: 10),
      //   autostart: Autostart.once,
      //   onFetchCompleted: () {},
      // );
    }
    return Scaffold(
        backgroundColor: AppColor.primary900Light,
        body: AnimatedBuilder(
          animation: widget.animation.controller,
          builder: (context, _) {
            return Center(
              child: Lottie.asset(
                'assets/animation/logo.json',
                fit: BoxFit.fill,
                height: 168,
                width: 228,
                controller: widget.controller,
              ),
            );
          },
        ));
  }
}
