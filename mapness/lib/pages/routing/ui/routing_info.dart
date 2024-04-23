import 'dart:async';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/app/routes/path_nav.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/features/routing/providers/routes.dart';
import 'package:mapness/features/routing/ui/routes_carousel.dart';
import 'package:mapness/pages/routing/lib/route_point_extension.dart';
import 'package:mapness/pages/routing/lib/route_search_options_extension.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/extensions/double_ext.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/widgets/routing/lib/duration_distance_fmt.dart';
import 'package:mapness/widgets/routing/ui/route_type_switch.dart';

class RoutingInfo extends ConsumerStatefulWidget {
  final List<RouteParamsPoint?> points;

  const RoutingInfo({required this.points, super.key});

  @override
  ConsumerState<RoutingInfo> createState() => _RoutingInfoState();
}

class _RoutingInfoState extends ConsumerState<RoutingInfo> {
  final ValueNotifier<RouteSearchOptionsMessage> _navType =
      ValueNotifier(RouteSearchOptionsMessage.car);

  final ValueNotifier<bool> _isNavTypeLoading = ValueNotifier(true);

  ProviderSubscription? _locationListener;

  @override
  void initState() {
    super.initState();
    final location = ref.read(locationProvider);
    if (location != null) {
      unawaited(_calculateNavigationType(location));
    } else {
      _locationListener = ref.listenManual(locationProvider, (_, next) {
        if (next != null && _isNavTypeLoading.value == true) {
          _locationListener?.close();
          unawaited(_calculateNavigationType(location));
        }
      });
    }
  }

  @override
  void dispose() {
    _navType.dispose();
    _isNavTypeLoading.dispose();
    _locationListener?.close();
    super.dispose();
  }

  Future<void> _calculateNavigationType(GeoPointMessage? location) async {
    final dgisController = ref.read(dgisControllerProvider).valueOrNull;

    if (widget.points.length < 2 && widget.points[1] != null) {
      _isNavTypeLoading.value = false;
      return;
    }

    final finishPoint = widget.points[1]!;

    if (location == null ||
        dgisController == null ||
        finishPoint.dgisObjectId == null) {
      _isNavTypeLoading.value = false;
      return;
    }

    double distance = 0;
    double time = 0;

    try {
      final briefInfo = await dgisController.findBriefRouteInfos(
        options: RouteSearchOptionsMessage.pedestrian,
        finishPoint: finishPoint.routeSearchPointMessage,
      );

      if (briefInfo.isEmpty) {
        _isNavTypeLoading.value = false;
        return;
      }

      // distance in meters, convert to km
      distance = briefInfo.first!.extraInfo.distance.toDouble().toKilometers();
      time = briefInfo.first!.duration.toMinutes();
      // ignore: avoid_catches_without_on_clauses
    } catch (_) {
      distance = CommonFunctions.distance(
        location.latitude,
        location.longitude,
        finishPoint.geoPoint.latitude,
        finishPoint.geoPoint.longitude,
      );
    }

    // if distance is less than 0.5 km and time <= 5 min then use pedestrian
    if (distance < 0.5 && time.floor() <= 5) {
      _navType.value = RouteSearchOptionsMessage.pedestrian;
    }
    // if distance is less than 0.7 km and time <= 7 min then use pedestrian just for in building navigation
    else if (distance < 0.7 && time.floor() <= 7) {
      // Check if finish point is in building, if we have building name then it's in building)
      final objectInfo =
          await dgisController.searchByObjectId(finishPoint.dgisObjectId!);
      if (objectInfo.buildingInfo.buildingName != null) {
        _navType.value = RouteSearchOptionsMessage.pedestrian;
      }
    }

    _isNavTypeLoading.value = false;
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
        valueListenable: _isNavTypeLoading,
        builder: (context, isLoading, child) => switch (isLoading) {
          true => Center(
              child: Loading.large(),
            ),
          false => ValueListenableBuilder(
              valueListenable: _navType,
              builder: (context, navigatingType, _) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      Expanded(
                        child: RoutesCarousel(
                          points: widget.points,
                          startNavigation: () {
                            PathNavRoute.open(
                              ref.watch(goRouterProvider),
                              navigatingType,
                            );
                          },
                          navType: navigatingType,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _RouteTabBar(
                        active: navigatingType,
                        onChanged: (e) {
                          _navType.value = e;
                        },
                        points: widget.points,
                      ),
                      const SizedBox(height: 16),
                    ],
                  )),
        },
      );
}

class _RouteTabBar extends ConsumerWidget {
  const _RouteTabBar({
    required this.onChanged,
    required this.active,
    required this.points,
  });
  final void Function(RouteSearchOptionsMessage) onChanged;
  final RouteSearchOptionsMessage active;
  final List<RouteParamsPoint?> points;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routes = ref
            .watch(
              routesProvider(
                startPoint: points[0],
                finishPoint: points[1],
                navType: active,
              ),
            )
            .unwrapPrevious()
            .valueOrNull ??
        [];
    final activeRoute = ref.watch(activeRouteProvider);
    final routeDuration = routes.isEmpty ? null : routes[activeRoute].duration;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          RouteSearchOptionsMessage.pedestrian,
          RouteSearchOptionsMessage.car,
        ]
            .map(
              (e) => RouteTypeSwitch(
                iconAsset: e.icon,
                title: active == e
                    ? routeDuration?.formatDuration(context.l10n)
                    : null,
                onPressed: () => onChanged(e),
                isChoosed: active == e,
              ),
            )
            .toList(),
      ),
    );
  }
}
