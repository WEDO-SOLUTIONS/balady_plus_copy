import 'package:json_annotation/json_annotation.dart';
import 'package:mapness/entities/road_events/dto/road_event_location_dto.dart';
import 'package:mapness/features/road_events/domain/road_event.dart';

part 'create_road_event_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class CreateRoadEventRequestDto {
  const CreateRoadEventRequestDto({
    required this.eventType,
    required this.location,
    required this.affectedLanes,
    required this.source,
  });

  factory CreateRoadEventRequestDto.fromDomain({
    required RoadEventType type,
    required RoadEventLocation location,
    required Set<RoadEventLane> lanes,
    required String source,
  }) => CreateRoadEventRequestDto(
    eventType: type.apiValue,
    location: RoadEventLocationDto(lat: location.latitude, lng: location.longitude),
    affectedLanes: lanes.map((lane) => lane.apiValue).toList(),
    source: source,
  );

  final String eventType;
  final RoadEventLocationDto location;
  final List<String> affectedLanes;
  final String source;

  Map<String, dynamic> toJson() => _$CreateRoadEventRequestDtoToJson(this);
}
