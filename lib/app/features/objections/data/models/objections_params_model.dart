import 'package:equatable/equatable.dart';

class ObjectionsParamsModel extends Equatable {
  final String? unifiedNationalNumber;
  final String? identityNumber;
  final String? requestNo;
  final int page;
  final int size;
  final String? productId;
  final String? requestTypeId;
  final String? dashboardStatusId;
  const ObjectionsParamsModel({
    this.unifiedNationalNumber,
    this.identityNumber,
    this.requestNo,
    required this.page,
    required this.size,
    this.productId,
    this.requestTypeId,
    this.dashboardStatusId,
  });

  Map<String, dynamic> toMap() {
    return {
      if (unifiedNationalNumber != null)
        'unifiedNationalNumber': unifiedNationalNumber,
      if (identityNumber != null) 'identityNumber': identityNumber,
      if (requestNo != null) 'requestNo': requestNo,
      'page': page,
      'size': size,
      if (productId != null) 'objectedApplicationId': productId,
      if (requestTypeId != null) 'objectedServiceId': requestTypeId,
      if (dashboardStatusId != null) 'dashboardStatusId': dashboardStatusId,
    };
  }

  @override
  List<Object?> get props => [
        unifiedNationalNumber,
        identityNumber,
        requestNo,
        page,
        size,
        productId,
        requestTypeId,
        dashboardStatusId,
      ];
}
