import 'dart:async';
import 'dart:convert';

import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:dgis_map/library.dart';
import 'package:dio/dio.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:mapness/features/poi_card/data/poi_data_service.dart';
import 'package:mapness/features/poi_card/data/qr_license_repository.dart';
import 'package:mapness/features/poi_card/domain/dto/dgis_photos_dto.dart';
import 'package:mapness/features/poi_card/domain/model/organizations_response.dart';
import 'package:mapness/features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/features/poi_card/domain/model/qr_trade_license.dart';
import 'package:mapness/features/poi_card/provider/poi_photo_provider.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/extensions/directory_object_message_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dgis_http_network.dart';
import 'package:mapness/shared/providers/hive.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/point_of_interest.dart';
import 'package:mapness/shared/providers/padding_config.dart';
import 'package:mapness/shared/providers/vendor_config.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'poi_card_provider.g.dart';

class PoiCardState {
  final bool isLoading;
  final bool showEntrances;
  final DirectoryObjectMessage? gisObjectIdMessage;
  final TradeLicenseMessage? tradeLicense;
  final QrLicenseMessage? qrTradeLicense;
  final OrganizationsMessage? organizations;
  final int? timestamp;

  const PoiCardState({
    required this.showEntrances,
    required this.isLoading,
    required this.gisObjectIdMessage,
    required this.organizations,
    this.qrTradeLicense,
    this.tradeLicense,
    this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'gisObjectIdMessage': gisObjectIdMessage?.toJson(),
    'organizations': organizations?.toJson(),
    'tradeLicense': tradeLicense?.toJson(),
    'showEntrances': showEntrances,
    'isLoading': isLoading,
    'timestamp': DateTime.now().millisecondsSinceEpoch,
  };

  factory PoiCardState.fromJson(Map<String, dynamic> json) {
    final organizatonsJson = json['organizations'];
    final objectIdJson = json['gisObjectIdMessage'];
    final entrancesJson = json['showEntrances'];
    final timestampJson = json.containsKey('timestamp') ? json['timestamp'] as int? : null;

    return PoiCardState(
      showEntrances: entrancesJson,
      isLoading: false,
      timestamp: timestampJson,
      gisObjectIdMessage: DirectoryObjectMessageExt.fromJson(objectIdJson),
      organizations: OrganizationsMessage.fromJson(organizatonsJson),
    );
  }

  PoiCardState copyWith({
    bool? showEntrances,
    bool? isLoading,
    DirectoryObjectMessage? gisObjectIdMessage,
    TradeLicenseMessage? tradeLicense,
    QrLicenseMessage? qrTradeLicense,
    OrganizationsMessage? organizations,
  }) => PoiCardState(
    organizations: organizations ?? this.organizations,
    tradeLicense: tradeLicense ?? this.tradeLicense,
    showEntrances: showEntrances ?? this.showEntrances,
    isLoading: isLoading ?? this.isLoading,
    gisObjectIdMessage: gisObjectIdMessage ?? this.gisObjectIdMessage,
    qrTradeLicense: qrTradeLicense,
  );
}

@riverpod
class PoiCardProvider extends _$PoiCardProvider {
  // POI Cache timeout in minutes
  static const poiCacheTimeoutMinutes = 60;

  @override
  Future<PoiCardState?> build(
    int objectId,
    BaladyAppThemes theme, {
    PoiCameraConfig? cameraConfig,
    LatLng? closestPoint,
    bool showHighlight = true,
  }) async {
    state = const AsyncValue.loading();
    // We need to use [appLang] to cache different data for different locales
    // We don't want to show arabic text to english users and vise versa
    final appLang = ref.read(appLanguageProvider);
    final poiCardStateKey = '${objectId.toString()} $appLang';

    final poiBox = await ref.read(hiveProvider(MapnessConstants.poiDataBoxName).future);
    final cachedData = await loadCacheData(poiBox, poiCardStateKey);
    if (cachedData != null) {
      ref
          .read(
            pointOfInterestProvider(
              DgisObjectId(objectId: objectId, entranceId: 0),
              closestPoint,
              theme,
              showHighlight: showHighlight,
            ).future,
          )
          .then((poi) {
            if (poi != null) {
              _animateCameraToPoi(poi.markerPosition, closestPoint, cameraConfig);
            }
          });

      return cachedData;
    } else {
      final poiFuture = ref
          .watch(
            pointOfInterestProvider(
              DgisObjectId(objectId: objectId, entranceId: 0),
              closestPoint,
              theme,
              showHighlight: showHighlight,
            ).future,
          )
          .timeout(const Duration(minutes: 10));

      final photosFuture =
          Future.value(DgisPhotosDto(albums: [], items: [])) ?? ref.watch(poiPhotoProvider(objectId).future);
      final organisationsFuture = fetchOrganizationsData(objectId: objectId);

      final results = await Future.wait([poiFuture, photosFuture, organisationsFuture]);
      final poi = results[0] as DirectoryObjectMessage?;
      final photos = results[1]! as DgisPhotosDto;
      final organizations = results[2] as OrganizationsMessage?;

      if (poi != null) {
        _animateCameraToPoi(poi.markerPosition, closestPoint, cameraConfig);
      }

      final tradeLicense = poi?.tradeLicense;

      QrLicenseMessage? qrLicense;
      if (tradeLicense != null) {
        final license = tradeLicense.license;
        if (license.isNotEmpty) {
          final qrLicenseRepository = ref.watch(qrLicenseRepositoryProvider.notifier);
          qrLicense = await qrLicenseRepository.getLicenseInfo(license);
        }
      }

      unawaited(_loadOffers(poi, organizations));

      final poiCardState = PoiCardState(
        organizations: organizations,
        isLoading: false,
        showEntrances: false,
        gisObjectIdMessage: poi,
        tradeLicense: tradeLicense,
        qrTradeLicense: qrLicense,
      );

      try {
        final json = jsonEncode(poiCardState.toJson());
        await poiBox.put(poiCardStateKey, json);
      } catch (e, s) {
        logger.log('Error saving poi card state to cache: $e', logLevel: MapnessLogLevel.critical);
        state = AsyncValue.error(e, s);
      }
      return poiCardState;
    }
  }

