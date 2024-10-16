import 'package:balady_plus/app/features/ekram/domain/entities/trip_details.dart';
import 'package:equatable/equatable.dart';
class TripDetailsModel {
  TripDetailsModel({
    this.id,
    this.startupDate,
    this.createDate,
    this.startupInfo,
    this.arrivalInfo,
    this.deletable,
    this.editable,
    this.note,});

  TripDetailsModel.fromJson(dynamic json) {
    id = json['id'];
    startupDate = json['startupDate'];
    createDate = json['createDate'];
    startupInfo = json['startupInfo'] != null ? StartupInfo.fromJson(json['startupInfo']) : null;
    arrivalInfo = json['arrivalInfo'] != null ? ArrivalInfo.fromJson(json['arrivalInfo']) : null;
    deletable = json['deletable'];
    editable = json['editable'];
    note = json['note'];
  }
  int? id;
  int? startupDate;
  String? createDate;
  StartupInfo? startupInfo;
  ArrivalInfo? arrivalInfo;
  bool? deletable;
  bool? editable;
  dynamic note;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['startupDate'] = startupDate;
    map['createDate'] = createDate;
    if (startupInfo != null) {
      map['startupInfo'] = startupInfo?.toJson();
    }
    if (arrivalInfo != null) {
      map['arrivalInfo'] = arrivalInfo?.toJson();
    }
    map['deletable'] = deletable;
    map['editable'] = editable;
    map['note'] = note;
    return map;
  }

}

class ArrivalInfo {
  ArrivalInfo({
    this.id,
    this.name,
    this.categoryId,
    this.categoryKey,
    this.categoryName,
    this.typeId,
    this.typeName,
    this.cityId,
    this.cityName,
    this.date,
    this.time,
    this.location,
    this.dateTime,});

  ArrivalInfo.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    categoryId = json['categoryId'];
    categoryKey = json['categoryKey'];
    categoryName = json['categoryName'];
    typeId = json['typeId'];
    typeName = json['typeName'];
    cityId = json['cityId'];
    cityName = json['cityName'];
    date = json['date'];
    time = json['time'];
    location = json['location'] != null ? Location.fromJson(json['location']) : null;
    dateTime = json['dateTime'];
  }
  int? id;
  String? name;
  int? categoryId;
  String? categoryKey;
  String? categoryName;
  int? typeId;
  String? typeName;
  int? cityId;
  String? cityName;
  String? date;
  String? time;
  Location? location;
  int? dateTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['categoryId'] = categoryId;
    map['categoryKey'] = categoryKey;
    map['categoryName'] = categoryName;
    map['typeId'] = typeId;
    map['typeName'] = typeName;
    map['cityId'] = cityId;
    map['cityName'] = cityName;
    map['date'] = date;
    map['time'] = time;
    if (location != null) {
      map['location'] = location?.toJson();
    }
    map['dateTime'] = dateTime;
    return map;
  }

}

class Location {
  Location({
    this.x,
    this.y,});

  Location.fromJson(dynamic json) {
    x = json['x'];
    y = json['y'];
  }
  String? x;
  String? y;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['x'] = x;
    map['y'] = y;
    return map;
  }

}

class StartupInfo {
  StartupInfo({
    this.id,
    this.name,
    this.categoryId,
    this.categoryKey,
    this.categoryName,
    this.typeId,
    this.typeName,
    this.cityId,
    this.cityName,
    this.date,
    this.time,
    this.location,
    this.dateTime,});

  StartupInfo.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    categoryId = json['categoryId'];
    categoryKey = json['categoryKey'];
    categoryName = json['categoryName'];
    typeId = json['typeId'];
    typeName = json['typeName'];
    cityId = json['cityId'];
    cityName = json['cityName'];
    date = json['date'];
    time = json['time'];
    location = json['location'] != null ? Location.fromJson(json['location']) : null;
    dateTime = json['dateTime'];
  }
  int? id;
  String? name;
  int? categoryId;
  String? categoryKey;
  String? categoryName;
  int? typeId;
  String? typeName;
  int? cityId;
  String? cityName;
  String? date;
  String? time;
  Location? location;
  int? dateTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['categoryId'] = categoryId;
    map['categoryKey'] = categoryKey;
    map['categoryName'] = categoryName;
    map['typeId'] = typeId;
    map['typeName'] = typeName;
    map['cityId'] = cityId;
    map['cityName'] = cityName;
    map['date'] = date;
    map['time'] = time;
    if (location != null) {
      map['location'] = location?.toJson();
    }
    map['dateTime'] = dateTime;
    return map;
  }

}


