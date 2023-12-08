// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
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

  String getImage() {
    switch (image) {
      case "1":
        return ImagePath.buildingReq1;
      case "2":
        return ImagePath.buildingReq2;
      case "3":
        return ImagePath.buildingReq3;
      case "4":
        return ImagePath.buildingReq4;
      case "5":
        return ImagePath.buildingReq5;
      case "6":
        return ImagePath.buildingReq6;
      case "7":
        return ImagePath.buildingReq7;
      case "8":
        return ImagePath.buildingReq8;
      case "9":
        return ImagePath.buildingReq9;
      case "10":
        return ImagePath.buildingReq10;
      case "11":
        return ImagePath.buildingReq11;
      case "12":
        return ImagePath.buildingReq12;
      case "13":
        return ImagePath.buildingReq13;
      case "14":
        return ImagePath.buildingReq14;
      case "15":
        return ImagePath.buildingReq15;
      case "16":
        return ImagePath.buildingReq16;
      case "17":
        return ImagePath.buildingReq17;
      case "18":
        return ImagePath.buildingReq18;
      case "19":
        return ImagePath.buildingReq19;
      default:
        return "";
    }
  }
}
