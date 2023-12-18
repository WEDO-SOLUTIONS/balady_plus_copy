import 'dart:async';
import 'package:dio/dio.dart';
import 'package:mapness/_features/lifestyle_layers/data/common_function.dart';
import 'package:mapness/_features/poi_card/data/qr_license_service.dart';

abstract class QrLicenseDataSource {
  factory QrLicenseDataSource(QrLicenseService service) =>
      _QrLicenseDataSource(service: service);

  Future<Map<String, dynamic>?> getLicenseInfo({
    required String? verifyingKEY,
    required String url,
  });
}

class _QrLicenseDataSource implements QrLicenseDataSource {
  final QrLicenseService service;

  _QrLicenseDataSource({required this.service});

  @override
  Future<Map<String, dynamic>?> getLicenseInfo({
    required String? verifyingKEY,
    required String url,
  }) async {
    Response result;
    try {

      const cookie =
          'BIGipServerapistg.app~apistg_pool=4000862218.10531.0000; BIGipServerstag_adf_pool=558934208.24862.0000';

      result = await service.dio.get(
        url,
        options: Options(headers: {
          if (verifyingKEY != null) 'verifyingKEY': verifyingKEY,
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
