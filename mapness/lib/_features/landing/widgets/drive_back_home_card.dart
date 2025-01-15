import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/_features/favourites/providers/favourite_cache.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/features/routing/providers/routes.dart';
import 'package:mapness/features/share_eta/entities/route_type_mapper.dart';
import 'package:mapness/features/share_eta/models/eta_route_info.dart' as eta;
import 'package:mapness/features/share_eta/models/eta_route_info.dart';
import 'package:mapness/features/share_eta/providers/eta_route_info_provider.dart';
import 'package:mapness/features/share_eta/providers/eta_stream_storage.dart';
import 'package:mapness/pages/path_nav/path_nav_page.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/auth/auth_methods.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/urbi_analytics.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';

class DriveBackHomeCard extends ConsumerWidget {
  static const navigatingType = RouteSearchOptionsMessage.car;

  const DriveBackHomeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
        child: GestureDetector(
          onTap: () => openNavigationBackHome(context, ref),
          child: SizedBox(
            width: double.infinity,
            height: 123,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(RadiusBorder.xl),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(RadiusBorder.xl),
                  boxShadow: Shadows.s,
                  image: const DecorationImage(
                    image: AssetImage('assets/images/drive_home_background.png'),
                    matchTextDirection: true,
                    fit: BoxFit.cover,
                    alignment: AlignmentDirectional.centerEnd,
                  ),
                ),
                child: Stack(
                  children: [
                    const Positioned(
                      top: 40,
                      left: -60,
                      child: BluredCircle(size: 181, blur: 149.85, opacity: 0.4),
                    ),
                    const Positioned(
                      top: -110,
                      right: -140,
                      child: BluredCircle(size: 258, blur: 185.11, opacity: 0.3),
                    ),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Image.asset(
                        'assets/images/drive_home_arrow.png',
                        matchTextDirection: true,
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(top: 12.0, start: 16.0),
                        child: RichText(
                          text: TextSpan(
                            text: context.l10n.driveBack,
                            style: context.textStyleV3.h3Medium.copyWith(
                              color: Colors.white,
                            ),
                            children: [
                              TextSpan(
                                text: '\n${context.l10n.homeQuestionMark}',
                                style: context.textStyleV3.h3Medium.copyWith(
                                  color: const Color(0xFF00FFFA),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  void openNavigationBackHome(BuildContext context, WidgetRef ref) {
    ref.read(authMethodsProvider.notifier).authAndOpen(
      context,
      callback: () async {
        if (!context.mounted) {
          return;
        }

        final home = await getHome(context, ref);

        /// If no home, exit from the function and not openning navigator to driving back home.
        if (home == null) {
          return;
        }

        /// If no navigation points, exit from the function and not openning navigator to driving back home.
        final locations = getNavigationPoints(context, ref, home);
        if (locations == null) {
          return;
        }

        final (startLocation, finishLocation) = locations;

        ref.listenManual(
          routesProvider(
            startPoint: startLocation,
            finishPoint: finishLocation,
            navType: navigatingType,
          ),
          (_, current) => navigateBackHomeCallback(
            current,
            context,
            ref,
            startLocation,
            finishLocation,
          ),
          fireImmediately: true,
        );
      },
    );
  }

  Future<FavouriteItem?> getHome(BuildContext context, WidgetRef ref) async {
    ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetircsKeys.exploreLandingEngagement);

    final home = ref.read(favouriteCacheProvider).valueOrNull?.home;

    /// If there is no home ask user to add it.
    if (home == null) {
      await context.router.push(
        FavouritesSearchRoute(
          markerType: FavouriteItemMarkerType.home,
        ),
      );
      return ref.read(favouriteCacheProvider).valueOrNull?.home;
    }
    return home;
  }

  (RouteParamsPoint start, RouteParamsPoint end)? getNavigationPoints(
    BuildContext context,
    WidgetRef ref,
    FavouriteItem home,
  ) {
    final location = ref.read(locationProvider);
    if (location == null) {
      ToastOverlay.of(context).showBaseError(onRetry: () {});
      return null;
    }

    final startLocation = RouteParamsPoint(
      latitude: location.latitude,
      longitude: location.longitude,
    );

    final finishLocation = RouteParamsPoint(
      latitude: home.coordinates.latitude,
      longitude: home.coordinates.longitude,
      objectId: int.tryParse(home.id),
    );

    return (startLocation, finishLocation);
  }

  Future<void> navigateBackHomeCallback(
    AsyncValue<List<RouteInfo>> current,
    BuildContext context,
    WidgetRef ref,
    RouteParamsPoint startLocation,
    RouteParamsPoint finishLocation,
  ) async {
    final _routeType = navigatingType.toRouteType();
    final routes = current.valueOrNull;
    final route = routes?.firstOrNull;
    if (route == null) {
      return;
    }

    setupEta(finishLocation, ref, startLocation, _routeType);
    await setupMap(ref);
    await openNavigation(ref, route, context);
  }

  Future<void> openNavigation(WidgetRef ref, RouteInfo route, BuildContext context) async {
    ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetircsKeys.navigationRoutingStartedJorney);
    await ref.read(urbiAnalyticsProvider).track(
      'startNavigation',
      properties: {
        'duration': route.duration,
        'distance': route.distance,
      },
    );

    await context.router.push(
      PathNavRoute(
        navType: navigatingType,
        isHomeOrWork: true,
        initAction: PathNavPageInitAction.startNavigation,
      ),
    );
  }

  Future<void> setupMap(WidgetRef ref) async {
    final mapSetting = MapObjectManagerSettings.search();
    await ref
        .read(
          mapObjectManagerProvider(
            named: mapSetting.name,
            layerId: mapSetting.layerId,
          ).notifier,
        )
        .removeAllMarkers();

    Metrics.logEventAdvanced(
      MetricsConstants.routesKeys.routeSelectionGoButton,
      group: MetricsConstants.routesTag,
      action: MetricAction.tap.toString(),
    );
  }

  void setupEta(
      RouteParamsPoint finishLocation, WidgetRef ref, RouteParamsPoint startLocation, eta.RouteType _routeType) {
    EtaStreamStorage()
      ..setLatitude(finishLocation.latitude)
      ..setLongitude(finishLocation.longitude);

    ref.read(etaRouteInfoProvider.notifier).setRoute(eta.EtaRoute(
          startPoint: EtaRoutePoint(
            lat: startLocation.latitude,
            lon: startLocation.longitude,
          ),
          endPoint: EtaRoutePoint(
            lat: finishLocation.latitude,
            lon: finishLocation.longitude,
          ),
          type: _routeType,
          routeIndex: 0,
          createdAt: DateTime.now().toUtc().toIso8601String(),
        ));
  }
}

class BluredCircle extends StatelessWidget {
  final double size;
  final double blur;
  final double opacity;

  const BluredCircle({
    required this.size,
    required this.blur,
    required this.opacity,
    super.key,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        width: size,
        height: size,
        child: Opacity(
          opacity: opacity,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur, tileMode: TileMode.decal),
            child: const DecoratedBox(
              decoration: BoxDecoration(
                color: Color(0xff00FFFA),
                borderRadius: BorderRadius.all(Radius.circular(RadiusBorder.full)),
              ),
            ),
          ),
        ),
      );
}
