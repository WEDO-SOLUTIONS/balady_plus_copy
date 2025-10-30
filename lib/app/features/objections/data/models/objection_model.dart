import '../../objections_exports.dart';

class ObjectionModel extends ObjectionEntity {
  const ObjectionModel(
      {super.lastUpdatedDate,
      super.requestStatusId,
      super.serviceGroupName,
      super.serviceGroupId,
      super.municipalityName,
      super.serviceId,
      super.objectionRequestNumber,
      super.objectionTypeName,
      super.serviceName,
      super.subMunicipalityName,
      super.requestCreationDate,
      super.objectionTypeId,
      super.requestStatusName,
      super.hashingRequestNumber,
      super.serviceTypeId});

  factory ObjectionModel.fromMap(Map<String, dynamic> json) {
    return ObjectionModel(
        lastUpdatedDate: json["updateTime"] == null
            ? null
            : DateTime.parse(json["updateTime"]),
        requestStatusId: json["RequestStatusId"],
        serviceGroupName: json["ServiceGroupName"],
        serviceGroupId: json["objectedApplicationId"],
        municipalityName: json["municipalityName"],
        serviceId: json["objectedServiceId"],
        objectionRequestNumber: json["requestNumberAsText"],
        objectionTypeName: json["objectedTypeName"],
        serviceName: json["objectedServiceName"],
        subMunicipalityName: json["subMunicipalityName"],
        requestCreationDate: json["creationDate"] == null
            ? null
            : DateTime.parse(json["creationDate"]),
        objectionTypeId: json["ObjectionTypeId"],
        requestStatusName: json["dashboardStatusName"],
        hashingRequestNumber: json["hashingRequestNumber"],
        serviceTypeId: json["serviceTypeId"]);
  }
}
