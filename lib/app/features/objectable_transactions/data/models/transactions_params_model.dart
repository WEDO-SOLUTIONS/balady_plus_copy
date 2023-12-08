import 'package:equatable/equatable.dart';

class TransactionsParamsModel extends Equatable {
  final String? unifiedNationalNumber;
  final String? identityNumber;
  final String? requestNo;
  final int page;
  final int size;
  final String? productId;
  final String? requestTypeId;
  final String? violationLastApplyDate;

  const TransactionsParamsModel({
    this.unifiedNationalNumber,
    this.identityNumber,
    this.requestNo,
    required this.page,
    required this.size,
    this.productId,
    this.requestTypeId,
    this.violationLastApplyDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'unifiedNationalNumber': unifiedNationalNumber,
      'identityNumber': identityNumber,
      'transactionNumber': requestNo,
      'page': page,
      'size': size,
      'applicationId': productId,
      'serviceId': requestTypeId,
      'violationLastApplyDate': violationLastApplyDate,
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
        violationLastApplyDate,
      ];
}
