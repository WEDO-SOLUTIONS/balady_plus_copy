// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class CommercialBoardType extends Equatable {
  int id;
  int typeId;
  String name;
  double? area;
  CommercialBoardType({
    required this.id,
    required this.typeId,
    required this.name,
    this.area,
  });

  @override
  List<Object?> get props => [id, typeId, name, area];

  CommercialBoardType copyWith({
    int? id,
    int? typeId,
    String? name,
    double? area,
  }) {
    return CommercialBoardType(
      id: id ?? this.id,
      typeId: typeId ?? this.typeId,
      name: name ?? this.name,
      area: area ?? this.area,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'typeId': typeId,
      'name': name,
      'area': area,
    };
  }

  factory CommercialBoardType.fromMap(Map<String, dynamic> map) {
    return CommercialBoardType(
      id: map['id'] as int,
      typeId: map['typeId'] as int,
      name: map['name'] as String,
      area: map['area'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory CommercialBoardType.fromJson(String source) =>
      CommercialBoardType.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}
