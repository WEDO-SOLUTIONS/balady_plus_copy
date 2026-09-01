import 'package:json_annotation/json_annotation.dart';
import 'package:mapness/entities/road_events/dto/road_event_location_dto.dart';
import 'package:mapness/features/road_events/domain/road_event.dart';

part 'road_event_feedback_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class RoadEventFeedbackRequestDto {
  const RoadEventFeedbackRequestDto({required this.verdict, required this.location, required this.source});

  factory RoadEventFeedbackRequestDto.fromDomain({
    required RoadEventActionType type,
    required RoadEventLocation location,
    required String source,
  }) => RoadEventFeedbackRequestDto(
    verdict: type.verdict,
    location: RoadEventLocationDto(lat: location.latitude, lng: location.longitude),
    source: source,
  );

  final String verdict;
  final RoadEventLocationDto location;
  final String source;

  Map<String, dynamic> toJson() => _$RoadEventFeedbackRequestDtoToJson(this);
}
