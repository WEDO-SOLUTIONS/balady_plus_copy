import 'dart:async';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/city_event/city_event.dart';
import 'package:mapness/entities/favourites/favourite_item.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/features/city_event/active_city_event.dart';
import 'package:mapness/features/favourites/providers/favourite_cache.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/auth/auth_methods.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:sheetify/sheetify.dart';
import 'package:urbi_utils/urbi_utils.dart';

class DriveBackHomeCard extends ConsumerStatefulWidget {
  final MultiStateSheetController<ThreeStateSheet> bottomSheetController;

  const DriveBackHomeCard({
    required this.bottomSheetController,
    super.key,
  });

  @override
  ConsumerState<DriveBackHomeCard> createState() => _DriveBackHomeCardState();
}

class _DriveBackHomeCardState extends ConsumerState<DriveBackHomeCard> with AutomaticKeepAliveClientMixin {
  final Debouncer debouncer = Debouncer(Durations.extralong4);

  @override
  Widget build(BuildContext context) {
    final activeCityEvent = ref.watch(activeCityEventProvider);

    final showBlueCircles = activeCityEvent?.showBlueCircles ?? true;
    final isDark = ref.watch(darkModeProvider).value?.isDark ?? false;

    super.build(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
      child: GestureDetector(
        onTap: () => tryOpenNavigationBackHome(context, ref),
        child: SizedBox(
          width: double.infinity,
          height: 123,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.colors.backgroundSurface5,
              borderRadius: BorderRadius.circular(RadiusBorder.xl),
              boxShadow: Shadows.s,
              image: DecorationImage(
                image: activeCityEvent.getDriveHomeBackground(isDark: isDark),
                matchTextDirection: true,
                fit: BoxFit.fill,
              ),
            ),
            child: Stack(
              children: [
                if (showBlueCircles) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(RadiusBorder.xl),
                    child: const Stack(
                      children: [
                        Positioned(top: 40, left: -60, child: _BluredCircle(size: 181, blur: 149.85, opacity: 0.4)),
                        Positioned(top: -110, right: -140, child: _BluredCircle(size: 258, blur: 185.11, opacity: 0.3)),
                      ],
                    ),
                  ),
                ],
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child:
                      activeCityEvent?.driveHomeArrow ?? Assets.images.driveHomeArrow.image(matchTextDirection: true),
                ),
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(top: 20.0, start: 22.0),
                    child: RichText(
                      text: TextSpan(
                        text: context.l10n.driveBack,
                        style: context.textStyles.h3SemiBold.copyWith(
                          color: activeCityEvent?.textColor(context.colors) ?? context.colors.foregroundDefault,
                        ),
                        children: [
                          TextSpan(
                            text: '\n${context.l10n.homeQuestionMark}',
                            style: context.textStyles.h3SemiBold.copyWith(color: context.colors.accentDefault),
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
    );
  }

  void tryOpenNavigationBackHome(BuildContext context, WidgetRef ref) {
    final locationLabel = context.l10n.myLocation;
    final homeLabel = context.l10n.home;
    final router = ref.read(appRouterProvider);

    debouncer.debounce(
      () async {
        hideLandingSheet();
        await waitForLandingSheetToSettle();
        if (!mounted || !context.mounted) {
          return;
        }
        await ref
            .read(authMethodsProvider.notifier)
            .authAndOpen(
              context,
              callback: () async => authAndOpenNavigator(
                ref,
                router,
                locationLabel,
                homeLabel,
              ),
            );
      },
    );
  }

  Future<void> authAndOpenNavigator(WidgetRef ref, StackRouter router, String locationLabel, String homeLabel) async {
    /// Force update authProvider when the user was not authenticated to get relavant favorites.
    final isAuth = ref.read(authProvider).value != null;
    if (!isAuth) {
      await ref.read(authProvider.notifier).forceUpdate();
      if (!mounted) {
        return;
      }
    }

    final home = await getHome(router);
    if (!mounted) {
      return;
    }

    /// If no home, exit from the function and not openning navigator to driving back home.
    if (home == null) {
      return;
    }

    /// If no navigation points, exit from the function and not openning navigator to driving back home.
    final locations = getNavigationPoints(home);
    if (locations == null) {
      return;
    }

    final (startLocation, finishLocation) = locations;

    hideLandingSheet();
    await waitForLandingSheetToSettle();
    if (!mounted) {
      return;
    }

    await setupMap(ref);
    if (!mounted) {
      return;
    }
    await openNavigation(router, locationLabel, homeLabel, startLocation, finishLocation);
  }

  Future<FavouriteItem?> getHome(StackRouter router) async {
    ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.exploreLandingEngagement);

    final home = (await ref.read(favouriteCacheProvider.future)).home;

    /// If there is no home ask user to add it.
    if (home == null) {
      hideLandingSheet();
      await waitForLandingSheetToSettle();
      if (!mounted) {
        return null;
      }
      final selectedHome = await router.push<FavouriteItem>(
        FavouritesSearchRoute(markerType: FavouriteItemMarkerType.home),
      );
      if (selectedHome != null) {
        await Future<void>.delayed(const Duration(milliseconds: 200));
      }
      return selectedHome;
    }
    return home;
  }

  (RouteParamsPoint start, RouteParamsPoint end)? getNavigationPoints(FavouriteItem home) {
    final location = ref.read(locationProvider);
    if (location == null) {
      return null;
    }

    final startLocation = RouteParamsPoint(latitude: location.latitude, longitude: location.longitude);

    final finishLocation = RouteParamsPoint(
      latitude: home.coordinates.latitude,
      longitude: home.coordinates.longitude,
      objectId: int.tryParse(home.id),
    );

    return (startLocation, finishLocation);
  }

  Future<void> openNavigation(
    StackRouter router,
    String locationLabel,
    String homeLabel,
    RouteParamsPoint startLocation,
    RouteParamsPoint finishLocation,
  ) async => router.push(
    RoutingRoutesRoute(
      points: [
        RouteParamsPointWithLabel(value: startLocation, label: locationLabel),
        RouteParamsPointWithLabel(
          value: RouteParamsPoint(
            latitude: finishLocation.latitude,
            longitude: finishLocation.longitude,
            objectId: finishLocation.objectId,
            entranceId: finishLocation.entranceId,
            levelId: finishLocation.levelId,
          ),
          label: homeLabel,
        ),
      ],
    ),
  );

  void hideLandingSheet() {
    if (widget.bottomSheetController.closestState != ThreeStateSheet.hidden) {
      widget.bottomSheetController.setState(
        ThreeStateSheet.hidden,
        duration: const Duration(milliseconds: 1),
      );
    }
  }

  Future<void> waitForLandingSheetToSettle() => Future<void>.delayed(const Duration(milliseconds: 32));

  Future<void> setupMap(WidgetRef ref) async {
    final mapSetting = MapObjectManagerSettings.search();
    await ref
        .read(mapObjectManagerProvider(named: mapSetting.name, layerId: mapSetting.layerId).notifier)
        .removeAllMarkers();
  }

  @override
  bool get wantKeepAlive => true;
}

class _BluredCircle extends StatelessWidget {
  final double size;
  final double blur;
  final double opacity;

  const _BluredCircle({required this.size, required this.blur, required this.opacity});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: Opacity(
      opacity: opacity,
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur, tileMode: TileMode.decal),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.colors.backgroundSurface1,
            borderRadius: const BorderRadius.all(Radius.circular(RadiusBorder.full)),
          ),
        ),
      ),
    ),
  );
}
