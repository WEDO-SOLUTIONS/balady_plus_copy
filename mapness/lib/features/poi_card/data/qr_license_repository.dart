import 'package:dio/dio.dart';
import 'package:mapness/entry_point.dart';
import 'package:mapness/features/poi_card/data/qr_license_datasource.dart';
import 'package:mapness/features/poi_card/data/qr_license_service.dart';
import 'package:mapness/features/poi_card/domain/model/qr_trade_license.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/utils/common_function.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'qr_license_repository.g.dart';

@riverpod
class QrLicenseRepository extends _$QrLicenseRepository {
  final dataSource = QrLicenseDataSource(
    QrLicenseService(
      dio: Dio(),
    ),
  );

  Future<QrLicenseMessage?> getLicenseInfo(String licenseNumber) async {
    mixpanel?.timeEvent('Qr License: getLicenseInfo');
    final env = await ref.read(dgisEnvironmentProvider.future);
    String resultUrl;
    var verifyKey = '';
    final proxy = env.proxy;
    const licenseDetails = 'qr-services/mobile/license-details';

    if (proxy != null) {
      const domain = 'https://apiservicesstg.balady.gov.sa';
      final url = '$domain/v1/$licenseDetails/$licenseNumber';
      verifyKey = hashRequest(url, 'GET');
      final proxyUrl = '$proxy/v1/$licenseDetails';
      resultUrl = '$proxyUrl/$licenseNumber';
    } else {
      final domain = env.url.replaceAll('/urbi-services/', '');
      resultUrl = '$domain/$licenseDetails/$licenseNumber';
    }

    final response = await dataSource.getLicenseInfo(
      verifyingKEY: verifyKey,
      url: resultUrl,
    );

    if (response == null) {
      return null;
    }
    await mixpanel?.track('Qr License: getLicenseInfo');

    return QrLicenseMessage.fromJson(response);
  }

  @override
  void build() {}
}
