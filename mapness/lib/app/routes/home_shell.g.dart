// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_shell.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $homeShellRoute,
    ];

RouteBase get $homeShellRoute => StatefulShellRouteData.$route(
      factory: $HomeShellRouteExtension._fromState,
      branches: [
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/profile',
              factory: $ProfilesRouteExtension._fromState,
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/services',
              factory: $ServicesRouteExtension._fromState,
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/routing',
              factory: $RoutingRouteExtension._fromState,
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/landing',
              factory: $LandingRouteExtension._fromState,
            ),
          ],
        ),
      ],
    );

extension $HomeShellRouteExtension on HomeShellRoute {
  static HomeShellRoute _fromState(GoRouterState state) =>
      const HomeShellRoute();
}

extension $ProfilesRouteExtension on ProfilesRoute {
  static ProfilesRoute _fromState(GoRouterState state) => const ProfilesRoute();

  String get location => GoRouteData.$location(
        '/profile',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ServicesRouteExtension on ServicesRoute {
  static ServicesRoute _fromState(GoRouterState state) => const ServicesRoute();

  String get location => GoRouteData.$location(
        '/services',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $RoutingRouteExtension on RoutingRoute {
  static RoutingRoute _fromState(GoRouterState state) => const RoutingRoute();

  String get location => GoRouteData.$location(
        '/routing',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $LandingRouteExtension on LandingRoute {
  static LandingRoute _fromState(GoRouterState state) => LandingRoute(
        focusMaker: _$convertMapValue('focus-maker', state.uri.queryParameters,
            _$LangingFocusMakerEnumMap._$fromName),
      );

  String get location => GoRouteData.$location(
        '/landing',
        queryParams: {
          if (focusMaker != null)
            'focus-maker': _$LangingFocusMakerEnumMap[focusMaker!],
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

const _$LangingFocusMakerEnumMap = {
  LangingFocusMaker.iwish: 'iwish',
  LangingFocusMaker.mosques: 'mosques',
};

T? _$convertMapValue<T>(
  String key,
  Map<String, String> map,
  T Function(String) converter,
) {
  final value = map[key];
  return value == null ? null : converter(value);
}

extension<T extends Enum> on Map<T, String> {
  T _$fromName(String value) =>
      entries.singleWhere((element) => element.value == value).key;
}
