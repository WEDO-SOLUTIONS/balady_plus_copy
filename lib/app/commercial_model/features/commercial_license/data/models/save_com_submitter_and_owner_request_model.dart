import 'dart:convert';

class SaveComSubmitterAndOwnerRequestModel {
  String? crNumber;
  String? entityType;
  int? crType;
  int? requestId;
  String? roleName;

  SaveComSubmitterAndOwnerRequestModel({
    this.crNumber,
    this.crType,
    this.entityType,
    this.requestId,
    required this.roleName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'crNumber': crNumber,
      'entityType': entityType,
      'crType': crType,
      'submitterType': roleName,
    };
  }

  factory SaveComSubmitterAndOwnerRequestModel.fromMap(
      Map<String, dynamic> map) {
    return SaveComSubmitterAndOwnerRequestModel(
      crNumber: map['crNumber'] != null ? map['crNumber'] as String : null,
      entityType:
          map['entityType'] != null ? map['entityType'] as String : null,
      crType: map['crType'] != null ? map['crType'] as int : null,
      roleName: map['roleName'] != null ? map['roleName'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SaveComSubmitterAndOwnerRequestModel.fromJson(String source) =>
      SaveComSubmitterAndOwnerRequestModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
