import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/features/balady_calender/data/models/events_count_in_months/months_events_count.dart';
import 'package:balady_plus/app/features/balady_calender/data/models/events_count_in_years/events_count_in_years_response.dart';
import 'package:balady_plus/app/features/balady_calender/data/models/events_details/list_events_details.dart';
import 'package:balady_plus/app/features/balady_calender/data/models/filter/filter_response.dart';
import 'package:balady_plus/app/features/balady_calender/domain/entities/events_common_params.dart';
import 'package:balady_plus/app/features/balady_calender/domain/entities/events_count_in_months_params.dart';
import 'package:balady_plus/app/features/balady_calender/domain/entities/events_details_params.dart';
import 'package:dartz/dartz.dart';

abstract class BaladyCalendarRepository {
  Future<Either<Failure, Filter>> getFilteredEvents();

  Future<Either<Failure, EventsCountInYears>> getEventsCountInYears(
      {required EventsCommonParams params});

  Future<Either<Failure, List<MonthsEventsCount>>> getEventsCountInMonths(
      {required EventsCountInMonthsParams params});

  Future<Either<Failure, EventsDetails>> getEventsDetails(
      {required EventsDetailsParams params});
}
