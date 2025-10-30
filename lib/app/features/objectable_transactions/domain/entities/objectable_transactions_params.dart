import '../../objections_exports.dart' show TransactionsParamsModel;

class TransactionsRequestsPrams extends TransactionsParamsModel {
  const TransactionsRequestsPrams({
    super.unifiedNationalNumber,
    super.identityNumber,
    super.requestNo,
    required super.page,
    required super.size,
    super.productId,
    super.requestTypeId,
    super.violationLastApplyDate,
  });
}
