import 'package:balady_plus/super_app_js_bridge/model/base_response.dart';
import 'package:balady_plus/app/features/delegators/domain/entities/agent_entity.dart';

class JsAgentModel implements BaseData {
  String? requestId;
  String? agencyNumber;
  String? agencyTypeId;
  String? agencyTypeName;
  String? agentNumber;
  String? agentTypeId;
  String? agentTypeName;
  String? agentName;
  String? grantorName;
  String? grantorNumber;
  String? grantorTypeId;
  String? grantorTypeName;
  String? ownerNumber;
  String? ownerTypeId;
  String? correlationId;
  String? active;
  bool? isActive;

  JsAgentModel({
    this.requestId,
    this.agencyNumber,
    this.agencyTypeId,
    this.agencyTypeName,
    this.agentNumber,
    this.agentTypeId,
    this.agentTypeName,
    this.agentName,
    this.grantorName,
    this.grantorNumber,
    this.grantorTypeId,
    this.grantorTypeName,
    this.ownerNumber,
    this.ownerTypeId,
    this.correlationId,
    this.active,
    this.isActive,
  });

  factory JsAgentModel.fromEntity(AgentEntity entity) {
    return JsAgentModel(
      requestId: entity.requestId,
      agencyNumber: entity.agencyNumber,
      agencyTypeId: entity.agencyTypeId,
      agencyTypeName: entity.agencyTypeName,
      agentNumber: entity.agentNumber,
      agentTypeId: entity.agentTypeId,
      agentTypeName: entity.agentTypeName,
      agentName: entity.agentName,
      grantorName: entity.grantorName,
      grantorNumber: entity.grantorNumber,
      grantorTypeId: entity.grantorTypeId,
      grantorTypeName: entity.grantorTypeName,
      ownerNumber: entity.ownerNumber,
      ownerTypeId: entity.ownerTypeId,
      correlationId: entity.correlationId,
      active: entity.active,
      isActive: entity.isActive,
    );
  }

  factory JsAgentModel.fromJson(Map<String, dynamic> json) {
    return JsAgentModel(
      requestId: json['requestId'] as String?,
      agencyNumber: json['agencyNumber'] as String?,
      agencyTypeId: json['agencyTypeId'] as String?,
      agencyTypeName: json['agencyTypeName'] as String?,
      agentNumber: json['agentNumber'] as String?,
      agentTypeId: json['agentTypeId'] as String?,
      agentTypeName: json['agentTypeName'] as String?,
      agentName: json['agentName'] as String?,
      grantorName: json['grantorName'] as String?,
      grantorNumber: json['grantorNumber'] as String?,
      grantorTypeId: json['grantorTypeId'] as String?,
      grantorTypeName: json['grantorTypeName'] as String?,
      ownerNumber: json['ownerNumber'] as String?,
      ownerTypeId: json['ownerTypeId'] as String?,
      correlationId: json['correlationId'] as String?,
      active: json['active'] as String?,
      isActive: json['isActive'] as bool?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['requestId'] = requestId;
    data['agencyNumber'] = agencyNumber;
    data['agencyTypeId'] = agencyTypeId;
    data['agencyTypeName'] = agencyTypeName;
    data['agentNumber'] = agentNumber;
    data['agentTypeId'] = agentTypeId;
    data['agentTypeName'] = agentTypeName;
    data['agentName'] = agentName;
    data['grantorName'] = grantorName;
    data['grantorNumber'] = grantorNumber;
    data['grantorTypeId'] = grantorTypeId;
    data['grantorTypeName'] = grantorTypeName;
    data['ownerNumber'] = ownerNumber;
    data['ownerTypeId'] = ownerTypeId;
    data['correlationId'] = correlationId;
    data['active'] = active;
    data['isActive'] = isActive;
    return data;
  }
}
