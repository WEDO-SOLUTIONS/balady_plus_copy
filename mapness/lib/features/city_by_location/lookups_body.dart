import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'momra_body.dart';

part 'lookups_body.g.dart';

@noRenameNoToJson
class LookupsBody extends MomraBody<Lookups, LookupsData> {
  LookupsBody({required super.statusDetails, super.data});

  factory LookupsBody.fromJson(Map<String, dynamic> json) => _$LookupsBodyFromJson(json);
}

@noRenameNoToJson
class LookupsData extends Data<Lookups> {
  LookupsData({
    required super.result,
    required super.responseCode,
    required super.responseMessage,
    required super.responseId,
  });

  factory LookupsData.fromJson(Map<String, dynamic> json) => _$LookupsDataFromJson(json);
}

@noRenameNoToJson
class Lookups {
  final Iterable<City> cities;

  Lookups({
    required this.cities,
  });

  factory Lookups.fromJson(Map<String, dynamic> json) => _$LookupsFromJson(json);
}

@immutable
@noRenameNoToJson
class NameId {
  final String id;
  final String name;

  const NameId({required this.id, required this.name});

  NameId._fromInstance(NameId nameId)
      : id = nameId.id,
        name = nameId.name;

  @override
  bool operator ==(covariant NameId other) =>
      identical(this, other) || runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => '{id: $id, name: $name}';
}

class City extends NameId {
  const City({required super.id, required super.name});

  City.fromJson(Map<String, dynamic> json) : super._fromInstance(_$NameIdFromJson(json));
}
