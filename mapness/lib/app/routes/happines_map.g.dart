// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'happines_map.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $happinessMapRoute,
    ];

RouteBase get $happinessMapRoute => GoRouteData.$route(
      path: '/happines_map',
      parentNavigatorKey: HappinessMapRoute.$parentNavigatorKey,
      factory: $HappinessMapRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: 'comment',
          parentNavigatorKey: HappinessMapCommentRoute.$parentNavigatorKey,
          factory: $HappinessMapCommentRouteExtension._fromState,
        ),
      ],
    );

extension $HappinessMapRouteExtension on HappinessMapRoute {
  static HappinessMapRoute _fromState(GoRouterState state) => HappinessMapRoute(
        bottomSheetOpened: _$convertMapValue(
            'bottom-sheet-opened', state.uri.queryParameters, _$boolConverter),
      );

  String get location => GoRouteData.$location(
        '/happines_map',
        queryParams: {
          if (bottomSheetOpened != null)
            'bottom-sheet-opened': bottomSheetOpened!.toString(),
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $HappinessMapCommentRouteExtension on HappinessMapCommentRoute {
  static HappinessMapCommentRoute _fromState(GoRouterState state) =>
      const HappinessMapCommentRoute();

  String get location => GoRouteData.$location(
        '/happines_map/comment',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

T? _$convertMapValue<T>(
  String key,
  Map<String, String> map,
  T Function(String) converter,
) {
  final value = map[key];
  return value == null ? null : converter(value);
}

bool _$boolConverter(String value) {
  switch (value) {
    case 'true':
      return true;
    case 'false':
      return false;
    default:
      throw UnsupportedError('Cannot convert "$value" into a bool.');
  }
}
