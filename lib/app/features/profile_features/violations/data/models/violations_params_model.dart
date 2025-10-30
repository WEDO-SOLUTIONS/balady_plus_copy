import 'package:equatable/equatable.dart';

import '../../../../../core/utils/utils_exports.dart';

class ViolationsParamsModel extends Equatable {
  final int page;
  final int size;

  final String? unifiedNationalNumber;
  final String? identityNumber;

  final String? violationIssueDate;
  final String? violationLastApplyDate;
  final String? violationStatusId;
  final String? violationInvoiceStatusId;
  final bool? isAllowForObjection;
  final String? violationInvoiceNumber;
  final String? licenseNumber;
  final SortType sort;

  const ViolationsParamsModel({
    this.unifiedNationalNumber,
    this.identityNumber,
    required this.page,
    required this.size,
    this.violationIssueDate,
    this.violationInvoiceStatusId,
    this.violationStatusId,
    this.isAllowForObjection = true,
    this.violationInvoiceNumber,
    this.licenseNumber,
    this.violationLastApplyDate,
    this.sort = SortType.desc,
  });

  Map<String, dynamic> toMap() {
    return {
      'unifiedNationalNumber': unifiedNationalNumber,
      'identityNumber': identityNumber,
      'page': page,
      'size': size,
      'violationIssueDate': violationIssueDate,
      'violationLastApplyDate': violationLastApplyDate,
      'violationStatusId': violationStatusId,
      'violationInvoiceStatusId': violationInvoiceStatusId,
      'isAllowForObjection': isAllowForObjection,
      'violationInvoiceNumber': violationInvoiceNumber,
      'licenseNumber': licenseNumber,
      'sort': [
        {
          "filed": "ViolationLastApplyDate",
          "type": sort.value,
        }
      ]
    };
  }

  @override
  List<Object?> get props => [
        page,
        size,
        unifiedNationalNumber,
        identityNumber,
        violationIssueDate,
        violationLastApplyDate,
        violationStatusId,
        violationInvoiceStatusId,
        isAllowForObjection,
        violationInvoiceNumber,
        licenseNumber,
        sort,
      ];
}
