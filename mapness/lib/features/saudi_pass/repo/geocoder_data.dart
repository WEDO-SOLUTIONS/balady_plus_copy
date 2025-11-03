import 'package:json_annotation/json_annotation.dart';

part 'geocoder_data.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class GeocoderData {
  final Meta meta;
  final Result result;

  GeocoderData({required this.meta, required this.result});

  factory GeocoderData.fromJson(Map<String, dynamic> json) => _$GeocoderDataFromJson(json);

  Map<String, dynamic> toJson() => _$GeocoderDataToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Meta {
  final String apiVersion;
  final int code;
  final String issueDate;

  Meta({required this.apiVersion, required this.code, required this.issueDate});

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);

  Map<String, dynamic> toJson() => _$MetaToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Result {
  final Iterable<Item> items;
  final int total;

  Result({required this.items, required this.total});

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Item {
  final String fullName;
  final String id;
  final String name;
  final String subtype;
  final String type;

  Item({required this.fullName, required this.id, required this.name, required this.subtype, required this.type});

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
