import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/features/events/domain/entities/events_category/event_category_response.dart';
import 'package:balady_plus/app/features/events/domain/entities/events_category/events_category_params.dart';
import 'package:balady_plus/app/features/events/domain/entities/events_details/event_details_item.dart';
import 'package:balady_plus/app/features/events/domain/entities/events_details/event_details_params.dart';
import 'package:balady_plus/app/features/events/domain/entities/search_events/search_events_params.dart';
import 'package:balady_plus/app/features/events/domain/entities/search_events/search_events_response.dart';
import 'package:dartz/dartz.dart';

abstract class EventRepository {
  Future<Either<Failure, SearchEventsResponse>> getSearchEvents({required SearchEventsParams params});

  Future<Either<Failure, EventDetailsResponse>> getEventDetails({required EventDetailsParams params});

  Future<Either<Failure, EventCategoryResponse>> getEventCategory({required EventsCategoryParams params});
}
