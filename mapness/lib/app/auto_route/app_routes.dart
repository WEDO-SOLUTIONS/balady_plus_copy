import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        AutoRoute(page: MapRoute.page, path: '/', children: [
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
            path: 'layers_sheet',
            transitionsBuilder: TransitionsBuilders.noTransition,
            fullscreenDialog: true,
            opaque: false,
            allowSnapshotting: false,
            page: LayersSheetRoute.page,
            customRouteBuilder: modalSheetBuilder,
          ),
          CustomRoute(
            page: BottomMenuRoute.page,
            guards: [
              OnboardRouteGuard(ref),
            ],
            initial: true,
            children: [
              CustomRoute(
                path: 'explore',
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
        ]),
      ];

  Route<T> modalSheetBuilder<T>(BuildContext context, Widget child, AutoRoutePage<T> page) => ModalBottomSheetRoute(
        settings: page,
        builder: (context) => child,
        isScrollControlled: true,
        modalBarrierColor: context.staticColor.surfaceOverlayModal,
        backgroundColor: Colors.transparent,
      );
}
