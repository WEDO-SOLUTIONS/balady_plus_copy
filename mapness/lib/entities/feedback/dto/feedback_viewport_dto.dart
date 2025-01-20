import 'package:dgis_map/library.dart';
import 'package:json_annotation/json_annotation.dart';

part 'feedback_viewport_dto.g.dart';

@JsonSerializable(createFactory: false)
class FeedbackViewportDto {
  final double zoom;
  final ViewportBound bound;

  const FeedbackViewportDto({
    required this.zoom,
    required this.bound,
  });

  Map<String, dynamic> toJson() => _$FeedbackViewportDtoToJson(this);

  factory FeedbackViewportDto.fromDomain(VisibleRect cameraViewport) => FeedbackViewportDto(
        zoom: cameraViewport.zoom,
        bound: ViewportBound(
          nw: LatLng(
            lat: cameraViewport.northEastLat,
            long: cameraViewport.southWestLon,
          ),
          se: LatLng(
            lat: cameraViewport.southWestLat,
            long: cameraViewport.northEastLon,
          ),
        ),
      );
}

@JsonSerializable(createFactory: false)
class ViewportBound {
  final LatLng nw;
  final LatLng se;

  const ViewportBound({
    required this.nw,
    required this.se,
  });

  Map<String, dynamic> toJson() => _$ViewportBoundToJson(this);
}

@JsonSerializable(createFactory: false)
class LatLng {
  final double lat;
  final double long;

  const LatLng({
    required this.lat,
    required this.long,
  });

  Map<String, dynamic> toJson() => _$LatLngToJson(this);
}
