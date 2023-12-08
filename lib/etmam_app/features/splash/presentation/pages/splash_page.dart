import 'package:balady_plus/etmam_app/core/services/services_exports.dart';
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show CommonFunctions, RouteName;
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show SystemChrome, SystemNavigator, SystemUiMode, SystemUiOverlay;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../splash_exports.dart' show SecondSplashAnimator, SplashAnimator;

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _secondController;
  bool firstSplash = true;

  @override
  void initState() {
    super.initState();
    //CommonFunctions.sendEventToAnalytics(AppEvents.SplashPage);
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [],
    );

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _secondController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        //Timer(const Duration(milliseconds: 20), () {
        _secondController.forward();
        setState(() {
          firstSplash = false;
        });
        //  });
      }
    });
    _secondController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        /*  if (sharedPrefs.getIsFirstLaunch() ?? true) {
          Navigator.of(context)
              .pushReplacementNamed(EtmamRoutesNames.onBoardingRoute);
        } else {
          //MM
          Navigator.of(context)
              .pushReplacementNamed(EtmamRoutesNames.bottomNavigation);

          // Navigator.of(context).pushReplacementNamed(RouteName.onBordingRoute);
        }*/
      }
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    _controller
      ..removeStatusListener((status) {})
      ..dispose();
    _secondController
      ..removeStatusListener((status) {})
      ..dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return Future.value(true);
      },
      child: BlocListener<EntryPointCubit, EntryPointState>(
        listener: (_, state) {},
        child: firstSplash
            ? SplashAnimator(
                controller: _controller,
              )
            : SecondSplashAnimator(
                controller: _secondController,
              ),
      ),
    );
  }
}
