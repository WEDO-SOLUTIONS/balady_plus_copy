import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapness/app/auto_route/others/transparent_barrier.dart';

/// CustomModalRoute We need to pass [transitionBuilder] to animate the opening of screens,
/// this is for those cases when we want the background to work correctly.
/// There was a decision to create AppRoute, so as not to overwrite always [customRouteBuilder] for such cases
class AppRoute<T> extends CustomRoute<T> {
  AppRoute({
    required PageInfo page,
    super.fullscreenDialog,
    super.barrierDismissible,
    super.path,
    super.guards,
    super.usesPathAsKey,
    super.fullMatch,
    super.children,
    super.initial,
    int? durationInMilliseconds,
    int? reverseDurationInMilliseconds,
    RouteTransitionsBuilder? transitionsBuilder,
  }) : super(
         page: page,
         customRouteBuilder: <T>(context, child, page) => CustomModalRoute<T>(
           page: page,
           routeType: CustomRouteType(
             transitionsBuilder: transitionsBuilder,
             durationInMilliseconds: durationInMilliseconds,
             reverseDurationInMilliseconds: reverseDurationInMilliseconds,
           ),
         ),
       );
}

enum RouteBarrierColor {
  transparent,
  // default color
  dimming40,
  dimming60,
  dimming90;

  Color getColor(BuildContext context) {
    switch (this) {
      case RouteBarrierColor.transparent:
        return Colors.transparent;
      case RouteBarrierColor.dimming40:
        return context.colors.screenOverlayDimming40;
      case RouteBarrierColor.dimming60:
        return context.colors.screenOverlayDimming60;
      case RouteBarrierColor.dimming90:
        return context.colors.screenOverlayDimming90;
    }
  }
}

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
    RouteBarrierColor background = RouteBarrierColor.dimming40,
  }) => ModalBottomSheetRoute(
    settings: page,
    builder: (context) => child,
    isScrollControlled: true,
    modalBarrierColor: background.getColor(context),
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
  static Route<T> customModalSheetBuilder<T>(BuildContext context, Widget child, AutoRoutePage<T> page) =>
      CustomModalRoute(page: page);

  static Route<T> customBarrierDismissibleBuilder<T>(BuildContext context, Widget child, AutoRoutePage<T> page) =>
      RawDialogRoute(
        settings: page,
        pageBuilder: (context, animation, secondaryAnimation) => child,
        barrierColor: context.colors.screenOverlayDimming40,
      );

  /// Builds a Cupertino-style [Route] compatible with auto_route's page-based API.
  ///
  /// This builder is intended to be used as `customRouteBuilder` inside an
  /// `@AutoRoute`/`CustomRoute` definition. Since auto_route is page-based,
  /// the returned [Route.settings] **must** be the provided [page] (an
  /// [AutoRoutePage]); otherwise Flutter will assert with:
  /// `!pageBased || route.settings is Page`.
  ///
  /// It also preserves native iOS behaviors like the interactive "swipe back"
  /// gesture when the route can pop.
  ///
  /// - [context] — Build context from auto_route.
  /// - [child]   — The screen widget to display.
  /// - [page]    — The generated page descriptor; forwarded to `settings`
  ///               (and can be used for `fullscreenDialog`, etc.).
  ///
  /// Usage:
  /// ```dart
  /// CustomRoute(
  ///   path: 'profile_info',
  ///   page: ProfileInfoRoute.page,
  ///   customRouteBuilder: RouteBuilders.cupertinoRouteBuilder,
  /// )
  /// ```
  static Route<T> cupertinoRouteBuilder<T>(BuildContext context, Widget child, AutoRoutePage<T> page) =>
      CupertinoPageRoute<T>(builder: (_) => child, settings: page);
}
