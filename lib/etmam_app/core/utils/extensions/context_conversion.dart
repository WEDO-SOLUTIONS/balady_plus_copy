import 'package:flutter/material.dart'
    show BuildContext, MediaQuery, Navigator, Route, Size;
import 'package:localize_and_translate/localize_and_translate.dart'
    show translator;

extension ContextConversion on BuildContext {
  double get topPadding => MediaQuery.of(this).padding.top;
  double get bottomPadding => MediaQuery.of(this).padding.bottom;
  double get leftPadding => MediaQuery.of(this).padding.left;
  double get rightPadding => MediaQuery.of(this).padding.right;
  double get screenHeight => MediaQuery.of(this).size.height;
  double get screenWidth => MediaQuery.of(this).size.width;
  Size get screenSize => MediaQuery.of(this).size;

  void popDialog<T extends Object?>([T? result]) =>
      Navigator.of(this).pop(true);

  Future<T?> pushNamedRoute<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) =>
      Navigator.of(this).pushNamed(routeName, arguments: arguments);

  void popRoute<T extends Object?>([T? result]) => Navigator.of(this).pop();

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

  /// RTL: Right-To-Left
  ///
  /// LTR: Left-To-Right
  ///
  /// check the direction of app if is RTL as it is in Arabic language
  /// or is LTR as it is in English language
  bool get isRTL => translator.isDirectionRTL(this);
}
