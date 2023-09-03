// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class SelfRatingItem extends Equatable {
  final int id;
  final String image;
  final String condition;
  final List<String> procedure;
  bool? compliance;

  SelfRatingItem(
      {required this.id,
      required this.image,
      required this.condition,
      required this.procedure,
      this.compliance});

  @override
  // TODO: implement props
  List<Object?> get props => [id, compliance];

  factory SelfRatingItem.fromMap(Map<String, dynamic> map) {
    return SelfRatingItem(
      id: map['id'] as int,
      image: map['image'] as String,
      condition: map['condition'] as String,
      procedure: map['procedure'] != null
          ? List<String>.from(map['procedure'].map((x) => x as String))
          : [],
    );
  }
}
