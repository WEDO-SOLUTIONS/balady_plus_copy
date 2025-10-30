import 'dart:convert';

class TermModel {
  final String name;
  final String desc;

  TermModel(this.name, this.desc);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'desc': desc,
    };
  }

  factory TermModel.fromMap(Map<String, dynamic> map) {
    return TermModel(
      map['name'] as String,
      map['desc'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TermModel.fromJson(String source) =>
      TermModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
