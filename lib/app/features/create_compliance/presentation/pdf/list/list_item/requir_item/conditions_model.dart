import 'dart:convert';

class ConditionsModel {
  final String desc;
  final String photo;

  ConditionsModel(this.desc, this.photo);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'desc': desc,
      'photo': photo,
    };
  }

  factory ConditionsModel.fromMap(Map<String, dynamic> map) {
    return ConditionsModel(
      map['desc'] as String,
      map['photo'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ConditionsModel.fromJson(String source) =>
      ConditionsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
