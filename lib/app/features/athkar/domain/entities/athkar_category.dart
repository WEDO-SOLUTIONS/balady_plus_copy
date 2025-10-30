// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
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
        path = CommonFunctions.isAppAR
            ? "assets/athkar/morning.json"
            : "assets/athkar_en/morning.json";
        break;
      case 2:
        path = CommonFunctions.isAppAR
            ? "assets/athkar/before_sleep.json"
            : "assets/athkar_en/before_sleep.json";
        break;

      case 3:
        path = CommonFunctions.isAppAR
            ? "assets/athkar/evening.json"
            : "assets/athkar_en/evening.json";
        break;
      case 4:
        path = CommonFunctions.isAppAR
            ? "assets/athkar/after_pray.json"
            : "assets/athkar_en/after_pray.json";
        break;

      case 5:
        path = CommonFunctions.isAppAR
            ? "assets/athkar/praise.json"
            : "assets/athkar_en/praise.json";
        break;

      case 6:
        path = CommonFunctions.isAppAR
            ? "assets/athkar/after_sleep.json"
            : "assets/athkar_en/after_sleep.json";
        break;

      case 7:
        path = CommonFunctions.isAppAR
            ? "assets/athkar/prayer.json"
            : "assets/athkar_en/prayer.json";
        break;

      case 8:
        path = CommonFunctions.isAppAR
            ? "assets/athkar/doaa.json"
            : "assets/athkar_en/doaa.json";
        break;
    }
    String qa = await rootBundle.loadString(path);
    var r = json.decode(qa);
    try {
      g = r != null
          ? List<AthkarEntity>.from(r.map((x) => AthkarEntity.fromMap(x)))
          : [];
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
    }

    return g;
  }

  @override
  List<Object?> get props => [name, icon, athkarEntities, id];
}
