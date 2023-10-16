import '../../delegators_exports.dart' show AgentEntity;

class AgentModel extends AgentEntity {
  const AgentModel(
      {super.agencyNumber,
      super.agencyTypeId,
      super.agencyTypeName,
      super.agentNumber,
      super.agentTypeId,
      super.agentTypeName,
      super.agentName,
      super.grantorName,
      super.grantorNumber,
      super.grantorTypeId,
      super.grantorTypeName,
      super.ownerNumber,
      super.ownerTypeId,
      super.correlationId,
      super.active,
      super.isActive,
      super.requestId});

  factory AgentModel.fromMap(Map<String, dynamic> json) {
    return AgentModel(
      requestId: json["requestId"],
      agencyNumber: json["agencyNumber"],
      agencyTypeId: json["agencyTypeId"],
      agencyTypeName: json["agencyTypeName"],
      agentNumber: json["agentNumber"],
      agentTypeId: json["agentTypeId"],
      agentTypeName: json["agentTypeName"],
      agentName: json["agentName"],
      grantorName: json["grantorName"],
      grantorNumber: json["grantorNumber"],
      grantorTypeId: json["grantorTypeId"],
      grantorTypeName: json["grantorTypeName"],
      ownerNumber: json["ownerNumber"],
      ownerTypeId: json["ownerTypeId"],
      correlationId: json["correlationId"],
      active: json["active"],
      isActive: json["isActive"],
    );
  }
}
