import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/features/events/domain/entities/events_details/event_details_item.dart';
import 'package:balady_plus/app/features/events/domain/entities/events_details/event_details_params.dart';
//import 'package:balady_plus/app/features/events/domain/entities/events_details/events_details_response.dart';
import 'package:balady_plus/app/features/events/domain/repository/events_repository.dart';
import 'package:dartz/dartz.dart';

class GetEventDetails
    extends UseCase<EventDetailsResponse, EventDetailsParams> {
  final EventRepository repository;
  GetEventDetails({required this.repository});
  @override
  Future<Either<Failure, EventDetailsResponse>> call(
      EventDetailsParams params) async {
    return await repository.getEventDetails(params: params);
  }
}
