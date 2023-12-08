import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import 'package:dartz/dartz.dart';

import '../entities/search_calendar/search_calendar_params.dart';
import '../entities/search_calendar/search_calendar_response.dart';
import '../repository/events_repository.dart';

class GetSearchEvents
    extends UseCase<SearchCalendarResponse, SearchCalendarParams> {
  final CalendarRepository repository;
  GetSearchEvents({required this.repository});

  @override
  Future<Either<Failure, SearchCalendarResponse>> call(
      SearchCalendarParams params) async {
    return await repository.getSearchEvents(params: params);
  }
}
