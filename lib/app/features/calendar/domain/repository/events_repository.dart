import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/features/events/domain/entities/events_category/event_category_response.dart';
import 'package:balady_plus/app/features/events/domain/entities/events_category/events_category_params.dart';
import 'package:balady_plus/app/features/events/domain/entities/search_events/search_events_params.dart';
import 'package:dartz/dartz.dart';
import '../entities/search_calendar/calendar_details_response.dart';
import '../entities/search_calendar/search_calendar_params.dart';
import '../entities/search_calendar/search_calendar_response.dart';

abstract class CalendarRepository {
  Future<Either<Failure, SearchCalendarResponse>> getSearchEvents(
      {required SearchCalendarParams params});

  Future<Either<Failure, EventCategoryResponse>> getEventCategory(
      {required EventsCategoryParams params});

  Future<Either<Failure, CalendarDetailsResponse>> getEventDetails(
      {required String params});
}
