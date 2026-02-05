import 'package:balady_plus/super_app_js_bridge/model/base_response.dart';
import 'package:balady_plus/app/features/delegators/domain/entities/delegator_entity.dart';

class JsDelegatorModel implements BaseData {
  String? crNumber;
  String? unifiedNationalNumber;
  String delegationSource;
  String relationTypeId;
  String relationTypeName;
  String roleId;
  String roleName;
  String entityName;
  String crType;

  JsDelegatorModel({
    this.crNumber,
    this.unifiedNationalNumber,
    required this.delegationSource,
    required this.relationTypeId,
    required this.relationTypeName,
    required this.roleId,
    required this.roleName,
    required this.entityName,
    required this.crType,
  });

  factory JsDelegatorModel.fromEntity(DelegatorEntity entity) {
    return JsDelegatorModel(
      crNumber: entity.crNumber,
      unifiedNationalNumber: entity.unifiedNationalNumber,
      delegationSource: entity.delegationSource,
      relationTypeId: entity.relationTypeId,
      relationTypeName: entity.relationTypeName,
      roleId: entity.roleId,
      roleName: entity.roleName,
      entityName: entity.entityName,
      crType: entity.crType,
    );
  }

  factory JsDelegatorModel.fromJson(Map<String, dynamic> json) {
    return JsDelegatorModel(
      crNumber: json['crNumber'] as String?,
      unifiedNationalNumber: json['unifiedNationalNumber'] as String?,
      delegationSource: json['delegationSource'] as String,
      relationTypeId: json['relationTypeId'] as String,
      relationTypeName: json['relationTypeName'] as String,
      roleId: json['roleId'] as String,
      roleName: json['roleName'] as String,
      entityName: json['entityName'] as String,
      crType: json['crType'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['crNumber'] = crNumber;
    data['unifiedNationalNumber'] = unifiedNationalNumber;
    data['delegationSource'] = delegationSource;
    data['relationTypeId'] = relationTypeId;
    data['relationTypeName'] = relationTypeName;
    data['roleId'] = roleId;
    data['roleName'] = roleName;
    data['entityName'] = entityName;
    data['crType'] = crType;
    return data;
  }
}
