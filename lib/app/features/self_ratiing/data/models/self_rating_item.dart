// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:balady_plus/app/core/utils/constants/remote_config.dart';
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
    final imagePathRemote = '${RemoteConfig.baladyBaseUrl}/BaladyCDN/Mobile/';
    switch (image) {
      case "1":
        return '${imagePathRemote}compliance/building/1.png';
      case "2":
        return '${imagePathRemote}compliance/building/2.png';
      case "3":
        return '${imagePathRemote}compliance/building/3.png';
      case "4":
        return '${imagePathRemote}compliance/building/4.png';
      case "5":
        return '${imagePathRemote}compliance/building/5.png';
      case "6":
        return '${imagePathRemote}compliance/building/6.png';
      case "7":
        return '${imagePathRemote}compliance/building/7.png';
      case "8":
        return '${imagePathRemote}compliance/building/8.png';
      case "9":
        return '${imagePathRemote}compliance/building/9.png';
      case "10":
        return '${imagePathRemote}compliance/building/10.png';
      case "11":
        return '${imagePathRemote}compliance/building/11.png';
      case "12":
        return '${imagePathRemote}compliance/building/12.png';
      case "13":
        return '${imagePathRemote}compliance/building/13.png';
      case "14":
        return '${imagePathRemote}compliance/building/14.png';
      case "15":
        return '${imagePathRemote}compliance/building/15.png';
      case "16":
        return '${imagePathRemote}compliance/building/16.png';
      case "17":
        return '${imagePathRemote}compliance/building/17.png';
      case "18":
        return '${imagePathRemote}compliance/building/18.png';
      case "19":
        return '${imagePathRemote}compliance/building/19.png';
      default:
        return "";
    }
  }
}
