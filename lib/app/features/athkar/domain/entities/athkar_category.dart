// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

import 'athkar_entity.dart';

class AthkarCategory extends Equatable {
  final int id;
  final String name;
  final String icon;
  const AthkarCategory({
    required this.id,
    required this.name,
    required this.icon,
  });

  Future<List<AthkarEntity>> get athkarEntities async {
    List<AthkarEntity> g = [];

    String path = "";

    switch (id) {
      case 1:
        path = "assets/athkar/morning.json";
        break;
      case 2:
        path = "assets/athkar/before_sleep.json";
        break;

      case 3:
        path = "assets/athkar/evening.json";
        break;
      case 4:
        path = "assets/athkar/after_pray.json";
        break;

      case 5:
        path = "assets/athkar/praise.json";
        break;

      case 6:
        path = "assets/athkar/after_sleep.json";
        break;

      case 7:
        path = "assets/athkar/prayer.json";
        break;

      case 8:
        path = "assets/athkar/doaa.json";
        break;
    }
    String qa = await rootBundle.loadString(path);
    var r = json.decode(qa);
    try {
      g = r != null
          ? List<AthkarEntity>.from(r.map((x) => AthkarEntity.fromMap(x)))
          : [];
    } catch (ex) {
      print(ex);
    }

    return g;
  }

  @override
  List<Object?> get props => [name, icon, athkarEntities, id];
}
