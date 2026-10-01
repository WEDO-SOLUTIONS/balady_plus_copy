import 'package:json_annotation/json_annotation.dart';

enum PlaceType {
  @JsonValue('POI')
  poi,
  @JsonValue('BUILDING')
  building;

  String get apiValue => switch (this) {
    PlaceType.poi => 'POI',
    PlaceType.building => 'BUILDING',
  };
}
