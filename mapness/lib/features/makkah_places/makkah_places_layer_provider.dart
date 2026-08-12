import 'package:dgis_map/library.dart';
import 'package:flutter/foundation.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/app/auto_route/poi_card_ext.dart';
import 'package:mapness/entities/makkah_places/makkah_place_model.dart';
import 'package:mapness/features/lifestyle_layers/configs/layers_consts.dart';
import 'package:mapness/features/makkah_places/makkah_places_json_datasource.dart';
import 'package:mapness/features/makkah_places/makkah_places_repository.dart';
import 'package:mapness/features/map_tap_handler/map_tap_handler_provider.dart';
import 'package:mapness/features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/features/special_themes/core/special_theme_mode.dart';
import 'package:mapness/features/special_themes/modes/mekkah_base/makkah_poi_constants.dart';
import 'package:mapness/shared/extensions/change_marker_options_ext.dart';
import 'package:mapness/shared/extensions/string_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/map/point_of_interest.dart';

import 'package:mapness/shared/providers/regular_poi_active.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'makkah_places_layer_provider.g.dart';

@Riverpod(keepAlive: true)
class MakkahPlacesLayer extends _$MakkahPlacesLayer {
  late final MapObjectManagerSettings _settings = MapObjectManagerSettings.makkahPlaces();

  bool _wasMakkahMode = false;
  bool _didFlyToPlaces = false;

  @override
  Future<void> build() async {
    // Watch regularPoiActiveProvider FIRST to ensure rebuild triggers when it changes
    final isRegularPoiActive = ref.watch(regularPoiActiveProvider);

    final specialMode = ref.watch(specialThemeModeProvider);
    final isMakkahMode = switch (specialMode) {
      SpecialThemeMode.mekkahBase => true,
      SpecialThemeMode.ramadan => true,
      _ => false,
    };

    if (!_wasMakkahMode && isMakkahMode) {
      _didFlyToPlaces = false;
    }
    _wasMakkahMode = isMakkahMode;

    final manager = ref.watch(
      mapObjectManagerProvider(
        named: _settings.name,
        layerId: _settings.layerId,
      ).notifier,
    );

    // Hide markers when not in Makkah mode
    if (!isMakkahMode) {
      await manager.removeAllMarkers();
      return;
    }

    // Hide markers when a regular (non-Makkah) POI card is open to avoid overlap
    if (isRegularPoiActive) {
      // ignore: avoid_print
      print('[MakkahPinDebug] Layer: Hiding markers - regular POI is active');
      await manager.removeAllMarkers();
      return;
    } else {
      // ignore: avoid_print
      print('[MakkahPinDebug] Layer: Showing markers - regular POI is NOT active');
    }

    final places = await ref.watch(makkahPlacesRepositoryProvider.future);
    final dark = await ref.watch(darkModeProvider.future);
    final isRtl = ref.watch(appLanguageProvider) == Language.arabic;

    final markers = <Marker>[];
    final points = <GeoPointMessage>[];

    for (final place in places) {
      final lat = place.lat;
      final lon = place.lon;
      if (lat == null || lon == null) {
        continue;
      }

      final icon = _resolveIconForPlace(place, specialMode);

      final objectId = int.tryParse(place.dgisId ?? '');

      final markerId = (place.placeId != null && place.placeId!.isNotEmpty) ? place.placeId! : '${lat}_$lon';

      final position = GeoPointWithElevationMessage(
        latitude: lat,
        longitude: lon,
        elevation: 0,
      );
      final closestPoint = LatLng(latitude: lat, longitude: lon);

      final rawTitle = isRtl ? (place.titleAr ?? '') : (place.titleEn ?? '');
      final title = rawTitle.breakMarkerLabel(maxCharsPerLine: 20);
      final textStyle = MarkerTextStyleMessage(
        fontSize: 13,
        textOffset: 4,
        color: dark.isDark ? 0xD3FFFFFF : 0xff1B1B1B,
        strokeColor: dark.isDark ? 0xff1B1B1B : 0xD3FFFFFF,
        strokeWidth: 1,
        fontName: title.containsArabic() || isRtl ? poiMapFontAr : poiMapFontEn,
        textPlacement: MarkerTextPlacementMessage(
          placement: TextPlacementMessage.bottomCenter,
        ),
      );

      points.add(GeoPointMessage(latitude: lat, longitude: lon));

      markers.add(
        Marker(
          id: markerId,
          onTap: () async {
            ref.read(mapTapHandlerProvider.notifier).notifyMakkahMarkerTapped();

            // Zoom to marker location with street-level detail (zoom 18)
            final camera = ref.read(cameraPositionProvider.notifier);
            await camera.animateTo(
              CameraPositionMessage(
                point: GeoPointMessage(latitude: lat, longitude: lon),
                zoom: 20.0, // Street-level zoom for detailed view
                bearing: 0.0, // North-facing
                tilt: 0.0, // Top-down view
              ),
            );

            // Navigate to POI detail page
            final router = ref.read(appRouterProvider);
            await router.replaceOrPush(
              route: PoiMakkahWidgetRoute(
                objectId: objectId != null ? DgisObjectIdMessage(objectId: objectId, entranceId: 0) : null,
                closestPoint: closestPoint,
                cameraConfig: const PoiCameraConfig(zoom: 20), // Match zoom level
                makkahPlace: place,
              ),
              toCompareRoutes: [PoiMakkahWidgetRoute.page],
            );
          },
          options: MarkerOptionsMessage(
            position: position,
            icon: icon,
            isVisible: true,
            text: title,
            textStyle: textStyle.copyWith(suppressOnOverlap: false),
            anchor: MarkerAnchorMessage(x: 0.5, y: 0.5),
            animatedAppearance: true,
            zIndex: 50, // Elevated above other markers
          ),
        ),
      );
    }

    await manager.removeAllMarkers();
    if (markers.isNotEmpty) {
      await manager.addMarkers(markers);

      // Fly to all places only once when entering Makkah mode
      if (!_didFlyToPlaces && points.isNotEmpty) {
        _didFlyToPlaces = true;
        await _animateToAllPlaces(points);
      }
    }
  }

