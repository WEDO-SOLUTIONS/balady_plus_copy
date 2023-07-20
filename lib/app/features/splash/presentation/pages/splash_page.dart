import 'package:balady_plus/app/features/splash/presentation/pages/splash_screen_animator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show SystemChrome, SystemUiMode, SystemUiOverlay;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import '../../../../core/services/services_exports.dart' show EntryPointBridge;
import '../../../_shared_feature_/shared_feature_exports.dart'
    show BridgeParams;

import '../../splash_exports.dart' show SplashAnimator;

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
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [],
    );

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        final params = sl<BridgeParams>().copyWith(isAuthenticated: true);

        final entryPointBridge = sl<EntryPointBridge>();
        entryPointBridge(params);
      }
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
