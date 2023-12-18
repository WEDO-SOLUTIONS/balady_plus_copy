// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $profileRoute,
    ];

RouteBase get $profileRoute => GoRouteData.$route(
      path: '/profile',
      parentNavigatorKey: ProfileRoute.$parentNavigatorKey,
      factory: $ProfileRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: 'settings',
          parentNavigatorKey: SettingsRoute.$parentNavigatorKey,
          factory: $SettingsRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'help_center',
          parentNavigatorKey: HelpCenterRoute.$parentNavigatorKey,
          factory: $HelpCenterRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'about_balady',
          parentNavigatorKey: AboutBaladyRoute.$parentNavigatorKey,
          factory: $AboutBaladyRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'momra_website',
          parentNavigatorKey: MomraWebsitePageRoute.$parentNavigatorKey,
          factory: $MomraWebsitePageRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'info',
          parentNavigatorKey: ProfileInfoPageRoute.$parentNavigatorKey,
          factory: $ProfileInfoPageRouteExtension._fromState,
        ),
      ],
    );

extension $ProfileRouteExtension on ProfileRoute {
  static ProfileRoute _fromState(GoRouterState state) => const ProfileRoute();

  String get location => GoRouteData.$location(
        '/profile',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $SettingsRouteExtension on SettingsRoute {
  static SettingsRoute _fromState(GoRouterState state) => const SettingsRoute();

  String get location => GoRouteData.$location(
        '/profile/settings',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $HelpCenterRouteExtension on HelpCenterRoute {
  static HelpCenterRoute _fromState(GoRouterState state) =>
      const HelpCenterRoute();

  String get location => GoRouteData.$location(
        '/profile/help_center',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $AboutBaladyRouteExtension on AboutBaladyRoute {
  static AboutBaladyRoute _fromState(GoRouterState state) =>
      const AboutBaladyRoute();

  String get location => GoRouteData.$location(
        '/profile/about_balady',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $MomraWebsitePageRouteExtension on MomraWebsitePageRoute {
  static MomraWebsitePageRoute _fromState(GoRouterState state) =>
      const MomraWebsitePageRoute();

  String get location => GoRouteData.$location(
        '/profile/momra_website',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ProfileInfoPageRouteExtension on ProfileInfoPageRoute {
  static ProfileInfoPageRoute _fromState(GoRouterState state) =>
      const ProfileInfoPageRoute();

  String get location => GoRouteData.$location(
        '/profile/info',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