  /// Animates camera to show all Makkah places on the map.
  ///
  /// Called automatically when entering Makkah mode, and can be triggered
  /// manually by tapping the theme icon in the dashboard header.
  Future<void> flyToAllPlaces() async {
    final places = await ref.read(makkahPlacesRepositoryProvider.future);
    final points = <GeoPointMessage>[];

    for (final place in places) {
      final lat = place.lat;
      final lon = place.lon;
      if (lat == null || lon == null) continue;
      points.add(GeoPointMessage(latitude: lat, longitude: lon));
    }

    if (points.isNotEmpty) {
      await _animateToAllPlaces(points);
    }
  }

  Future<void> _animateToAllPlaces(List<GeoPointMessage> points) async {
    final camera = ref.read(cameraPositionProvider.notifier);
    await camera.animateToGeoPoints(
      points,
      options: CalcPositionOptionsMessage(
        // Screen padding to ensure markers are visible and not hidden by UI elements
        screenArea: CameraSetPaddingMessage(
          leftPadding: 60, // Sidebar/controls padding
          topPadding: 120, // Header/status bar padding
          rightPadding: 60, // Right controls padding
          bottomPadding: 220, // Bottom sheet/navigation padding
        ),
      ),
    );
  }

  MarkerIconMessage _resolveIconForPlace(
    MakkahPlace place,
    SpecialThemeMode mode,
  ) {
    // Lookup key: prefer place_id; fall back to dgis_id when place_id is empty
    // (e.g. Al Masjid Al Haram has empty place_id and only a dgis_id).
    final placeId = place.placeId;
    final dgisId = place.dgisId;
    final lookupKey = (placeId != null && placeId.isNotEmpty)
        ? placeId
        : (dgisId != null && dgisId.isNotEmpty ? dgisId : null);

    if (lookupKey != null) {
      final iconsDir = MakkahPoiConstants.getMarkerIconsDirectory(
        isRamadan: mode == SpecialThemeMode.ramadan,
      );
      // Pick extension from marker_image_url so .png entries
      // (e.g. Al Masjid Al Haram) resolve to the bundled .png.
      final markerUrl = place.markerImageUrl?.toLowerCase() ?? '';
      final isPng = markerUrl.endsWith('.png');
      final ext = isPng ? 'png' : 'svg';
      final localPath = '$iconsDir/$lookupKey.$ext';
      debugPrint(
        '[MakkahPinDebug] resolveIcon pid=$placeId dgis=$dgisId '
        'key=$lookupKey ext=$ext path=$localPath',
      );
      return isPng
          ? PngMarkerIcon(
              pngPath: localPath,
              width: MakkahPoiConstants.markerIconWidth,
            )
          : SvgMarkerIcon(
              svgPath: localPath,
              width: MakkahPoiConstants.markerIconWidth,
            );
    }

    // Fallback only when neither place_id nor dgis_id is present.
    debugPrint(
      '[MakkahPinDebug] resolveIcon FALLBACK pid=$placeId dgis=$dgisId '
      'title=${place.titleEn}',
    );
    return 'assets/images/themes/makkah/makkah_places.png'.resolvedMarkerIcon(
      size: MakkahPoiConstants.markerIconWidth,
    );
  }
}
