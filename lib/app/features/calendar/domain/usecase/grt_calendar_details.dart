import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
//import 'package:balady_plus/app/features/events/domain/entities/events_details/events_details_response.dart';
import 'package:dartz/dartz.dart';

import '../entities/search_calendar/calendar_details_response.dart';
import '../repository/events_repository.dart';

class GetCalendarDetails extends UseCase<CalendarDetailsResponse, String> {
  final CalendarRepository repository;
  GetCalendarDetails({required this.repository});
  @override
  Future<Either<Failure, CalendarDetailsResponse>> call(String params) async {
    return await repository.getEventDetails(params: params);
  }
}
