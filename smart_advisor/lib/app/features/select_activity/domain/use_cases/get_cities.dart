import '/app/features/_shared_feature_/domain/entities/lookUp_response.dart';
import '/app/features/select_activity/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show NoParams, UseCase;

class GetCitiesUc extends UseCase<List<LookUpItem>, NoParams> {
  final ActivitesRepository repository;

  GetCitiesUc({required this.repository});

  @override
  Future<Either<Failure, List<LookUpItem>>> call(NoParams params) async {
    return await repository.getCities();
  }
}
