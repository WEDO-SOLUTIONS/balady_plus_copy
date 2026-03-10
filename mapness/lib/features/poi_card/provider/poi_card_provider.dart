import 'dart:async';
import 'dart:convert';

import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:dgis_map/library.dart';
import 'package:dio/dio.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:mapness/features/poi_card/data/poi_data_service.dart';
import 'package:mapness/features/poi_card/data/qr_license_repository.dart';
import 'package:mapness/features/poi_card/domain/model/organizations_response.dart';
import 'package:mapness/features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/features/poi_card/domain/model/qr_trade_license.dart';
import 'package:mapness/features/poi_card/provider/poi_photo_provider.dart';
import 'package:mapness/features/saudi_pass/providers/poi_offers_provider.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/extensions/directory_object_message_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dgis_http_network.dart';
import 'package:mapness/shared/providers/hive.dart';
import 'package:mapness/shared/providers/map/point_of_interest.dart';
import 'package:mapness/shared/providers/padding_config.dart';
import 'package:mapness/shared/providers/regular_poi_active.dart';
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
  }) async {
    state = const AsyncValue.loading();

    ref.onDispose(() {
      // Show Makkah place markers again when POI card is closed
      ref.read(regularPoiActiveProvider.notifier).setActive(false);
    });

    final result = await ref
        .watch(pointOfInterestProvider(DgisObjectId(objectId: objectId, entranceId: 0), closestPoint, theme).future)
        .timeout(const Duration(minutes: 10));

    await ref.watch(poiPhotoProvider(objectId).future);

    if (result != null) {
      ref.read(
        paddingConfigProvider(
          result.markerPosition,
          closestPoint,
          cameraConfig,
        ),
      );
    }
    // We need to use [appLang] to cache different data for different locales
    // We don't want to show arabic text to english users and vise versa
    final appLang = ref.read(appLanguageProvider);
    final poiCardStateKey = '${objectId.toString()} $appLang';

    final poiBox = await ref.read(hiveProvider(MapnessConstants.poiDataBoxName).future);
    final cachedData = await loadCacheData(poiBox, poiCardStateKey);

    if (cachedData != null) {
      await _loadOffers(cachedData.gisObjectIdMessage, cachedData.organizations);
      return cachedData;
    } else {
      final qrLicenseRepository = ref.watch(qrLicenseRepositoryProvider.notifier);
      final organizationsResponse = await fetchOrganizationsData(objectId: result?.id?.objectId);

      final tradeLicense = result?.tradeLicense;

      QrLicenseMessage? qrLicense;
      if (tradeLicense != null) {
        final license = tradeLicense.license;
        if (license.isNotEmpty) {
          qrLicense = await qrLicenseRepository.getLicenseInfo(license);
        }
      }

      await _loadOffers(result, organizationsResponse);

      final poiCardState = PoiCardState(
        organizations: organizationsResponse,
        isLoading: false,
        showEntrances: false,
        gisObjectIdMessage: result,
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

  Future<void> _loadOffers(DirectoryObjectMessage? poi, OrganizationsMessage? organizations) async {
    final tradeLicense = poi?.tradeLicense;
    final organizationsLicenses = organizations?.items.map((e) => e.tradeLicense?.license).nonNulls;
    final allLicenses = {
      if (tradeLicense != null) tradeLicense.license,
      if (organizationsLicenses != null) ...organizationsLicenses,
    };
    await ref.read(poiOffersProvider.notifier).fetchOffers(allLicenses);
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
