import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/location/presentation/bloc/location_bloc.dart';
import 'package:balady_plus/app/features/splash/presentation/pages/splash_screen_animator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show SystemChrome, SystemUiMode, SystemUiOverlay;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base/base_view_model.dart';
import '../../../../core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import '../../../../core/services/services_exports.dart' show EntryPointBridge;
import '../../../../core/utils/app_analytics_events.dart';
import '../../../_shared_feature_/shared_feature_exports.dart'
    show BridgeParams;

import '../../../force_update/presentation/core/force_update_view_model.dart';
import '../../../location/presentation/pages/acquire_location_page.dart';
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

    CommonFunctions.sendEventToAnalytics(AppEvents.OpenApp);
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [],
    );

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _controller.forward();

    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        /*  if ((await sl<LocationCubit>().getLocationCachedInit()) != true) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) {
            return AcquireLocationPage();
          }));
        } else {*/
        final params = sl<BridgeParams>().copyWith(isAuthenticated: true);
        final entryPointBridge = sl<EntryPointBridge>();
        entryPointBridge(params);

        //   CommonFunctions.sendUrbiMapLogs();
        //  }
        checkVersionInfo();
      } else {}
    });
  }

  void checkVersionInfo() {
    try {
      locator<ForceUpdateViewModel>().getVersionInfo();
    } catch (ex) {}
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
