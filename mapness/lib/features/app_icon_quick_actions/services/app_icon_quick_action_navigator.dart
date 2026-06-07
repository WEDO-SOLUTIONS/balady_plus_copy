import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/app_icon_quick_actions/data/app_icon_quick_actions_config_datasource.dart';
import 'package:mapness/features/share_eta/providers/share_my_location_launch_intent.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod/riverpod.dart';

/// Direct in-app navigation for app icon shortcuts (skips HTTP redirect in [openAppLink]).
class AppIconQuickActionNavigator {
  const AppIconQuickActionNavigator(this.ref);

  final Ref ref;

  Future<void> open({
    required Uri destination,
    bool isFirstRun = false,
  }) async {
    final path = _resolvePath(destination);
    if (path.isEmpty) {
      throw StateError('Unsupported quick action destination: $destination');
    }

    if (isFirstRun) {
      await Future<void>.delayed(const Duration(milliseconds: 400));
    }

    final router = ref.read(appRouterProvider);

    logger.log('AppIconQuickActions: navigating to $path');

    switch (path) {
      case '/favourites':
        await router.push(const FavouritesRoute());
      case '/directions':
        final allowed = await ref.read(locationProvider.notifier).checkLocationPermission();
        if (allowed) {
          await router.navigate(const RoutingPointsRoute());
        }
      case '/search':
        await router.push(SearchRoute(requestFocus: true));
      case '/shareMyLocation':
        await router.push(ShareMyLocationRoute());
      case '/shareLiveLocation':
        ref.read(shareMyLocationLaunchIntentProvider.notifier).requestLiveLocationOptions();
        await router.push(ShareMyLocationRoute());
      case '/contribute':
        await router.push(const ContributeRoute());
      case '/snapSend':
        CommonFunctions.openMiniApp(serviceKey: 'snapandsend');
      default:
        throw StateError('Unsupported quick action path: $path');
    }
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
