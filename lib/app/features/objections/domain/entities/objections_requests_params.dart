import '../../objections_exports.dart' show ObjectionsParamsModel;

class ObjectionsRequestsPrams extends ObjectionsParamsModel {
  const ObjectionsRequestsPrams({
    super.unifiedNationalNumber,
    super.identityNumber,
    super.requestNo,
    required super.page,
    required super.size,
    super.productId,
    super.requestTypeId,
    super.dashboardStatusId,
  });
}
