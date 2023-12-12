import 'dart:async';
import 'package:dio/dio.dart';
import 'package:mapness/_features/lifestyle_layers/data/common_function.dart';
import 'package:mapness/_features/poi_card/data/qr_license_service.dart';

abstract class QrLicenseDataSource {
  factory QrLicenseDataSource(QrLicenseService service) =>
      _QrLicenseDataSource(service: service);

  Future<Map<String, dynamic>?> getLicenseInfo({required String licenseNumber});
}

class _QrLicenseDataSource implements QrLicenseDataSource {
  final QrLicenseService service;

  _QrLicenseDataSource({required this.service});

  @override
  Future<Map<String, dynamic>?> getLicenseInfo(
      {required String licenseNumber}) async {
    Response result;
    try {
      // curl --location 'https://sa1.ops.2gis.dev/v1/qr-services/mobile/license-details/45059832240' \
      // --header 'verifyingKEY: Qs9NT2rdN7YajxWe9G7ZoTqC21JNZmvCXaVXKcUnBsU=' \
      // --header 'Cookie: BIGipServerapistg.app~apistg_pool=4000862218.10531.0000; BIGipServerstag_adf_pool=558934208.24862.0000'

      const cookie =
          'BIGipServerapistg.app~apistg_pool=4000862218.10531.0000; BIGipServerstag_adf_pool=558934208.24862.0000';

      const proxy = 'https://sa1.ops.2gis.dev/v1';
      const domain = 'https://apiservicesstg.balady.gov.sa/v1';
      const licenseDetails = 'qr-services/mobile/license-details';

      var hashedUrl = "$domain/$licenseDetails/$licenseNumber";
      const mainUrl = "$proxy/$licenseDetails";

      final verifyingKey = hashRequest_(hashedUrl, "GET");

      hashedUrl = "$mainUrl/$licenseNumber";

      result = await service.dio.get(
        hashedUrl,
        options: Options(headers: {
          'verifyingKEY': verifyingKey,
          'Cookie': cookie,
        }),
      );

      return result.data['data']['result'];
    } on DioException catch (error) {
      print("[licenseDetails] DioError $error");
    } catch (error) {
      print("[licenseDetails] $error");
    }
    return null;
  }
}
