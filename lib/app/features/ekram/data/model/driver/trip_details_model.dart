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
    this.note,
    this.isSuggestPath

  });

  TripDetailsModel.fromJson(dynamic json) {
    id = json['id'];
    startupDate = json['startupDate'];
    createDate = json['createDate'];
    startupInfo = json['startupInfo'] != null ? TripInfo.fromJson(json['startupInfo']) : null;
    arrivalInfo = json['arrivalInfo'] != null ? TripInfo.fromJson(json['arrivalInfo']) : null;
    deletable = json['deletable'];
    editable = json['editable'];
    note = json['note'];
  }
  int? id;
  int? startupDate;
  String? createDate;
  TripInfo? startupInfo;
  TripInfo? arrivalInfo;
  bool? deletable;
  bool? editable;
  bool? isSuggestPath;
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


  TripDetailsModel copyWith({  int? id,
    int? startupDate,
    String? createDate,
    TripInfo? startupInfo,
    TripInfo? arrivalInfo,
    bool? deletable,
    bool? editable,
    dynamic note,
  }) {

    return  TripDetailsModel(id: id ?? this.id,
      startupDate: startupDate ?? this.startupDate,
      createDate: createDate ?? this.createDate,
      startupInfo: startupInfo ?? this.startupInfo,
      arrivalInfo: arrivalInfo ?? this.arrivalInfo,
      deletable: deletable ?? this.deletable,
      editable: editable ?? this.editable,
      note: note ?? this.note,
    );




  }


  @override
  List<Object?> get props => [
    id,
    startupDate,
    createDate,
    startupInfo,
    arrivalInfo,
   deletable,
   editable,
  note

  ];



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

class TripInfo {
  TripInfo({
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
    this.dateTime,
    this.openStationName,
  });

  TripInfo.fromJson(dynamic json) {
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
    openStationName = json['openStationName'];
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
  bool? openStationName;

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

  bool? isEditable()
  {
    openStationName ??= false;
    return openStationName;
    // if(typeId==30510||typeId==30509||typeId==30507||typeId==30506||typeId==30501) {
    //   return true;
    // }
    // else {
    //   return false;
    // }
  }


  @override
  List<Object?> get props => [
    id,
    name,
   categoryId,
   categoryKey,
   categoryName,
   typeId,
  typeName,
   cityId,
    cityName,
    date,
    time,
    openStationName,
   location,
   dateTime

  ];

  TripInfo copyWith({  int? id,
    String? name,
    int? categoryId,
    String? categoryKey,
    String? categoryName,
    int? typeId,
    String? typeName,
    int? cityId,
    String? cityName,
    String? date,
    String? time,
    Location? location,
    int? dateTime,
    bool? openStationName,
  }) {
   return
     TripInfo(id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      categoryKey: categoryKey ?? this.categoryKey,
      categoryName: categoryName ?? this.categoryName,
      typeId: typeId ?? this.typeId,
      typeName: typeName ?? this.typeName,
      cityId: cityId ?? this.cityId,
      cityName: cityName ?? this.cityName,
      date: date ?? this.date,
      time: time ?? this.time,
      location: location ?? this.location,
      dateTime: dateTime ?? this.dateTime,
       openStationName: openStationName ?? this.openStationName,
    );
  }

}


