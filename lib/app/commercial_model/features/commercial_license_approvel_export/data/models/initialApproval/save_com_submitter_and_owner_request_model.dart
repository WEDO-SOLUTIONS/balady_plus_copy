import 'dart:convert';

class SubmitterAndOwnerRequestModel {
  String? crNumber;
  int? crType;

  SubmitterAndOwnerRequestModel(
      {this.crNumber, this.crType});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'crNumber': crNumber,
      'crType': crType,
    };
  }

  factory SubmitterAndOwnerRequestModel.fromMap(
      Map<String, dynamic> map) {
    return SubmitterAndOwnerRequestModel(
      crNumber: map['crNumber'] != null ? map['crNumber'] as String : null,
      crType: map['crType'] != null ? map['crType'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SubmitterAndOwnerRequestModel.fromJson(String source) =>
      SubmitterAndOwnerRequestModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
