import '/app/features/_shared_feature_/domain/entities/lookUp_response.dart';
import '/app/features/select_activity/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show NoParams, UseCase;

class GetDistrictsUc extends UseCase<List<LookUpItem>, int> {
  final ActivitesRepository repository;

  GetDistrictsUc({required this.repository});

  @override
  Future<Either<Failure, List<LookUpItem>>> call(int params) async {
    return await repository.getDistricts(params);
  }
}
