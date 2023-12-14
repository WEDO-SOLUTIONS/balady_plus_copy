import 'package:flutter/material.dart'
    show AppLifecycleState, WidgetsBindingObserver;

import '../../utils/utils_exports.dart' show Log, StringConversion;

class LifecycleEventHandler extends WidgetsBindingObserver {
  LifecycleEventHandler({
    this.inactiveCallBack,
    this.pausedCallBack,
    this.detachedCallBack,
    this.resumeCallBack,
  });

  final Function? inactiveCallBack;
  final Function? pausedCallBack;
  final Function? detachedCallBack;
  final Function? resumeCallBack;

  //  @override
  //  Future<bool> didPopRoute()

  //  @override
  //  void didHaveMemoryPressure()

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
        if (inactiveCallBack != null) {
          await inactiveCallBack!();
        }
        break;
      case AppLifecycleState.paused:
        if (pausedCallBack != null) {
          await pausedCallBack!();
        }
        break;
      case AppLifecycleState.detached:
        if (detachedCallBack != null) {
          await detachedCallBack!();
        }
        break;
      case AppLifecycleState.resumed:
        if (resumeCallBack != null) {
          await resumeCallBack!();
        }
        break;
      default:
        break;
    }
    '''
    =============================================================
                  $state
    =============================================================
    '''
        .hardcoded
        .actionLog();
  }

  //  @override
  //  void didChangeLocale(Locale locale)

  //  @override
  //  void didChangeTextScaleFactor()

  //  @override
  //  void didChangeMetrics();

  //  @override
  //  Future<bool> didPushRoute(String route)
}
