import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import 'package:balady_plus/app/features/events/domain/entities/search_events/search_events_params.dart';
import 'package:balady_plus/app/features/events/domain/entities/search_events/search_events_response.dart';
import 'package:balady_plus/app/features/events/domain/repository/events_repository.dart';
import 'package:dartz/dartz.dart';

class GetSearchEvents extends UseCase<SearchEventsResponse, SearchEventsParams> {
  final EventRepository repository;
  GetSearchEvents({required this.repository});

  @override
  Future<Either<Failure, SearchEventsResponse>> call(SearchEventsParams params) async {
    return await repository.getSearchEvents(params: params);
  }
}
