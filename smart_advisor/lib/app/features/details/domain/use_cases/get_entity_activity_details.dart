import '/app/features/details/domain/entities/entity_activity_details_request_params.dart';
import '/app/features/details/domain/entities/entity_activity_details_response.dart';
import '/app/features/details/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;

class GetEntityActivityDetailssUc extends UseCase<EntityActivityDetailsResponse,
    EntityActivityDetailRequestParams> {
  final DetailsRepository repository;

  GetEntityActivityDetailssUc({required this.repository});

  @override
  Future<Either<Failure, EntityActivityDetailsResponse>> call(
      EntityActivityDetailRequestParams params) async {
    return await repository.getEntityActivity(params);
  }
}
