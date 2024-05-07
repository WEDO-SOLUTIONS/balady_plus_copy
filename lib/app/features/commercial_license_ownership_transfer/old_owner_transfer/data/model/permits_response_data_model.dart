import '../../domain/entity/permits_response_entity.dart';

class PermitsResponseDataModel extends PermitsResponseEntity {
  PermitsResponseDataModel({
    super.permits,
    super.term,
  });

  PermitsResponseDataModel.fromJson(dynamic json) {
    if (json['permits'] != null) {
      permits = [];
      json['permits'].forEach((v) {
        permits?.add(PermitDataModel.fromJson(v));
      });
    }
    term = json['term'];
  }
}

class PermitDataModel extends PermitEntity {
  PermitDataModel({
    super.accepted,
    super.expirationDate,
    super.id,
    super.permitNumber,
    super.requestId,
    super.permitName,
    super.selected,
  });

  PermitDataModel.fromJson(dynamic json) {
    accepted = json['accepted'];
    expirationDate = json['permitEndDate'];
    id = json['id'];
    permitNumber = json['permitNumber'];
    requestId = json['requestId'];
    permitName = json['permitName'];
    selected = json['selected'];
  }
}
