import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/app/auto_route/others/transparent_barrier.dart';

class RouteBuilders {
  /// Creates a modal bottom sheet route (ModalBottomSheetRoute),
  /// using colors from the UI kit for the modal surface.
  ///
  /// - [context] provides information about the current widget state.
  /// - [child] is the widget that will be displayed in the modal sheet.
  /// - [page] represents the route page, passed as an AutoRoutePage.
  ///
  /// This method sets up the following parameters:
  /// - [isScrollControlled] enables scroll control in the modal.
  /// - [modalBarrierColor] uses a color from the UI kit for the modal barrier
  ///   that blocks interaction with the rest of the UI while the modal is open.
  /// - [backgroundColor] is set to `Colors.transparent` to avoid a background overlay.
  ///
  ///  Using in [CustomRoute] call [customRouteBuilder]
  static Route<T> modalSheetBuilder<T>(
    BuildContext context,
    Widget child,
    AutoRoutePage<T> page, {
    bool isTransparent = false,
  }) =>
      ModalBottomSheetRoute(
        settings: page,
        builder: (context) => child,
        isScrollControlled: true,
        modalBarrierColor: isTransparent ? Colors.transparent : context.staticColor.surfaceOverlayModal,
        backgroundColor: Colors.transparent,
      );

  /// Creates a custom modal route (CustomModalRoute) that removes the navigation barrier,
  /// allowing access to routes behind the modal window.
  ///
  /// - [context] provides information about the current widget state.
  /// - [child] is the widget that will be displayed in the modal window.
  /// - [page] represents the route page, passed as an AutoRoutePage.
  ///
  /// This method sets up a route without a barrier, allowing the user
  /// to interact with navigation elements or other routes behind the modal window.
  static Route<T> customModalSheetBuilder<T>(
    BuildContext context,
    Widget child,
    AutoRoutePage<T> page,
  ) =>
      CustomModalRoute(page: page);
}
