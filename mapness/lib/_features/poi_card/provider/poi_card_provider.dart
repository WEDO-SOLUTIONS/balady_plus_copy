import 'package:dgis_map/library.dart';
import 'package:dio/dio.dart';
import 'package:mapness/_features/poi_card/data/poi_data_service.dart';
import 'package:mapness/_features/poi_card/data/qr_license_repository.dart';
import 'package:mapness/_features/poi_card/domain/model/organizations_response.dart';
import 'package:mapness/_features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/_features/poi_card/domain/model/poi_padding_config.dart';
import 'package:mapness/_features/poi_card/domain/model/qr_trade_license.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/map/point_of_interest.dart';
import 'package:mapness/shared/providers/vendor_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/providers/dgis_http_network.dart';

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
  PoiCardState? poiCardState;

  @override
  Future<PoiCardState?> build(
    DgisObjectIdMessage objectId, {
    PoiCameraConfig? cameraConfig,
    LatLng? closestPoint,
    PoiPaddingConfig? paddingConfig,
  }) async {
    if (poiCardState != null && poiCardState?.gisObjectIdMessage?.id == objectId) {
      return poiCardState;
    }

    final qrLicenseRepository = ref.watch(qrLicenseRepositoryProvider.notifier);

    final result = await ref
        .watch(
      pointOfInterestProvider(
        objectId,
        cameraConfig: cameraConfig,
        closestPoint: closestPoint,
        paddingConfig: paddingConfig,
      ).future,
    )
        .timeout(
      const Duration(minutes: 1),
      onTimeout: () {
        ref.read(goRouterProvider).pop();
        return null;
      },
    );

    final organizationsResponse = await fetchOrganizationsData(
      objectId: result?.id?.objectId,
    );

    final tradeLicense = result?.tradeLicense;

    QrLicenseMessage? qrLicense;
    if (tradeLicense != null) {
      final license = tradeLicense.license;
      if (license.isNotEmpty) {
        qrLicense = await qrLicenseRepository.getLicenseInfo(license);
      }
    }

    return poiCardState = PoiCardState(
      organizations: organizationsResponse,
      isLoading: true,
      showEntrances: false,
      gisObjectIdMessage: result,
      tradeLicense: tradeLicense,
      qrTradeLicense: qrLicense,
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
