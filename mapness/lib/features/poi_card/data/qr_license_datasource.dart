import 'dart:async';
import 'package:dio/dio.dart';

import 'package:mapness/features/poi_card/data/qr_license_service.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

abstract class QrLicenseDataSource {
  factory QrLicenseDataSource(QrLicenseService service) => _QrLicenseDataSource(service: service);

  Future<Map<String, dynamic>?> getLicenseInfo({
    required String? verifyingKEY,
    required String url,
  });
}

class _QrLicenseDataSource implements QrLicenseDataSource {
  _QrLicenseDataSource({required this.service});
  final QrLicenseService service;

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
        options: Options(
          headers: {
            if (verifyingKEY != null) 'verifyingKEY': verifyingKEY,
            'Cookie': cookie,
          },
        ),
      );
      // TODO: refactor to dto model
      return ((result as Response<Map?>).data?['data'] as Map?)?['result'] as Map<String, dynamic>?;
    } on DioException catch (error) {
      logger.log('[licenseDetails] DioError $error', logLevel: MapnessLogLevel.critical);
    } catch (error) {
      logger.log('[licenseDetails] $error', logLevel: MapnessLogLevel.critical);
    }
    return null;
  }
}
