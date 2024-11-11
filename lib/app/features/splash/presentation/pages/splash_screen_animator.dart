import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:flutter/material.dart';
import 'package:gif/gif.dart';

import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../entry_point/presentation/cubit/auth_cubit.dart';
import '../widgets/splash_screen_animation.dart';


import 'package:balady_authorization/src/authentication/bloc/authentication_bloc.dart';
import 'package:balady_authorization/src/utils/injection/injection_container.dart';


class SplashScreenAnimator extends StatefulWidget {
  final SplashScreenAnimation animation;
  final AnimationController controller;

  SplashScreenAnimator({Key? key, required this.controller})
      : animation = SplashScreenAnimation(controller),
        super(key: key);

  @override
  State<SplashScreenAnimator> createState() => _SplashScreenAnimatorState();
}

class _SplashScreenAnimatorState extends State<SplashScreenAnimator>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    String image = "assets/images/splash-screen.gif";
    // check if time to change the splash screen set the new splash screen
    if (CommonFunctions.changeSpalsh()) {
      image = "assets/images/splash-screen-2.gif";
    }
    return Scaffold(
      backgroundColor: AppColor.primary900Light,
      body: SizedBox(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Gif(
          image: AssetImage(image),
          fps: 10,
          fit: BoxFit.cover,
          autostart: Autostart.once,
          onFetchCompleted: () async {
            // wating for 1.3 seconds to hide the splash screen to make shower is splash screen is completed
            Future.delayed(const Duration(milliseconds: 3000)).then((e) {
              sl<EntryPointCubit>().hideSplash();
              Navigator.of(context).pop();
              // NavigationService.navigatorKey.currentState!.pop();
              slAuthentication<AuthenticationBloc>().add(CheckLoginAuthentication());
            });
          },
        ),
      ),
    );
  }
}
