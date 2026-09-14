import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart' as sdk;
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/app/auto_route/poi_card_ext.dart';
import 'package:mapness/entities/wrc/wrc_event.dart';
import 'package:mapness/features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/features/poi_card/extensions/geopoint_mapper.dart';
import 'package:mapness/features/wrc/wrc_debug.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/map/point_of_interest.dart';
import 'package:mapness/shared/providers/media_query.dart';
import 'package:mapness/shared/utils/detach.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wrc.g.dart';
part 'wrc_points.dart';
part 'wrc_search_queries.dart';

const _currentDateCheckInterval = Duration(minutes: 15);

/// Provider that checks if the current time is between two specified dates
///
/// Returns `true` if the current time is between the start and end dates,
/// `false` otherwise.
@riverpod
class WRC extends _$WRC {
  static String get dashboardImagePath => Assets.images.wrcDashboard.keyName;
  static const deeplinkEventValue = 'wrc2025';

  // we need to check if current date comes in or goes out of event date range as the time goes by
  late Timer _timer;

  MapObjectManager? mapManager;

  @override
  bool build() {
    mapManager = ref.watch(
      mapObjectManagerProvider(
        named: const MapObjectManagerSettings.wrcEvent().name,
        layerId: const MapObjectManagerSettings.wrcEvent().layerId,
      ).notifier,
    );
    Future.delayed(Duration.zero, initializeGlobalMarkers);

    // start timer to rebuild this state over time
    _timer = Timer(_currentDateCheckInterval, ref.invalidateSelf);
    ref.onDispose(_timer.cancel);

    // Check if debug override is enabled
    final debugOverride = ref.watch(wRCDebugProvider);
    if (debugOverride) {
      return true;
    }

    final wrcEventDateRange = ref.watch(dgisEnvironmentProvider.select((value) => value.value?.wrcEventDateRange));
    debugPrint('wrcEventDateRange($wrcEventDateRange) isNow(${wrcEventDateRange?.isNow})');
    if (wrcEventDateRange != null) {
      return wrcEventDateRange.isNow;
    }

    return false;
  }

  /// Checks if the custom pin should be shown, based on the object ID
  bool isWRCEventObject(
    int objectId,
    GeoPointMessage? closestPoint,
  ) =>
      wrcEventPoints.any((point) {
        final isNearPoint = closestPoint?.isNearPoint(point.center) ?? false;
        return isNearPoint || point.objectId == objectId;
      }) &&
      state;

  WRCEventPoint? getWRCEventPoint(int objectId) =>
      wrcEventPoints.firstWhereOrNull((point) => point.objectId == objectId);

  /// Manually triggers an update of the state
  void refresh() {
    ref.read(dgisEnvironmentProvider).whenData(
      (data) {
        state = data.wrcEventDateRange.isNow;
      },
    );
  }

  Future<void> initializeGlobalMarkers() async {
    if (!state) {
      return;
    }

    for (final point in wrcEventPoints) {
      try {
        await mapManager?.removeMarkerById(point.globalMarkerId);

        final globalMarker = sdk.Marker(
          id: point.globalMarkerId,
          options: sdk.MarkerOptionsMessage(
            position: _getMarkerPosition(point),
            icon: _getIcon(point),
            anchor: _markerAnchor,
            text: _getTitle(point),
            textStyle: _markerAnchorTextStyle,
            animatedAppearance: true,
            isVisible: false,
            zIndex: _zIndex,
          ),
          onTap: () => openThePlace(point),
        );

        await mapManager?.addMarker(globalMarker);
      } on Object catch (e) {
        debugPrint('failed to initialize WRC map marker: $e');
      }
    }

    await showAllMarkers();
  }

  Future<void> showAllMarkers() async {
    if (!state) {
      return;
    }
    for (final point in wrcEventPoints) {
      detach(_showPointMarker(point), tag: 'wrc.showPointMarker');
    }
  }

  Future<void> showSpecificMarker(sdk.Marker marker) async {
    if (!state) {
      return;
    }
    final point = _getPointByMarker(marker);
    if (point != null) {
      await _showPointMarker(point);
    }
  }

  Future<void> _showPointMarker(WRCEventPoint point) async {
    if (!state) {
      return;
    }
    await mapManager?.setMarkerOptions(
      point.globalMarkerId,
      sdk.ChangeMarkerOptionsMessage(
        position: _getMarkerPosition(point),
        icon: _getIcon(point),
        anchor: _markerAnchor,
        text: _getTitle(point),
        textStyle: _markerAnchorTextStyle,
        animatedAppearance: true,
        isVisible: true,
        zIndex: _zIndex,
      ),
    );
  }

