class IsicActivity {
  String? isicCode;
  String? isicName;
  bool? existInBalady;

  IsicActivity({this.isicCode, this.isicName, this.existInBalady});

  factory IsicActivity.fromJson(Map<String, dynamic> json) =>
      _$IsicActivityFromJson(json);

  Map<String, dynamic> toJson() => _$IsicActivityToJson(this);
}

IsicActivity _$IsicActivityFromJson(Map<String, dynamic> json) {
  return IsicActivity(
      isicCode: json["isicCode"],
      isicName: json["isicName"],
      existInBalady: json["existInBalady"]);
}

Map<String, dynamic> _$IsicActivityToJson(IsicActivity instance) =>
    <String, dynamic>{
      "isicCode": instance.isicCode,
      "isicName": instance.isicName,
      "existInBalady": instance.existInBalady,
    };
