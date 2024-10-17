import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/others/transparent_barrier.dart';
import 'package:mapness/features/stories/models/story_types.dart';
import 'package:mapness/features/stories/ui/stories_transition.dart';

import 'app_routes.gr.dart';
import 'others/onboard_route_guard.dart';

final appRouterProvider = Provider((ref) => AppRouter(ref));

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  AppRouter(this.ref);

  final ProviderRef ref;

  @override
  RouteType get defaultRouteType => const RouteType.cupertino();

  @override
  List<AutoRoute> get routes => [
        CustomRoute(
          page: OnboardRoute.page,
          opaque: false,
          transitionsBuilder: (_, __, ___, child) => StoriesTransition(
            type: StoryTypes.onboarding,
            child: child,
          ),
        ),
        CustomRoute(
          page: StoriesRoute.page,
          opaque: false,
          transitionsBuilder: (_, __, ___, child) => StoriesTransition(
            type: StoryTypes.network,
            child: child,
          ),
        ),
        AutoRoute(
          page: MapRoute.page,
          path: '/',
          keepHistory: false,
          initial: true,
          guards: [
            OnboardRouteGuard(ref),
          ],
          children: [
            CustomRoute(
              path: 'bottom_menu',
              page: BottomMenuRoute.page,
              initial: true,
              barrierDismissible: false,
              customRouteBuilder: customModalSheetBuilder,
              children: [
                CustomRoute(
                  path: 'explore',
                  initial: true,
                  page: LandingRoute.page,
                  transitionsBuilder: TransitionsBuilders.noTransition,
                ),
                CustomRoute(
                  path: 'routing',
                  page: RoutingPointsRoute.page,
                  transitionsBuilder: TransitionsBuilders.noTransition,
                ),
                CustomRoute(
                  path: 'services',
                  page: MapnessServicesRoute.page,
                  transitionsBuilder: TransitionsBuilders.noTransition,
                ),
                CustomRoute(
                  path: 'profile',
                  page: ProfileRoute.page,
                  transitionsBuilder: TransitionsBuilders.noTransition,
                ),
              ],
            ),
            CustomRoute(
              path: 'kiblah',
              page: KiblahRoute.page,
              fullscreenDialog: true,
              transitionsBuilder: TransitionsBuilders.fadeIn,
            ),
            CustomRoute(
              path: 'search',
              page: SearchRoute.page,
            ),
            CustomRoute(
              path: 'poi_card',
              page: PoiCardWidgetRoute.page,
              transitionsBuilder: TransitionsBuilders.fadeIn,
              customRouteBuilder: customModalSheetBuilder,
            ),
            CustomRoute(
              path: 'deeplink',
              page: DeeplinkRoute.page,
              transitionsBuilder: TransitionsBuilders.fadeIn,
              customRouteBuilder: customModalSheetBuilder,
            ),
            CustomRoute(
              path: 'shared_my_location',
              barrierDismissible: false,
              page: ShareMyLocationRoute.page,
              transitionsBuilder: TransitionsBuilders.slideBottom,
              customRouteBuilder: customModalSheetBuilder,
            ),
            CustomRoute(
              path: 'layers_sheet',
              transitionsBuilder: TransitionsBuilders.fadeIn,
              fullscreenDialog: true,
              allowSnapshotting: false,
              barrierDismissible: false,
              page: LayersSheetRoute.page,
              customRouteBuilder: modalSheetBuilder,
            ),
          ],
        ),
      ];

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
  Route<T> modalSheetBuilder<T>(
    BuildContext context,
    Widget child,
    AutoRoutePage<T> page,
  ) =>
      ModalBottomSheetRoute(
        settings: page,
        builder: (context) => child,
        isScrollControlled: true,
        modalBarrierColor: context.staticColor.surfaceOverlayModal,
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
  Route<T> customModalSheetBuilder<T>(
    BuildContext context,
    Widget child,
    AutoRoutePage<T> page,
  ) =>
      CustomModalRoute(page: page);
}
