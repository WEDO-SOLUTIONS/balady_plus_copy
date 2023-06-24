import 'package:equatable/equatable.dart';

import '../../../../../core/utils/utils_exports.dart' show SortType;

class RequestsParamsModel extends Equatable {
  final String? unifiedNationalNumber;
  final String? identityNumber;
  final int page;
  final int size;
  final String? requestNumber;
  final String? licenceId;
  final String? productId;
  final String? requestTypeId;
  final String? dashboardStatusId;
  final String? municipalityId;
  final String? subMunicipalityId;
  final String? creationDate;
  final SortType sort;

  const RequestsParamsModel({
    this.unifiedNationalNumber,
    this.identityNumber,
    required this.page,
    required this.size,
    this.requestNumber,
    this.licenceId,
    this.productId,
    this.requestTypeId,
    this.dashboardStatusId,
    this.municipalityId,
    this.subMunicipalityId,
    this.creationDate,
    this.sort = SortType.desc,
  });

  Map<String, dynamic> toMap() {
    return {
      'unifiedNationalNumber': unifiedNationalNumber,
      'identityNumber': identityNumber,
      'page': page,
      'size': size,
      'requestNo': requestNumber,
      'licenceId': licenceId,
      'productId': productId,
      'requestTypeId': requestTypeId,
      'dashboardStatusId': dashboardStatusId,
      'municipalityId': municipalityId,
      'subMunicipalityId': subMunicipalityId,
      'creationDate': creationDate,
      'sort': [
        {
          "filed": "8",
          "type": sort.value,
        }
      ]
    };
  }

  @override
  List<Object?> get props => [
        unifiedNationalNumber,
        identityNumber,
        requestNumber,
        licenceId,
        page,
        size,
        productId,
        requestTypeId,
        dashboardStatusId,
        municipalityId,
        subMunicipalityId,
        creationDate,
        sort,
      ];
}
