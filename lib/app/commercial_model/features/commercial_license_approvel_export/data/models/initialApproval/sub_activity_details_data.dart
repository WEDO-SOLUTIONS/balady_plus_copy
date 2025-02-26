import '../../../../../../features/_shared_feature_/data/entities/drop_down_item.dart';

class SubActivityDetailsData {
  SubActivityDetailsData({
      this.allowedActivities, 
      this.maxArea, 
      this.maxYears, 
      this.minArea, 
      this.minYears, 
      this.showAreaSection, 
      this.showAtmSection, 
      this.showHotelSection, 
      this.workerTypes,});

  SubActivityDetailsData.fromJson(dynamic json) {
    if (json['allowedActivities'] != null) {
      allowedActivities = [];
      json['allowedActivities'].forEach((v) {
        allowedActivities?.add(AllowedActivities.fromJson(v));
      });
    }

    maxArea = json['maxArea'];
    maxYears = json['maxYears'];
    minArea = json['minArea'];
    minYears = json['minYears'];
    showAreaSection = json['showAreaSection'];
    showAtmSection = json['showAtmSection'];
    showHotelSection = json['showHotelSection'];
    if (json['workerTypes'] != null) {
      workerTypes = [];
      json['workerTypes'].forEach((v) {
        workerTypes?.add(WorkerTypes.fromJson(v));
      });
    }
  }
  List<AllowedActivities>? allowedActivities;
  double? maxArea;
  double? minArea;
  int? maxYears;
  int? minYears;
  bool? showAreaSection;
  bool? showAtmSection;
  bool? showHotelSection;
  List<WorkerTypes>? workerTypes;
SubActivityDetailsData copyWith({  List<AllowedActivities>? allowedActivities,
  double? maxArea,
  int? maxYears,
  double? minArea,
  int? minYears,
  bool? showAreaSection,
  bool? showAtmSection,
  bool? showHotelSection,
  List<WorkerTypes>? workerTypes,
}) => SubActivityDetailsData(  allowedActivities: allowedActivities ?? this.allowedActivities,
  maxArea: maxArea ?? this.maxArea,
  maxYears: maxYears ?? this.maxYears,
  minArea: minArea ?? this.minArea,
  minYears: minYears ?? this.minYears,
  showAreaSection: showAreaSection ?? this.showAreaSection,
  showAtmSection: showAtmSection ?? this.showAtmSection,
  showHotelSection: showHotelSection ?? this.showHotelSection,
  workerTypes: workerTypes ?? this.workerTypes,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (allowedActivities != null) {
      map['allowedActivities'] = allowedActivities?.map((v) => v.toJson()).toList();
    }
    map['maxArea'] = maxArea;
    map['maxYears'] = maxYears;
    map['minArea'] = minArea;
    map['minYears'] = minYears;
    map['showAreaSection'] = showAreaSection;
    map['showAtmSection'] = showAtmSection;
    map['showHotelSection'] = showHotelSection;
    if (workerTypes != null) {
      map['workerTypes'] = workerTypes?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class WorkerTypes {
  int? id;
  String? name;
  WorkerTypes({
      this.id, 
      this.name,});

  WorkerTypes.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }

WorkerTypes copyWith({  int? id,
  String? name,
}) => WorkerTypes(  id: id ?? this.id,
  name: name ?? this.name,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }

}

class AllowedActivities extends DropDownItem {
  final int? isicCode;
  final String? isicName;

  AllowedActivities({
    this.isicCode,
    this.isicName,
  }) : super(
    id: isicCode ?? '',
    name: isicName ?? '',
  );

  factory AllowedActivities.fromJson(Map<String, dynamic> json) =>
      AllowedActivities(
        isicCode: json["id"],
        isicName: json["name"],
      );

  Map<String, dynamic> toJson() => {
    "id": isicCode,
    "name": isicName,
  };
}


