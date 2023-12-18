// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iwish.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $iwishCardRoute,
      $iwishFeedbackRoute,
      $iwishFeedbackCommentRoute,
    ];

RouteBase get $iwishCardRoute => GoRouteData.$route(
      path: '/iwish/:iwishId/card',
      parentNavigatorKey: IwishCardRoute.$parentNavigatorKey,
      factory: $IwishCardRouteExtension._fromState,
    );

extension $IwishCardRouteExtension on IwishCardRoute {
  static IwishCardRoute _fromState(GoRouterState state) => IwishCardRoute(
        iwishId: state.pathParameters['iwishId']!,
      );

  String get location => GoRouteData.$location(
        '/iwish/${Uri.encodeComponent(iwishId)}/card',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $iwishFeedbackRoute => GoRouteData.$route(
      path: '/iwish/:iwishId/feedback',
      parentNavigatorKey: IwishFeedbackRoute.$parentNavigatorKey,
      factory: $IwishFeedbackRouteExtension._fromState,
    );

extension $IwishFeedbackRouteExtension on IwishFeedbackRoute {
  static IwishFeedbackRoute _fromState(GoRouterState state) =>
      IwishFeedbackRoute(
        iwishId: state.pathParameters['iwishId']!,
      );

  String get location => GoRouteData.$location(
        '/iwish/${Uri.encodeComponent(iwishId)}/feedback',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $iwishFeedbackCommentRoute => GoRouteData.$route(
      path: '/iwish/:iwishId/comment',
      parentNavigatorKey: IwishFeedbackCommentRoute.$parentNavigatorKey,
      factory: $IwishFeedbackCommentRouteExtension._fromState,
    );

extension $IwishFeedbackCommentRouteExtension on IwishFeedbackCommentRoute {
  static IwishFeedbackCommentRoute _fromState(GoRouterState state) =>
      IwishFeedbackCommentRoute(
        iwishId: state.pathParameters['iwishId']!,
      );

  String get location => GoRouteData.$location(
        '/iwish/${Uri.encodeComponent(iwishId)}/comment',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
