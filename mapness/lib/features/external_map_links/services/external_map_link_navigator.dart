// Turns the intents parsed out of an external map link into navigation.
//
// Deliberately free of `BuildContext`: the caller is the deep-link dispatcher
// in `entry_point.dart`, which runs while the router may still be settling, so
// everything here goes through providers and the root router.

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Package import on purpose: the feature's own folder is named `lib`, and a
// relative path through it trips `avoid_relative_lib_imports`.
import 'package:mapness/features/external_map_links/lib/external_map_travel_mode_mapper.dart';

import '../../../app/auto_route/app_routes.dart';
import '../../../app/auto_route/app_routes.gr.dart';
import '../../../app/auto_route/poi_card_ext.dart';
import '../../../entities/routing/route_params_point.dart';
import '../../../shared/providers/map/dgis_controller.dart';
import '../../../shared/ui/toast/app_locale.dart';
import '../../../shared/utils/logger/logger.dart';
import '../../poi_card/domain/model/poi_camera_config.dart';
import '../../search/providers/search.dart';
import '../../search/ui/search_scope.dart';
import '../models/external_map_link_intent.dart';

/// Executes the intents produced by `ExternalMapLinkParser`.
class ExternalMapLinkNavigator {
  const ExternalMapLinkNavigator(this.ref);

  final WidgetRef ref;

  /// Zoom used when the caller did not ask for one — the same level the other
  /// point deep links open at.
  static const double _defaultZoom = 17;

  /// A caller waiting on a cold start should not wait forever for a geocode.
  static const Duration _geocodeTimeout = Duration(seconds: 10);

  Future<void> open(ExternalMapLinkIntent intent) => switch (intent) {
    ExternalMapSearchIntent() => openSearch(intent),
    ExternalMapShowLocationIntent() => openLocationCard(intent),
    ExternalMapDirectionsIntent() => openDirections(intent),
  };

  /// Opens the search sheet and runs the query in it, biased to the `near`
  /// hint when the link carried one and to the Kingdom otherwise.
  Future<void> openSearch(ExternalMapSearchIntent intent) async {
    final router = ref.read(appRouterProvider);
    final near = intent.near;

    // Mirrors the quick-filter deep link: push first, search in the next frame,
    // so the sheet is mounted and listening when the results land. No
    // `initialState` — it would kick off a competing suggest request.
    unawaited(router.push(SearchRoute(requestFocus: false)));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(searchProvider(SearchScopeEnum.map.value).notifier)
          .searchByText(
            intent.query,
            searchRect: near != null
                ? Search.rectAround(GeoPointMessage(latitude: near.latitude, longitude: near.longitude))
                : Search.kingdomSearchRect,
          );
    });
  }

  /// Opens the point card for an exact coordinate, titled with the caller's
  /// label when it sent one.
  Future<void> openLocationCard(ExternalMapShowLocationIntent intent) => ref
      .read(appRouterProvider)
      .replaceOrPush(
        route: DeeplinkRoute(
          closestPoint: LatLng(latitude: intent.point.latitude, longitude: intent.point.longitude),
          label: intent.label,
          cameraConfig: PoiCameraConfig(zoom: intent.zoom ?? _defaultZoom),
        ),
        toCompareRoutes: [DeeplinkRoute.page, PoiCardWidgetRoute.page],
      );

  /// Opens the routing page. The route search starts on its own once the page
  /// has both points; a null source value means "my location", and the routing
  /// page asks for the permission itself.
  Future<void> openDirections(ExternalMapDirectionsIntent intent) async {
    final l10n = ref.read(appLocaleProvider);
    final myLocation = RouteParamsPointWithLabel(value: null, label: l10n.myLocation);

    final destination = await _resolvePlace(intent.destination, fallbackLabel: l10n.pointToMap);
    if (destination == null) {
      // Free text we could not geocode. Showing its search results is far more
      // useful than a toast the user can do nothing about.
      await openSearch(ExternalMapSearchIntent(query: _queryOf(intent.destination)));
      return;
    }

    final source = intent.source == null
        ? myLocation
        // A source we cannot resolve is not worth failing the whole link over:
        // routing from where the user stands is the sane default.
        : await _resolvePlace(intent.source!, fallbackLabel: l10n.pointToMap) ?? myLocation;

    await ref
        .read(appRouterProvider)
        .replaceOrPush(
          route: RoutingRoutesRoute(points: [source, destination], navType: intent.mode.routeSearchOption),
          shouldPopAndPush: true,
          toCompareRoutes: [RoutingRoutesRoute.page, PoiCardWidgetRoute.page],
        );
  }

  /// `null` only when [place] is free text that could not be geocoded.
  Future<RouteParamsPointWithLabel?> _resolvePlace(ExternalMapPlace place, {required String fallbackLabel}) async =>
      switch (place) {
        ExternalMapPlacePoint(:final point, :final label) => RouteParamsPointWithLabel(
          label: label ?? fallbackLabel,
          value: RouteParamsPoint(latitude: point.latitude, longitude: point.longitude),
        ),
        ExternalMapPlaceQuery(:final query) => await _geocodeFirstHit(query),
      };

  /// First searchable hit for [query] inside the Kingdom, or `null` when the
  /// search is empty, fails or takes too long.
  Future<RouteParamsPointWithLabel?> _geocodeFirstHit(String query) async {
    try {
      final dgisController = await ref.read(dgisControllerProvider.future);
      final results = await dgisController
          .search(
            query,
            spatialRestriction: Search.kingdomRestriction,
            searchRect: Search.kingdomSearchRect,
            pageSize: 1,
          )
          .timeout(_geocodeTimeout);

      final object = results.firstPage?.items.firstWhereOrNull((item) => item.markerPosition != null);
      if (object == null) {
        logger.log('External map link: nothing found for "$query"', logLevel: MapnessLogLevel.warning);
        return null;
      }
      return RouteParamsPointWithLabel.fromDirectoryObject(object);
    } catch (e) {
      logger.log('External map link: failed to geocode "$query": $e', logLevel: MapnessLogLevel.error);
      return null;
    }
  }

  /// Text to search for when a place could not be resolved to a point.
  String _queryOf(ExternalMapPlace place) => switch (place) {
    ExternalMapPlaceQuery(:final query) => query,
    ExternalMapPlacePoint(:final point, :final label) => label ?? '${point.latitude},${point.longitude}',
  };
}
