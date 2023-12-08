// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class AthkarEntity extends Equatable {
  final String name;
  final String? content;
  final int quantity;
  final String description;
  final String quantityText;

  const AthkarEntity({
    required this.name,
    required this.content,
    required this.quantity,
    required this.description,
    required this.quantityText,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        name,
        quantity,
        content,
        description,
        quantityText,
      ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'content': content,
      'quantity': quantity,
      'description': description,
      'quantityText': quantityText,
    };
  }

  factory AthkarEntity.fromMap(Map<String, dynamic> map) {
    return AthkarEntity(
      name: map['name'] as String,
      content: map['content'] as String?,
      quantity: map['quantity'],
      description: map['description'] as String,
      quantityText: map['quantityText'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AthkarEntity.fromJson(String source) =>
      AthkarEntity.fromMap(json.decode(source) as Map<String, dynamic>);
}
