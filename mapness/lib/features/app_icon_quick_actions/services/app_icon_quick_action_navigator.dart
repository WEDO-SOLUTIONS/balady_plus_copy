import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/app_icon_quick_actions/data/app_icon_quick_actions_config_datasource.dart';
import 'package:mapness/features/share_eta/providers/share_my_location_launch_intent.dart';
import 'package:mapness/shared/lib/auth/auth_methods.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod/riverpod.dart';

/// Direct in-app navigation for BRD quick actions (BR#04 — no HTTP redirect).
class AppIconQuickActionNavigator {
  const AppIconQuickActionNavigator(this.ref);

  final Ref ref;

  Future<void> open({
    required Uri destination,
    bool isFirstRun = false,
  }) async {
    final path = _resolvePath(destination);
    if (path.isEmpty || !isSupportedQuickActionDestination(destination)) {
      throw StateError('Unsupported quick action destination: $destination');
    }

    if (isFirstRun) {
      await Future<void>.delayed(const Duration(milliseconds: 400));
    }

    final router = ref.read(appRouterProvider);

    logger.log('AppIconQuickActions: navigating to $path');

    switch (path) {
      case '/favourites':
        await _openFavourites();
      case '/directions':
        // Tab route — permissions are handled in [AppIconQuickActionHandler].
        await router.navigate(const BottomMenuRoute(children: [RoutingPointsRoute()]));
      case '/search':
        await router.push(SearchRoute(requestFocus: true));
      case '/shareMyLocation':
        await router.push(ShareMyLocationRoute());
      case '/shareLiveLocation':
        ref.read(shareMyLocationLaunchIntentProvider.notifier).requestLiveLocationOptions();
        await router.push(ShareMyLocationRoute());
      case '/contribute':
        await router.push(const ContributeRoute());
      default:
        throw StateError('Unsupported quick action path: $path');
    }
  }

  /// Routes through the auth gate (like every other Favourites entry point) instead of
  /// pushing [FavoriteListsRoute] directly, so a cold-start quick action can't race the
  /// sign-in flow and hit favorite_lists endpoints before a valid token is attached.
  Future<void> _openFavourites() async {
    final context = rootNavigatorKey.currentContext;
    if (context == null || !context.mounted) {
      return;
    }
    await ref
        .read(authMethodsProvider.notifier)
        .authAndOpen(
          context,
          callback: () => ref.read(appRouterProvider).push(const FavoriteListsRoute()),
        );
  }

  String _resolvePath(Uri destination) {
    if (destination.fragment.isNotEmpty) {
      final fragmentUri = Uri.tryParse(destination.fragment);
      if (fragmentUri != null && fragmentUri.path.isNotEmpty) {
        return fragmentUri.path;
      }
    }
    return destination.path;
  }
}
