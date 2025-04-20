import 'package:equatable/equatable.dart';

class DelegatorEntity extends Equatable {
  final String? crNumber;
  final String? unifiedNationalNumber;
  final String delegationSource;
  final String relationTypeId;
  final String relationTypeName;
  final String roleId;
  final String roleName;
  final String entityName;
  final String crType;

  const DelegatorEntity(
      {this.crNumber,
      this.unifiedNationalNumber,
      required this.delegationSource,
      required this.relationTypeId,
      required this.relationTypeName,
      required this.roleId,
      required this.roleName,
      required this.entityName,
      required this.crType});

  String get id => (crNumber ?? unifiedNationalNumber) ?? "";

  @override
  List<Object?> get props => [
        crNumber,
        unifiedNationalNumber,
        delegationSource,
        relationTypeId,
        relationTypeName,
        roleId,
        roleName,
        entityName,
        crType
      ];

  String getRole() {
    if (roleId == "20") return "OWNER_MANAGER";
    if (roleId == "30") return "DELEGATOR";

    return "";
  }
}
