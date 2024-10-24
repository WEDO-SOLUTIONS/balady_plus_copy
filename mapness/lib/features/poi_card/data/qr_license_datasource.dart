import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mapness/features/poi_card/data/qr_license_service.dart';

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

      return ((result as Response<Map>).data?['data'] as Map)['result'] as Map<String, dynamic>;
    } on DioException catch (error) {
      if (kDebugMode) {
        print('[licenseDetails] DioError $error');
      }
    } catch (error) {
      if (kDebugMode) {
        print('[licenseDetails] $error');
      }
    }
    return null;
  }
}
