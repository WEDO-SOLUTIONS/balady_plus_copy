import '../../delegators_exports.dart' show AgentEntity;

class AgentModel extends AgentEntity {
  const AgentModel({
    super.crNumber,
    super.unifiedNationalNumber,
    required super.delegationSource,
    required super.relationTypeId,
    required super.relationTypeName,
    required super.roleId,
    required super.roleName,
    required super.entityName,
  });

  factory AgentModel.fromMap(Map<String, dynamic> map) {
    return AgentModel(
      crNumber: map['crNumber'],
      unifiedNationalNumber: map['unifiedNationalNumber'],
      delegationSource: map['delegationSource'] as String? ?? '',
      relationTypeId: map['relationTypeId'] as String? ?? '',
      relationTypeName: map['relationTypeName'] as String? ?? '',
      roleId: map['roleId'] as String? ?? '',
      roleName: map['roleName'] as String? ?? '',
      entityName: map['entityName'] as String? ?? '',
    );
  }
}
