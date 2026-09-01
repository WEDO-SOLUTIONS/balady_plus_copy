import 'package:dio/dio.dart';
import 'package:mapness/entities/road_events/dto/create_road_event_request_dto.dart';
import 'package:mapness/entities/road_events/dto/road_event_feedback_request_dto.dart';
import 'package:mapness/entities/road_events/dto/road_event_response_dto.dart';
import 'package:mapness/features/road_events/domain/road_event.dart';
import 'package:uuid/uuid.dart';

class RoadEventsBbox {
  const RoadEventsBbox({required this.minLng, required this.minLat, required this.maxLng, required this.maxLat});

  final double minLng;
  final double minLat;
  final double maxLng;
  final double maxLat;

  String get queryValue => '$minLng,$minLat,$maxLng,$maxLat';
}

class RoadEventsChangesPage {
  const RoadEventsChangesPage({required this.upserts, required this.removedIds, this.nextCursor});

  final List<RoadEvent> upserts;
  final List<String> removedIds;
  final String? nextCursor;
}

class RoadEventsDatasource {
  RoadEventsDatasource({required this.dio});

  final Dio dio;

  Future<RoadEvent> createEvent({
    required RoadEventType type,
    required RoadEventLocation location,
    required Set<RoadEventLane> lanes,
    required String source,
  }) async {
    final clientReportId = const Uuid().v4();
    final response = await dio.post<Map<String, dynamic>>(
      '/events',
      data: CreateRoadEventRequestDto.fromDomain(
        type: type,
        location: location,
        lanes: lanes,
        source: source,
      ).toJson(),
      options: Options(headers: {'x-client-report-id': clientReportId}),
    );

    final eventJson = response.data?['event'] as Map<String, dynamic>?;
    final event = eventJson != null ? RoadEventResponseDto.fromJson(eventJson) : null;
    if (event == null) {
      throw Exception('createEvent: malformed response');
    }
    return event.toDomain();
  }

  Future<void> submitFeedback({
    required String eventId,
    required RoadEventActionType type,
    required RoadEventLocation location,
    required String source,
  }) async {
    await dio.post<dynamic>(
      '/events/$eventId/feedback',
      data: RoadEventFeedbackRequestDto.fromDomain(type: type, location: location, source: source).toJson(),
    );
  }

  Future<RoadEvent?> fetchById(String eventId, {RoadEventLocation? callerLocation}) async {
    final response = await dio.get<Map<String, dynamic>>(
      '/events/$eventId',
      queryParameters: {
        if (callerLocation != null) 'lat': callerLocation.latitude,
        if (callerLocation != null) 'lon': callerLocation.longitude,
      },
    );
    final json = response.data;
    return json != null ? RoadEventResponseDto.fromJson(json)?.toDomain() : null;
  }

  Future<List<RoadEvent>> fetchByBbox({
    required RoadEventsBbox bbox,
    int limit = 500,
    CancelToken? cancelToken,
  }) async {
    final response = await dio.get<Map<String, dynamic>>(
      '/events',
      queryParameters: {'bbox': bbox.queryValue, 'limit': limit},
      cancelToken: cancelToken,
    );
    final items = response.data?['events'] as List? ?? const [];
    return items
        .whereType<Map<String, dynamic>>()
        .map(RoadEventResponseDto.fromJson)
        .whereType<RoadEventResponseDto>()
        .map((dto) => dto.toDomain())
        .toList();
  }

  Future<RoadEventsChangesPage> fetchChanges({String? cursor, int limit = 100, CancelToken? cancelToken}) async {
    final response = await dio.get<Map<String, dynamic>>(
      '/events/changes',
      queryParameters: {if (cursor != null) 'cursor': cursor, 'limit': limit},
      cancelToken: cancelToken,
    );
    final data = response.data ?? const {};
    final changes = data['changes'] as List? ?? const [];

    final upserts = <RoadEvent>[];
    final removedIds = <String>[];
    for (final raw in changes) {
      if (raw is! Map<String, dynamic>) {
        continue;
      }
      final op = raw['op'] as String?;
      if (op == 'remove') {
        final id = raw['id'] as String?;
        if (id != null) {
          removedIds.add(id);
        }
        continue;
      }
      final eventJson = raw['event'] as Map<String, dynamic>? ?? raw;
      final event = RoadEventResponseDto.fromJson(eventJson)?.toDomain();
      if (event != null) {
        upserts.add(event);
      }
    }

    return RoadEventsChangesPage(upserts: upserts, removedIds: removedIds, nextCursor: data['nextCursor'] as String?);
  }

  Future<List<RoadEvent>> fetchAlongRoute({
    required List<RoadEventLocation> routeGeometry,
    double corridorMeters = 100,
    double travelledMeters = 0,
    int limit = 50,
    CancelToken? cancelToken,
  }) async {
    final response = await dio.post<Map<String, dynamic>>(
      '/events/along-route',
      data: {
        'routeGeometry': routeGeometry.map((p) => {'lat': p.latitude, 'lon': p.longitude}).toList(),
        'corridorMeters': corridorMeters,
        'travelledMeters': travelledMeters,
        'limit': limit,
      },
      cancelToken: cancelToken,
    );
    final items = response.data?['events'] as List? ?? const [];
    return items
        .whereType<Map<String, dynamic>>()
        .map(RoadEventResponseDto.fromJson)
        .whereType<RoadEventResponseDto>()
        .map((dto) => dto.toDomain())
        .toList();
  }
}
