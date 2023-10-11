import 'package:flutter/material.dart'
    show
        BuildContext,
        MaterialPageRoute,
        MediaQuery,
        Navigator,
        Route,
        Size,
        Widget;
import 'package:localize_and_translate/localize_and_translate.dart'
    show translator;

import '../../services/services_exports.dart';

extension ContextConversion on BuildContext {
  double get topPadding => MediaQuery.of(mainContext).padding.top;
  double get bottomPadding => MediaQuery.of(mainContext).padding.bottom;
  double get leftPadding => MediaQuery.of(mainContext).padding.left;
  double get rightPadding => MediaQuery.of(mainContext).padding.right;
  double get screenHeight => MediaQuery.of(mainContext).size.height;
  double get screenWidth => MediaQuery.of(mainContext).size.width;
  Size get screenSize => MediaQuery.of(mainContext).size;

  BuildContext get mainContext =>
      NavigationService.navigatorKey.currentContext!;

  Future<T?> refreshCurrentPage<T extends Object?, TO extends Object?>(
    Widget currentPage,
  ) =>
      Navigator.pushReplacement(
        this,
        MaterialPageRoute(builder: (BuildContext context) => currentPage),
      );

  Future<T?> pushNamedRoute<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) =>
      Navigator.of(this).pushNamed(routeName, arguments: arguments);

  void popRoute<T extends Object?>([T? result]) =>
      Navigator.of(this).pop(result);

  void popDialog<T extends Object?>([T? result]) =>
      Navigator.of(this).pop(true);

  void popRouteUntilFirst<T extends Object?>([T? result]) =>
      Navigator.of(this).popUntil((route) => route.isFirst);

  Future<T?> replaceRouteByNamedRoute<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) =>
      Navigator.of(this).pushReplacementNamed(
        routeName,
        result: result,
        arguments: arguments,
      );

  Future<T?> pushNamedRouteAndRemoveOthers<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) =>
      Navigator.of(this).pushNamedAndRemoveUntil(
        routeName,
        (route) => false,
        arguments: arguments,
      );

  Future<T?> pushNamedRouteAndRemoveUntil<T extends Object?>(
    String routeName, {
    required bool Function(Route<dynamic>) removeUntil,
    Object? arguments,
  }) =>
      Navigator.of(this).pushNamedAndRemoveUntil(
        routeName,
        removeUntil,
        arguments: arguments,
      );

  Future<T?> pushNamedRouteAndRemoveUntilSpecifiedCount<T extends Object?>(
    String routeName, {
    required int count,
    Object? arguments,
  }) {
    int localCount = 0;
    return Navigator.of(this).pushNamedAndRemoveUntil(
      routeName,
      (_) => localCount++ > count,
      arguments: arguments,
    );
  }

  Future<T?> pushNamedRouteAndRemoveUntilSpecifiedName<T extends Object?>(
    String routeName, {
    required String name,
    Object? arguments,
  }) =>
      Navigator.of(this).pushNamedAndRemoveUntil(
        routeName,
        (route) => route.settings.name == name,
        arguments: arguments,
      );

  Future<T?> pushNamedRouteAndRemoveUntilFirst<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) =>
      Navigator.of(this).pushNamedAndRemoveUntil(
        routeName,
        (route) => route.isFirst,
        arguments: arguments,
      );

  /// RTL: Right-To-Left
  ///
  /// LTR: Left-To-Right
  ///
  /// check the direction of app if is RTL as it is in Arabic language
  /// or is LTR as it is in English language
  bool get isRTL => translator.isDirectionRTL(this);
}
