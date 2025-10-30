import 'package:equatable/equatable.dart';

import '../../../../../core/utils/utils_exports.dart' show SortType;

class LicensesParamsModel extends Equatable {
  final String? unifiedNationalNumber;
  final String? identityNumber;
  final int page;
  final int size;
  final String? licenseNumber;
  // final String? licenseNumber;
  // final String? invoiceId;
  final String? productId;
  // final String? requestTypeId;
  final String? dashboardStatusId;
  final String? municipalityId;
  final String? subMunicipalityId;
  final String? expireDate;
  final SortType sort;

  const LicensesParamsModel({
    this.unifiedNationalNumber,
    this.identityNumber,
    required this.page,
    required this.size,
    this.licenseNumber,
    // this.licenseNumber,
    // this.invoiceId,
    this.productId,
    // this.requestTypeId,
    this.dashboardStatusId,
    this.municipalityId,
    this.subMunicipalityId,
    this.expireDate,
    this.sort = SortType.desc,
  });

  Map<String, dynamic> toMap() {
    return {
      'unifiedNationalNumber': unifiedNationalNumber,
      'identityNumber': identityNumber,
      'licenseNo': licenseNumber,
      // 'requestNo': licenseNumber,
      // 'invoiceId': invoiceId,
      'page': page,
      'size': size,
      'productId': productId,
      // 'requestTypeId': requestTypeId,
      'dashboardStatusId': dashboardStatusId,
      'municipalityId': municipalityId,
      'subMunicipalityId': subMunicipalityId,
      'expireDate': expireDate,
      'sort': [
        {
          "filed": "7",
          "type": sort.value,
        }
      ]
    };
  }

  @override
  List<Object?> get props => [
        unifiedNationalNumber,
        identityNumber,
        // licenseNumber,
        licenseNumber,
        page,
        size,
        productId,
        // requestTypeId,
        dashboardStatusId,
        municipalityId,
        subMunicipalityId,
        expireDate,
        sort,
      ];
}