  Future<void> hideAllMarkers() async {
    for (final point in wrcEventPoints) {
      detach(
        mapManager?.setMarkerOptions(point.globalMarkerId, sdk.ChangeMarkerOptionsMessage(isVisible: false)),
        tag: 'wrc.ChangeMarkerOptionsMessage',
      );
    }
  }

  Future<void> hideSpecificMarker(sdk.Marker marker) async {
    final point = _getPointByMarker(marker);
    if (point != null) {
      await mapManager?.setMarkerOptions(point.globalMarkerId, sdk.ChangeMarkerOptionsMessage(isVisible: false));
    }
  }

  void openThePlace(WRCEventPoint point) {
    ref
        .read(appRouterProvider)
        .replaceOrPush(
          route: PoiCardWidgetRoute(
            objectId: sdk.DgisObjectIdMessage(
              objectId: point.objectId,
              entranceId: 0,
            ),
            cameraConfig: const PoiCameraConfig(zoom: 17),
          ),
          toCompareRoutes: [PoiCardWidgetRoute.page],
        );
  }

  Future<void> moveCameraToEventArea() async {
    await ref
        .read(cameraPositionProvider.notifier)
        .animateToGeoPoints(
          _initialViewPortPoints
              .map(
                (e) => GeoPointMessage(
                  latitude: e.center.latitude,
                  longitude: e.center.longitude,
                ),
              )
              .toList(),
          options: CalcPositionOptionsMessage(screenArea: _cameraPadding),
        );
  }

  CameraSetPaddingMessage? get _cameraPadding {
    final mediaQuery = ref.read(mediaQueryInfoProvider);
    if (mediaQuery == null) {
      return null;
    }

    const logicalPixelPadding = 20;
    final devicePixelRatio = mediaQuery.devicePixelRatio;
    final physicalPixelsPadding = (logicalPixelPadding * devicePixelRatio).round();
    final physicalPixelsHeight = mediaQuery.size.height * devicePixelRatio;

    return CameraSetPaddingMessage(
      leftPadding: physicalPixelsPadding,
      topPadding: physicalPixelsPadding,
      rightPadding: physicalPixelsPadding,
      // as the bottom sheet takes about one third of screen we add more padding
      bottomPadding: (physicalPixelsHeight / 2).round(),
    );
  }

  String getPinPath(int objectId) =>
      _getPointById(objectId)?.type.pinPath ?? Assets.icons.svg.icWrcPinRallyStage.keyName;

  String getMapMarkerPath(int objectId) =>
      _getPointById(objectId)?.type.mapMarkerPath ?? Assets.icons.svg.icWrcMapMarkerRallyStage.keyName;

  String getSearchMarkerPath(int objectId) =>
      _getPointById(objectId)?.type.searchMarkerImagePath ?? Assets.icons.svg.icWrcSearchMarkerRallyStage.keyName;

  WRCEventPoint? _getPointById(int objectId) => wrcEventPoints.firstWhereOrNull(
    (e) => e.objectId == objectId,
  );

  WRCEventPoint? _getPointByMarker(sdk.Marker marker) => wrcEventPoints.firstWhereOrNull(
    (e) => e.center.isNearPoint(marker.options.position.toGeoPointMessage()),
  );

  sdk.GeoPointWithElevationMessage _getMarkerPosition(WRCEventPoint point) => sdk.GeoPointWithElevationMessage(
    latitude: point.center.latitude,
    longitude: point.center.longitude,
    elevation: 0,
  );

  sdk.MarkerIconMessage _getIcon(WRCEventPoint point) =>
      sdk.MarkerIconMessage(svgPath: point.type.mapMarkerPath, width: 20);

  sdk.MarkerAnchorMessage get _markerAnchor => sdk.MarkerAnchorMessage(x: 0.5, y: 0.5);

  sdk.MarkerTextStyleMessage get _markerAnchorTextStyle {
    final isArabic = ref.read(appLanguageProvider) == Language.arabic;
    final fontName = isArabic ? MapnessConstants.poiMapFontAr : MapnessConstants.poiMapFontEn;

    return sdk.MarkerTextStyleMessage(
      fontSize: 10,
      color: 0xFF2AB3A9,
      strokeWidth: 1,
      strokeColor: 0xFFFFFFFF,
      fontName: fontName,
      suppressOnOverlap: true,
    );
  }

  int get _zIndex => 50;

  String _getTitle(WRCEventPoint point) {
    final l10n = lookupAppLocalizations(ref.read(appLanguageProvider).locale);
    return point.titleBuilder(l10n);
  }
}
