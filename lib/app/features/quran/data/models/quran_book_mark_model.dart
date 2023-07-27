// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:balady_plus/app/features/quran/data/models/quran_book_mark_item_model.dart';

class QuranBookMarkModel {
  final List<QuranBookMarkItemModel>? items;
  QuranBookMarkModel({
    this.items,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'items': items?.map((x) => x.toMap()).toList(),
    };
  }

  factory QuranBookMarkModel.fromMap(Map<String, dynamic> map) {
    return QuranBookMarkModel(
      items: map['items'] != null
          ? List<QuranBookMarkItemModel>.from(
              (map['items'] as List<dynamic>).map<QuranBookMarkItemModel?>(
                (x) =>
                    QuranBookMarkItemModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory QuranBookMarkModel.fromJson(String source) =>
      QuranBookMarkModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
