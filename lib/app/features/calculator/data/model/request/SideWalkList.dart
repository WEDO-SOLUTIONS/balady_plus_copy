class SideWalkList {
  int? directionId;
  double? area;
  int? days;

  SideWalkList({this.directionId, this.area, this.days});

  factory SideWalkList.fromJson(Map<String, dynamic> json) =>
      _$SideWalkListFromJson(json);

  Map<String, dynamic> toJson() => _$SideWalkListToJson(this);
}

SideWalkList _$SideWalkListFromJson(Map<String, dynamic> json) {
  return SideWalkList(
      directionId: json["DirectionId"], area: json["Area"], days: json["Days"]);
}

Map<String, dynamic> _$SideWalkListToJson(SideWalkList instance) =>
    <String, dynamic>{
      "DirectionId": instance.directionId,
      "Area": instance.area,
      "Days": instance.days
    };