  Future<OrganizationsMessage?> fetchOrganizationsData({int? objectId, int page = 1, int pageSize = 30}) async {
    final dio = await ref.watch(dGisHttpService.future);
    final vendorConfig = await ref.read(vendorConfigProvider.future);
    final appLang = ref.read(appLanguageProvider);
    final key = vendorConfig['dgis/native-sdk/keys/user_web_api_key_for_on_premise'];
    final url = vendorConfig['dgis/native-sdk/directory/webapi_url'];

    try {
      final response = await PoiDataService(dio)
          .inBuildingOrganizations(
            url: url,
            key: key,
            objectId: objectId,
            pageSize: pageSize,
            page: page,
            languageCode: appLang.languageCode,
            cancelToken: CancelToken(),
          )
          .onError((error, stackTrace) => null);

      return response;
    } catch (_) {
      logger.log('Error fetching organizations data', logLevel: MapnessLogLevel.critical);
      return null;
    }
  }

  /// Directly animate camera to the POI location.
  /// We call cameraPositionProvider (which is keepAlive) directly instead of going
  /// through paddingConfigProvider (which is auto-dispose and can be disposed
  /// before its async camera animation completes on first navigation).
  void _animateCameraToPoi(
    GeoPointWithElevationMessage? markerPosition,
    LatLng? closestPoint,
    PoiCameraConfig? cameraConfig,
  ) {
    final position =
        closestPoint ??
        (markerPosition == null
            ? null
            : LatLng(latitude: markerPosition.latitude, longitude: markerPosition.longitude));

    if (position == null) {
      return;
    }

    final markerPoint = GeoPointMessage(latitude: position.latitude, longitude: position.longitude);
    final currentZoom = ref.read(cameraPositionProvider)?.zoom;
    final zoom = cameraConfig?.zoom ?? currentZoom ?? 16.0;

    unawaited(
      ref
          .read(cameraPositionProvider.notifier)
          .animateTo(
            CameraPositionMessage(
              point: markerPoint,
              zoom: zoom,
              tilt: cameraConfig?.tilt ?? 0,
              bearing: cameraConfig?.bearing ?? 0,
            ),
          ),
    );
  }

  Future<void> _loadOffers(DirectoryObjectMessage? poi, OrganizationsMessage? organizations) async {
    final tradeLicense = poi?.tradeLicense;
    final organizationsLicenses = organizations?.items.map((e) => e.tradeLicense?.license).nonNulls;
    final allLicenses = {
      if (tradeLicense != null) tradeLicense.license,
      if (organizationsLicenses != null) ...organizationsLicenses,
    };
    // await ref.read(poiOffersProvider.notifier).fetchOffers(allLicenses);
  }

  Future<PoiCardState?> loadCacheData(Box<dynamic> box, String key) async {
    final cachedData = box.get(key, defaultValue: null);

    if (cachedData == null) {
      return null;
    }

    try {
      final stateFromJson = PoiCardState.fromJson(jsonDecode(cachedData));
      if (stateFromJson.timestamp == null) {
        return null;
      }

      final dateNow = DateTime.now();
      final timeDifferentInMinutes = dateNow
          .difference(DateTime.fromMillisecondsSinceEpoch(stateFromJson.timestamp!))
          .inMinutes;

      // Check if the cache is expired
      if (timeDifferentInMinutes > poiCacheTimeoutMinutes) {
        return null;
      }
      return stateFromJson;
    } catch (e, _) {
      logger.log('Cached data error: $e', logLevel: MapnessLogLevel.critical);
      return null;
    }
  }
}
