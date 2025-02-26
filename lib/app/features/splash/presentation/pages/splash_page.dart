import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/splash/presentation/pages/splash_screen_animator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show SystemChrome, SystemUiMode, SystemUiOverlay;
import '../../../../core/utils/app_analytics_events.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    CommonFunctions.sendEventToAnalytics(AppEvents.OpenApp);
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [],
    );

    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _controller.forward();

    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
      } else {}
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    _controller.removeStatusListener((status) {});
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreenAnimator(controller: _controller);
  }
}
