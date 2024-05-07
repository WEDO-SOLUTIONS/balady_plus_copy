/*
class RelationResponseModel extends RelationResponse {
  RelationResponseModel(
      {super.id,
      super.name,
      super.subRelations,
      super.orderTypeId,
      super.serviceId,
      super.serviceLogoUrl,
      super.serviceName});

  factory RelationResponseModel.fromMap(Map<String, dynamic> json) =>
      RelationResponseModel(
        id: json["id"],
        subRelations: json["subRelations"] != null
            ? List<RelationItem>.from(
                json["subRelations"].map((x) => RelationItemModel.fromMap(x)))
            : null,
        name: json["name"],
        orderTypeId: json["orderTypeId"],
        serviceId: json["serviceId"],
        serviceLogoUrl: json["serviceLogoUrl"],
        serviceName: json["serviceName"],
      );
}
*/
