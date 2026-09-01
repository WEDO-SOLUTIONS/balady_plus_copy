import 'package:json_annotation/json_annotation.dart';
import 'package:mapness/features/road_events/domain/road_event.dart';

part 'road_event_location_dto.g.dart';

@JsonSerializable()
class RoadEventLocationDto {
  const RoadEventLocationDto({required this.lat, required this.lng, this.accuracyM});

  final double lat;
  final double lng;
  final double? accuracyM;

  factory RoadEventLocationDto.fromJson(Map<String, dynamic> json) => _$RoadEventLocationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RoadEventLocationDtoToJson(this);

  RoadEventLocation toDomain() => RoadEventLocation(latitude: lat, longitude: lng);
}
