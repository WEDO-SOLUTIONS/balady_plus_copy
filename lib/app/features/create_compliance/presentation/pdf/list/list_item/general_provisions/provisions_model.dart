import 'dart:convert';

class ProvisionsModel {
  final String desc;

  ProvisionsModel(this.desc);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'desc': desc,
    };
  }

  factory ProvisionsModel.fromMap(Map<String, dynamic> map) {
    return ProvisionsModel(
      map['desc'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProvisionsModel.fromJson(String source) =>
      ProvisionsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
