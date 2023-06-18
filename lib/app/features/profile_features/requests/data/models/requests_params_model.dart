import 'package:equatable/equatable.dart';

import '../../../../../core/utils/utils_exports.dart' show SortType;

class RequestsParamsModel extends Equatable {
  final int? identityNumber;
  final String? query;
  final String? licenceId;
  final String? requestNumber;
  final int page;
  final int size;
  final String? productId;
  final String? requestTypeId;
  final String? dashboardStatusId;
  final String? municipalityId;
  final String? subMunicipalityId;
  final String? creationDate;
  final SortType sort;

  const RequestsParamsModel({
    this.identityNumber,
    this.query,
    this.licenceId,
    this.requestNumber,
    required this.page,
    required this.size,
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
      'identityNumber': identityNumber,
      'query': query,
      'licenceId': licenceId,
      'requestNumber': requestNumber,
      'page': page,
      'size': size,
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
        identityNumber,
        query,
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
