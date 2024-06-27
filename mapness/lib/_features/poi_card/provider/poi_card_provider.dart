import 'dart:convert';

import 'package:dgis_map/library.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/_features/poi_card/data/poi_data_service.dart';
import 'package:mapness/_features/poi_card/data/qr_license_repository.dart';
import 'package:mapness/_features/poi_card/domain/model/organizations_response.dart';
import 'package:mapness/_features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/_features/poi_card/domain/model/qr_trade_license.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/extensions/directory_object_message_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dgis_http_network.dart';
import 'package:mapness/shared/providers/hive.dart';
import 'package:mapness/shared/providers/map/point_of_interest.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:mapness/shared/providers/padding_config.dart';
import 'package:mapness/shared/providers/vendor_config.dart';
import 'package:mapness/shared/ui/markers/markers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'poi_card_provider.g.dart';

class PoiCardState {
  final bool isLoading;
  final bool showEntrances;
  final DirectoryObjectMessage? gisObjectIdMessage;
  final TradeLicenseMessage? tradeLicense;
  final QrLicenseMessage? qrTradeLicense;
  final OrganizationsMessage? organizations;

  const PoiCardState({
    required this.showEntrances,
    required this.isLoading,
    required this.gisObjectIdMessage,
    required this.organizations,
    this.qrTradeLicense,
    this.tradeLicense,
  });

  Map<String, dynamic> toJson() => {
        'gisObjectIdMessage': gisObjectIdMessage?.toJson(),
        'organizations': organizations?.toJson(),
        'tradeLicense': tradeLicense?.toJson(),
        'qrTradeLicense': qrTradeLicense?.toJson(),
        'showEntrances': showEntrances,
        'isLoading': isLoading,
      };

  static Future<PoiCardState> fromJson(Map<String, dynamic> json) async {
    final organizatonsJson = json['organizations'];
    final objectIdJson = json['gisObjectIdMessage'];
    final entrancesJson = json['showEntrances'];
    return PoiCardState(
      showEntrances: entrancesJson,
      isLoading: false,
      gisObjectIdMessage: DirectoryObjectMessageExt.fromJson(objectIdJson),
      organizations: OrganizationsMessage.fromJson(organizatonsJson));
  }

  PoiCardState copyWith({
    bool? showEntrances,
    bool? isLoading,
    DirectoryObjectMessage? gisObjectIdMessage,
    TradeLicenseMessage? tradeLicense,
    QrLicenseMessage? qrTradeLicense,
    OrganizationsMessage? organizations,
  }) =>
      PoiCardState(
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
  @override
  Future<PoiCardState?> build(
    int objectId, {
    PoiCameraConfig? cameraConfig,
    LatLng? closestPoint,
  }) async {
    // TODO Refactoring all of this logic with new poi is required
    if (closestPoint != null) {
      final read = ref.read(selectedMarkerProvider.notifier);
      await read.showMarker(
        Markers.pinMarker(
          GeoPointWithElevationMessage(
            latitude: closestPoint.latitude,
            longitude: closestPoint.longitude,
            elevation: 1,
          ),
          id: poiPinId,
        ),
      );
    }

    state = const AsyncValue.loading();

    final result = await ref
        .watch(
      pointOfInterestProvider(
        DgisObjectIdMessage(objectId: objectId, entranceId: 0),
        closestPoint: closestPoint,
      ).future,
    )
        .timeout(
      const Duration(minutes: 1),
      onTimeout: () {
        ref.read(goRouterProvider).pop();
        return null;
      },
    );

    if (result != null) {
      ref.read(paddingConfigProvider(
        result,
        closestPoint,
        cameraConfig,
      ));
    }

    final poiCardStateKey = objectId.toString();
    final poiBox = await ref.read(hiveProvider(MapnessConstants.poiDataBoxName).future);
    final cachedData = poiBox.get(poiCardStateKey, defaultValue: null);

    if (cachedData != null) {
      try {
        final stateFromJson = PoiCardState.fromJson(jsonDecode(cachedData));
        return stateFromJson;
      } catch (e, s) {
        state = AsyncValue.error(e, s);
      }
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
      }
      // ignore: avoid_catches_without_on_clauses
      catch (e, s) {
        debugPrint('$e');
        state = AsyncValue.error(e, s);
      }
      return poiCardState;
    }

    return const PoiCardState(
      organizations: null,
      isLoading: true,
      showEntrances: false,
      gisObjectIdMessage: null,
    );
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
      // ignore: avoid_catches_without_on_clauses
    } catch (_) {
      return null;
    }
  }
}
