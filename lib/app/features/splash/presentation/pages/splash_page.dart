import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/splash/presentation/pages/splash_screen_animator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show SystemChrome, SystemUiMode, SystemUiOverlay;

import '../../../../core/base/base_view_model.dart';
import '../../../../core/utils/app_analytics_events.dart';

import '../../../force_update/presentation/core/force_update_view_model.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

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
        /*  if ((await sl<LocationCubit>().getLocationCachedInit()) != true) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) {
            return AcquireLocationPage();
          }));
        } else {*/
        // final params = sl<BridgeParams>().copyWith(
        //   isAuthenticated: true,
        // );
        // final entryPointBridge = sl<EntryPointBridge>();
        // entryPointBridge(params);
        // if (!CommonFunctions.changeSpalsh()) {
        // sl<EntryPointCubit>().hideSplash();
        // }
        //   CommonFunctions.sendUrbiMapLogs();
        //  }

        // after splash screen completed check the version info to show the force update dialog
        checkVersionInfo();
      } else {}
    });
  }

  void checkVersionInfo() {
    try {
      locator<ForceUpdateViewModel>().getVersionInfo();
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
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
