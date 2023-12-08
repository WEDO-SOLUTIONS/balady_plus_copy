import '../../delegators_exports.dart' show DelegatorEntity;

class DelegatorModel extends DelegatorEntity {
  const DelegatorModel(
      {super.crNumber,
      super.unifiedNationalNumber,
      required super.delegationSource,
      required super.relationTypeId,
      required super.relationTypeName,
      required super.roleId,
      required super.roleName,
      required super.entityName,
      required super.crType});

  factory DelegatorModel.fromMap(Map<String, dynamic> map) {
    return DelegatorModel(
        crNumber: map['crNumber'],
        unifiedNationalNumber: map['unifiedNationalNumber'],
        delegationSource: map['delegationSource'] as String? ?? '',
        relationTypeId: map['relationTypeId'] as String? ?? '',
        relationTypeName: map['relationTypeName'] as String? ?? '',
        roleId: map['roleId'] as String? ?? '',
        roleName: map['roleName'] as String? ?? '',
        entityName: map['entityName'] as String? ?? '',
        crType: map['crType'] as String? ?? '');
  }
}
