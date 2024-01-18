import 'package:dgis_map/library.dart';
import 'package:mapness/_features/poi_card/data/qr_license_repository.dart';
import 'package:mapness/_features/poi_card/domain/model/qr_trade_license.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/shared/providers/map/point_of_interest.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'poi_card_provider.g.dart';

class PoiCardState {
  bool isLoading;
  bool showEntrances;
  final DirectoryObjectMessage? gisObjectIdMessage;
  final TradeLicenseMessage? tradeLicense;
  // final QrLicenseMessage? qrTradeLicense;

  PoiCardState({
    // this.qrTradeLicense,
    this.tradeLicense,
    required this.showEntrances,
    required this.isLoading,
    required this.gisObjectIdMessage,
  });

  PoiCardState copy({
    bool? showEntrances,
    bool? isLoading,
    DirectoryObjectMessage? gisObjectIdMessage,
    TradeLicenseMessage? tradeLicense,
    // QrLicenseMessage? qrTradeLicense,
  }) {
    return PoiCardState(
      tradeLicense: tradeLicense ?? this.tradeLicense,
      showEntrances: showEntrances ?? this.showEntrances,
      isLoading: isLoading ?? this.isLoading,
      gisObjectIdMessage: gisObjectIdMessage ?? this.gisObjectIdMessage,
      // qrTradeLicense: qrTradeLicense,
    );
  }
}

@riverpod
class PoiCardProvider extends _$PoiCardProvider {
  @override
  Future<PoiCardState?> build(
    DgisObjectIdMessage objectId,
  ) async {
    // final qrLicenseRepository = ref.watch(qrLicenseRepositoryProvider.notifier);
    final result = await ref
        .watch(pointOfInterestProvider(objectId).future)
        .timeout(const Duration(minutes: 1), onTimeout: () {
      ref.read(goRouterProvider).pop();
      return null;
    });

    var tradeLicense = result?.tradeLicense;

    // QrLicenseMessage? qrLicense;
    // if (tradeLicense != null) {
    //   var license = tradeLicense.license;
    //   if (license.isNotEmpty) {
    //     qrLicense = await qrLicenseRepository.getLicenseInfo(license);
    //   }
    // }

    return PoiCardState(
      isLoading: true,
      showEntrances: false,
      gisObjectIdMessage: result,
      tradeLicense: tradeLicense,
      // qrTradeLicense: qrLicense,
    );
  }
}
