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
      'unifiedNationalNumber': unifiedNationalNumber,
      'identityNumber': identityNumber,
      'requestNo': requestNo,
      'page': page,
      'size': size,
      'objectedApplicationId': productId,
      'objectedServiceId': requestTypeId,
      'dashboardStatusId': dashboardStatusId,
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
