import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/features/events/domain/entities/events_category/event_category_response.dart';
import 'package:balady_plus/app/features/events/domain/entities/events_category/events_category_params.dart';
import 'package:balady_plus/app/features/events/domain/repository/events_repository.dart';
import 'package:dartz/dartz.dart';

class GetCategory extends UseCase<EventCategoryResponse, EventsCategoryParams> {
  final EventRepository repository;

  GetCategory({required this.repository});

  @override
  Future<Either<Failure, EventCategoryResponse>> call(
      EventsCategoryParams params) async {
    return await repository.getEventCategory(params: params);
  }
}
