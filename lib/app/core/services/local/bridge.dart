import 'package:flutter/material.dart' show BuildContext;

import '../../../features/_shared_feature_/shared_feature_exports.dart'
    show BridgeParams;
import '../../utils/utils_exports.dart'
    show BridgeFlow, ContextConversion, RouteName;
import '../services_exports.dart' show NavigationService;

abstract class Bridge {
  /// Callable Classes
  ///
  /// in Dart: a method named call() can be run both by calling obj.call()
  /// and also by just calling obj()
  void call(BridgeParams params);
  BuildContext get context;
}

class EntryPointBridge implements Bridge {
  const EntryPointBridge();

  @override
  void call(BridgeParams params) {
    String routeName;
    switch (params.flowType) {
      case BridgeFlow.signIn:
        routeName = RouteName.signIn;
        break;
      case BridgeFlow.home:
        routeName = RouteName.bottomNavigation;
        break;
    }
    context.pushNamedRouteAndRemoveOthers(routeName);
  }

  @override
  BuildContext get context => NavigationService.navigatorKey.currentContext!;
}
