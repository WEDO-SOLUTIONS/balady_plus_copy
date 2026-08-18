import 'dart:async';

import 'package:dgis_map/library.dart' as sdk;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/app/auto_route/poi_card_ext.dart';
import 'package:mapness/features/founding_day/founding_day_debug.dart';
import 'package:mapness/features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/map/point_of_interest.dart';
import 'package:mapness/shared/providers/padding_config.dart';
import 'package:mapness/widgets/landing/dashboard/city_event_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'founding_day.g.dart';

const _currentDateCheckInterval = Duration(minutes: 15);

/// Provider that checks if the current time is between two specified dates
///
/// Returns `true` if the current time is between the start and end dates,
/// `false` otherwise.
@riverpod
class FoundingDayUrbi extends _$FoundingDayUrbi {
  // we need to check if current date comes in or goes out of event date range as the time goes by
  late Timer _timer;

  MapObjectManager? mapManager;

  bool get _isDark => ref.read(darkModeProvider).value?.isDark ?? false;

  String get customMarker =>
      _isDark ? Assets.icons.svg.historicDiriyahFortDark.keyName : const FoundingDayConfig().customMarkerPath;

  String get globalImg => Assets.images.foundingDayCircleLogo.keyName;

  @override
  bool build() {
    mapManager = ref.watch(
      mapObjectManagerProvider(
        named: MapObjectManagerSettings.cityEvent().name,
        layerId: MapObjectManagerSettings.cityEvent().layerId,
      ).notifier,
    );

    // start timer to rebuild this state over time
    _timer = Timer(_currentDateCheckInterval, ref.invalidateSelf);
    ref.onDispose(_timer.cancel);

    // Check if debug override is enabled
    final debugOverride = ref.watch(foundingDayDebugUrbiProvider);
    if (debugOverride) {
      return true;
    }

    final eventDateRange = ref.watch(dgisEnvironmentProvider.select((value) => value.value?.foundingDayDateRange));
    if (eventDateRange != null) {
      return eventDateRange.isNow;
    }

    return false;
  }

  Future<void> initializeGlobalMarker() async {
    mapManager = ref.read(
      mapObjectManagerProvider(
        named: MapObjectManagerSettings.cityEvent().name,
        layerId: MapObjectManagerSettings.cityEvent().layerId,
      ).notifier,
    );
    await mapManager?.removeMarkerById(const FoundingDayConfig().globalMarkerId);

    final globalMarker = sdk.Marker(
      id: const FoundingDayConfig().globalMarkerId,
      options: sdk.MarkerOptionsMessage(
        position: const FoundingDayConfig().center,
        icon: sdk.MarkerIconMessage(svgPath: const FoundingDayConfig().defaultMarkerPath, width: 20),
        anchor: sdk.MarkerAnchorMessage(x: 0, y: 0),
        text: _getTitle(),
        textStyle: _markerAnchorTextStyle,
        isVisible: false,
        zIndex: 50,
      ),
      onTap: openThePlace,
    );

    await mapManager?.addMarker(globalMarker);
  }

  Future<void> showGlobalMarker() async {
    final cameraPosition = ref.read(cameraPositionProvider);
    final zoom = cameraPosition?.zoom ?? 0.0;

    if (zoom < 12) {
      await hideGlobalMarker();
      return;
    }

    await mapManager?.setMarkerOptions(
      const FoundingDayConfig().globalMarkerId,
      sdk.ChangeMarkerOptionsMessage(
        position: const FoundingDayConfig().center,
        icon: sdk.MarkerIconMessage(svgPath: const FoundingDayConfig().defaultMarkerPath, width: 20),
        anchor: sdk.MarkerAnchorMessage(x: 0, y: 0),
        text: _getTitle(),
        textStyle: _markerAnchorTextStyle,
        animatedAppearance: true,
        isVisible: true,
        zIndex: 50,
      ),
    );
  }

  Future<void> hideGlobalMarker() async {
    await mapManager?.setMarkerOptions(
      const FoundingDayConfig().globalMarkerId,
      sdk.ChangeMarkerOptionsMessage(isVisible: false),
    );
  }

  bool isFoundationObject(int objectId) => const FoundingDayConfig().additionalObjectIds.contains(objectId) && state;

  Future<void> openThePlace() async {
    final objectId = sdk.DgisObjectIdMessage(objectId: const FoundingDayConfig().objectId, entranceId: 0);
    final closestPoint = sdk.LatLng(
      latitude: const FoundingDayConfig().center.latitude,
      longitude: const FoundingDayConfig().center.longitude,
    );
    const cameraConfig = PoiCameraConfig(zoom: 20, tilt: 90);
    ref.read(
      paddingConfigProvider(
        const FoundingDayConfig().center,
        closestPoint,
        cameraConfig,
      ),
    );
    await ref
        .read(appRouterProvider)
        .replaceOrPush(
          route: PoiCardWidgetRoute(
            objectId: objectId,
            closestPoint: sdk.LatLng(
              latitude: const FoundingDayConfig().center.latitude,
              longitude: const FoundingDayConfig().center.longitude,
            ),
            cameraConfig: cameraConfig,
          ),
          toCompareRoutes: [PoiCardWidgetRoute.page],
        );
  }

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

  String _getTitle() {
    final l10n = lookupAppLocalizations(ref.read(appLanguageProvider).locale);
    return l10n.foundingDayHistoricDiriyahFort;
  }

  String getAboutByDgisId(int dgisObjectId) {
    final l10n = lookupAppLocalizations(ref.read(appLanguageProvider).locale);

    final Map<int, String> aboutMap = {
      // Diriyah - Cultural Institution
      70030076209990811: l10n.foundingDayDiriyahFortAbout,
      // Historical Diriyah (Al-Turaif)
      70030076567999453: l10n.foundingDayDiriyahAbout,

      // The National Museum
      70000001097009979: l10n.foundingDayTheNationalMuseumAbout,

      // Wadi Hanifah
      70000001102279512: l10n.foundingDayWadiHanifahAbout,

      // Al Hamdan Heritage
      70000001094445934: l10n.foundingDayAlHamdanHeritageAbout,

      // Al Masmak Palace
      70030076256595855: l10n.foundingDayAlMasmakPalaceAbout,

      // Diriyah Historical Fort
      70030076209992609: l10n.foundingDayDiriyahFortAbout,
    };

    return aboutMap[dgisObjectId] ?? '';
  }

  bool shouldForceShow(int dgisObjectId) => _forceShowIds.contains(dgisObjectId);

  String getPhotoByDgisId(int dgisObjectId) {
    final Map<int, String> map = {
      // Diriyah - Cultural Institution
      70030076209992609: Assets.images.foundingDayDiriyahCulturalInstitution.keyName,

      // The National Museum
      70000001097009979: Assets.images.foundingDayNationalMuseum.keyName,

      // Al Hamdan Heritage
      70000001094445934: Assets.images.foundingDayAlHamdanHeritage.keyName,

      // Dir'yiyah
      70030076567999453: Assets.images.foundingDayHistoricalDirYiyah.keyName,
    };

    return map[dgisObjectId] ?? '';
  }
}

const _forceShowIds = {70030076209992609};
