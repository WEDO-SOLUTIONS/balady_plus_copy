// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jobs_map.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $jobsMapRoute,
      $jobsMapDetail,
    ];

RouteBase get $jobsMapRoute => GoRouteData.$route(
      path: '/jobs_map',
      parentNavigatorKey: JobsMapRoute.$parentNavigatorKey,
      factory: $JobsMapRouteExtension._fromState,
    );

extension $JobsMapRouteExtension on JobsMapRoute {
  static JobsMapRoute _fromState(GoRouterState state) => const JobsMapRoute();

  String get location => GoRouteData.$location(
        '/jobs_map',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $jobsMapDetail => GoRouteData.$route(
      path: '/job/:jobId/detail',
      parentNavigatorKey: JobsMapDetail.$parentNavigatorKey,
      factory: $JobsMapDetailExtension._fromState,
    );

extension $JobsMapDetailExtension on JobsMapDetail {
  static JobsMapDetail _fromState(GoRouterState state) => JobsMapDetail(
        jobId: state.pathParameters['jobId']!,
      );

  String get location => GoRouteData.$location(
        '/job/${Uri.encodeComponent(jobId)}/detail',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
