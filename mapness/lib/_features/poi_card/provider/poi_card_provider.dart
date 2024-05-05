import 'package:dgis_map/library.dart';
import 'package:mapness/_features/poi_card/data/qr_license_repository.dart';
import 'package:mapness/_features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/_features/poi_card/domain/model/qr_trade_license.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/shared/providers/map/point_of_interest.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'poi_card_provider.g.dart';

class PoiCardState {
  const PoiCardState({
    required this.showEntrances,
    required this.gisObjectIdMessage,
    this.qrTradeLicense,
    this.tradeLicense,
  });

  final bool showEntrances;
  final DirectoryObjectMessage? gisObjectIdMessage;
  final TradeLicenseMessage? tradeLicense;
  final QrLicenseMessage? qrTradeLicense;
}

@riverpod
class PoiCardProvider extends _$PoiCardProvider {
  PoiCardState? poiCardState;

  @override
  Future<PoiCardState?> build(
    DgisObjectIdMessage objectId, {
    PoiCameraConfig? cameraConfig,
    LatLng? closestPoint,
  }) async {
    if (poiCardState != null &&
        poiCardState?.gisObjectIdMessage?.id == objectId) {
      return poiCardState;
    }

    final qrLicenseRepository = ref.watch(qrLicenseRepositoryProvider.notifier);

    final result = await ref
        .watch(
      pointOfInterestProvider(
        objectId,
        cameraConfig: cameraConfig,
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

    final tradeLicense = result?.tradeLicense;

    QrLicenseMessage? qrLicense;
    if (tradeLicense != null) {
      final license = tradeLicense.license;
      if (license.isNotEmpty) {
        qrLicense = await qrLicenseRepository.getLicenseInfo(license);
      }
    }

    return poiCardState = PoiCardState(
      showEntrances: false,
      gisObjectIdMessage: result,
      tradeLicense: tradeLicense,
      qrTradeLicense: qrLicense,
    );
  }
}
