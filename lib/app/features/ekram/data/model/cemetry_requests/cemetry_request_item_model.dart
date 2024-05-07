import '../../../domain/entities/cemetry_requests/cemetry_request_item.dart';

class CemetryRequestItemModel extends CemetryRequestItem {
  CemetryRequestItemModel({
    super.entryModeId,
    super.deceasedIdentityNumber,
    super.deceasedName,
    super.requestNumber,
    super.requestUniqueKey,
    super.cemeteryId,
    super.cemeteryName,
    super.burialDate,
    super.burialTimeId,
    super.burialTimeName,
    super.burialTimeOther,
    super.requestStatusId,
    super.requestStatusName,
  });

  factory CemetryRequestItemModel.fromJson(Map<String, dynamic> json) =>
      CemetryRequestItemModel(
        entryModeId: json["entryModeId"],
        deceasedIdentityNumber: json["deceasedIdentityNumber"],
        deceasedName: json["deceasedName"],
        requestNumber: json["requestNumber"],
        requestUniqueKey: json["requestUniqueKey"],
        cemeteryId: json["cemeteryId"],
        cemeteryName: json["cemeteryName"],
        burialDate: json["burialDate"],
        burialTimeId: json["burialTimeId"],
        burialTimeName: json["burialTimeName"],
        burialTimeOther: json["burialTimeOther"],
        requestStatusId: json["requestStatusId"],
        requestStatusName: json["requestStatusName"],
      );
}
