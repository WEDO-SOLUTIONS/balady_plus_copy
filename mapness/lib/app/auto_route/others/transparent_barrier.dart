import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// A custom modal route for navigating between pages using [AutoRoute].
///
/// Needed to remove the [buildModalBarrier] in the [ModalRoute] class
class CustomModalRoute<T> extends PageRoute<T> {
  /// Creates a [CustomModalRoute].
  ///
  /// - [page] represents the page to be routed to, passed as an [AutoRoutePage].
  /// - [routeType] allows configuring custom route transitions, barrier properties,
  ///   and other route behaviors. If no custom route type is provided, a default
  ///   [CustomRouteType] is used.
  CustomModalRoute({
    required AutoRoutePage page,
    this.routeType = const CustomRouteType(),
  }) : super(settings: page);

  /// The custom route type that defines various behaviors for this route,
  /// such as the transition duration, opacity, dismissibility, and barriers.
  final CustomRouteType routeType;

  /// Builds the content of the route (page) based on the current animation state.
  ///
  /// - [context] provides information about the widget tree.
  /// - [animation] represents the current animation for the page transition.
  /// - [secondaryAnimation] is used for secondary transitions between routes.
  ///
  /// This method ensures that the page is wrapped in a [Semantics] widget to
  /// improve accessibility by making the route scope explicit.
  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) =>
      Semantics(
        scopesRoute: true,
        explicitChildNodes: true,
        child: (settings as AutoRoutePage).buildPage(context),
      );

  /// Whether the route should maintain its state when the page is inactive.
  ///
  /// This is set to `true` to preserve the state of the page even when it is
  /// not visible, which helps in restoring the page without reinitializing its state.
  @override
  bool get maintainState => true;

  /// Specifies the duration for the forward transition animation.
  ///
  /// The duration is set based on the value defined in [CustomRouteType], defaulting
  /// to 0 milliseconds if no value is provided.
  @override
  Duration get transitionDuration => Duration(milliseconds: routeType.durationInMilliseconds ?? 0);

  /// Specifies the duration for the reverse transition animation (when the route is popped).
  ///
  /// This is also set based on [CustomRouteType], defaulting to 0 milliseconds.
  @override
  Duration get reverseTransitionDuration => Duration(milliseconds: routeType.reverseDurationInMilliseconds ?? 0);

  /// Whether the route is opaque, meaning it fully covers the previous route.
  ///
  /// This is determined by the [CustomRouteType], and the default is `true`.
  @override
  bool get opaque => routeType.opaque;

  /// Specifies whether the modal barrier should allow taps to dismiss the route.
  ///
  /// This is based on [CustomRouteType], with the default behavior allowing the
  /// user to dismiss the route by tapping the barrier.
  @override
  bool get barrierDismissible => routeType.barrierDismissible;

  /// The color of the modal barrier that overlays the background when the route is active.
  ///
  /// This can be customized through [CustomRouteType] to control the transparency
  /// or appearance of the barrier.
  @override
  Color? get barrierColor => routeType.barrierColor;

  /// The semantic label for the modal barrier.
  ///
  /// This label is used for accessibility purposes and can be customized via
  /// [CustomRouteType].
  @override
  String? get barrierLabel => routeType.barrierLabel;

  /// Whether the route is a full-screen dialog.
  ///
  /// This is set based on the page settings, particularly [AutoRoutePage.fullscreenDialog].
  @override
  bool get fullscreenDialog => (settings as AutoRoutePage).fullscreenDialog;

  /// Builds an empty modal barrier to prevent the default barrier behavior.
  ///
  /// This is overridden to provide a transparent modal barrier, allowing
  /// interaction with routes behind the current modal.
  @override
  Widget buildModalBarrier() => const SizedBox.shrink();

  @override
  Widget buildTransitions(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    final transitionsBuilder = _defaultTransitionsBuilder;
    return transitionsBuilder(context, animation, secondaryAnimation, child);
  }

  Widget _defaultTransitionsBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) =>
      child;
}
