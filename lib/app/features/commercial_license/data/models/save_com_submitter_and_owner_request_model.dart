// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SaveComSubmitterAndOwnerRequestModel {
  String? crNumber;
  int? entityType;
  int? crType;

  SaveComSubmitterAndOwnerRequestModel(
      {this.crNumber, this.crType, this.entityType});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'crNumber': crNumber,
      'entityType': entityType,
      'crType': crType,
    };
  }

  factory SaveComSubmitterAndOwnerRequestModel.fromMap(
      Map<String, dynamic> map) {
    return SaveComSubmitterAndOwnerRequestModel(
      crNumber: map['crNumber'] != null ? map['crNumber'] as String : null,
      entityType: map['entityType'] != null ? map['entityType'] as int : null,
      crType: map['crType'] != null ? map['crType'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SaveComSubmitterAndOwnerRequestModel.fromJson(String source) =>
      SaveComSubmitterAndOwnerRequestModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
