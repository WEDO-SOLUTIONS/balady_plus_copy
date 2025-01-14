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
  const DriveBackHomeCard({super.key});

  void openNavigationBackHome(BuildContext context, WidgetRef ref) {
    ref.read(authMethodsProvider.notifier).authAndOpen(
      context,
      callback: () async {
        if (!context.mounted) {
          return;
        }
        Metrics.logEventAdvanced(
          MetricsConstants.exploreKeys.bookmarkIcon,
          action: MetricAction.tap.name,
          group: MetricsConstants.exploreTag,
        );

        ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetircsKeys.exploreLandingEngagement);

        var home = ref.read(favouriteCacheProvider).valueOrNull?.home;

        /// If there is no home as user to add it.
        if (home == null) {
          await context.router.push(
            FavouritesSearchRoute(
              markerType: FavouriteItemMarkerType.home,
            ),
          );
          home = ref.read(favouriteCacheProvider).valueOrNull?.home;

          if (home == null) {
            return;
          }
        }

        final location = ref.read(locationProvider);
        if (location == null) {
          ToastOverlay.of(context).showBaseError(onRetry: () {});
          return;
        }

        final startLocation = RouteParamsPoint(
          latitude: location.latitude,
          longitude: location.longitude,
        );

        final coordinates = home.coordinates;
        final finishLocation = RouteParamsPoint(
          latitude: coordinates.latitude,
          longitude: coordinates.longitude,
          objectId: int.tryParse(home.id),
        );

        const navigatingType = RouteSearchOptionsMessage.car;
        final _routeType = navigatingType.toRouteType();

        ref.listenManual(
            routesProvider(
              startPoint: startLocation,
              finishPoint: finishLocation,
              navType: navigatingType,
            ), (_, current) async {
          final routes = current.valueOrNull;
          final route = routes?.firstOrNull;
          if (route == null) {
            return;
          }

          EtaStreamStorage()
            ..setLatitude(finishLocation.latitude)
            ..setLongitude(finishLocation.longitude);

          ref.read(etaRouteInfoProvider.notifier).setRoute(eta.EtaRoute(
                startPoint: EtaRoutePoint(
                  lat: location.latitude,
                  lon: location.longitude,
                ),
                endPoint: EtaRoutePoint(
                  lat: location.latitude,
                  lon: location.longitude,
                ),
                type: _routeType,
                routeIndex: 0,
                createdAt: DateTime.now().toUtc().toIso8601String(),
              ));

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

          return;
        }, fireImmediately: true);
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driveBackHomeText = context.l10n.driveBackHome.split('\n');

    return Padding(
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
                          text: driveBackHomeText.first,
                          style: context.textStyleV3.h3Medium.copyWith(
                            color: Colors.white,
                          ),
                          children: [
                            TextSpan(
                              text: '\n${driveBackHomeText.last}',
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
