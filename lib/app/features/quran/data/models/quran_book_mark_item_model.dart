// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class QuranBookMarkItemModel extends Equatable {
  final int pageNumber;
  final String suraName;
  final String suraNo;
  QuranBookMarkItemModel({
    required this.pageNumber,
    required this.suraName,
    required this.suraNo,
  });

  @override
  List<Object?> get props => [];

  QuranBookMarkItemModel copyWith({
    int? pageNumber,
    String? suraName,
    String? suraNo,
  }) {
    return QuranBookMarkItemModel(
      pageNumber: pageNumber ?? this.pageNumber,
      suraName: suraName ?? this.suraName,
      suraNo: suraNo ?? this.suraNo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pageNumber': pageNumber,
      'suraName': suraName,
      'suraNo': suraNo,
    };
  }

  factory QuranBookMarkItemModel.fromMap(Map<String, dynamic> map) {
    return QuranBookMarkItemModel(
      pageNumber: map['pageNumber'] as int,
      suraName: map['suraName'] as String,
      suraNo: map['suraNo'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory QuranBookMarkItemModel.fromJson(String source) =>
      QuranBookMarkItemModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
