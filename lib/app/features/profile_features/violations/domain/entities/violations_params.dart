import '../../violations_exports.dart' show ViolationsParamsModel;

class ViolationsPrams extends ViolationsParamsModel {
  const ViolationsPrams({
    super.unifiedNationalNumber,
    super.identityNumber,
    super.isAllowForObjection,
    super.violationInvoiceNumber,
    super.violationInvoiceStatusId,
    super.violationIssueDate,
    super.violationStatusId,
    super.licenseNumber,
    super.sort,
    required super.page,
    required super.size,
    super.violationLastApplyDate,
  });
}
