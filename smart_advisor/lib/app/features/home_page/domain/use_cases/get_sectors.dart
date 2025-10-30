import '/app/features/_shared_feature_/domain/entities/lookUp_response.dart';
import '/app/features/select_activity/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show NoParams, UseCase;

class GetSectorUC extends UseCase<LookUpResponse, NoParams> {
  final ActivitesRepository repository;

  GetSectorUC({required this.repository});

  @override
  Future<Either<Failure, LookUpResponse>> call(NoParams) async {
    return await repository.getSectors();
  }
}
