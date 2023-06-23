import '../../delegators_exports.dart' show DelegatorEntity;

class DelegatorModel extends DelegatorEntity {
  const DelegatorModel({
    required super.crNumber,
    required super.unifiedNationalNumber,
    required super.delegationSource,
    required super.relationTypeId,
    required super.relationTypeName,
    required super.roleId,
    required super.roleName,
    required super.entityName,
  });

  factory DelegatorModel.fromMap(Map<String, dynamic> map) {
    return DelegatorModel(
      crNumber: map['crNumber'] as String,
      unifiedNationalNumber: map['unifiedNationalNumber'] as String?,
      delegationSource: map['delegationSource'] as String? ?? '',
      relationTypeId: map['relationTypeId'] as String? ?? '',
      relationTypeName: map['relationTypeName'] as String? ?? '',
      roleId: map['roleId'] as String? ?? '',
      roleName: map['roleName'] as String? ?? '',
      entityName: map['entityName'] as String? ?? '',
    );
  }
}
