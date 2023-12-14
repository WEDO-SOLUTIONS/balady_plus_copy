import 'package:dio/dio.dart';
import 'package:mapness/_features/poi_card/data/qr_license_datasource.dart';
import 'package:mapness/_features/poi_card/data/qr_license_service.dart';
import 'package:mapness/_features/poi_card/domain/model/qr_trade_license.dart';
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
    var response = await dataSource.getLicenseInfo(
      licenseNumber: licenseNumber,
    );

    if (response == null) return null;
    return QrLicenseMessage.fromJson(response);
  }

  @override
  void build() {}
}
