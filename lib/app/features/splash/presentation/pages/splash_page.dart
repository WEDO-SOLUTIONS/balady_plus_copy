import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/splash/presentation/pages/splash_screen_animator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, SystemUiMode, SystemUiOverlayStyle;
import '../../../../core/utils/app_analytics_events.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    CommonFunctions.sendEventToAnalytics(AppEvents.OpenApp);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
  }

  @override
  void dispose() {
    try {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          systemNavigationBarColor: Color(0x00000000),
          systemNavigationBarDividerColor: Color(0x00000000),
        ),
      );
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreenAnimator();
  }
}
