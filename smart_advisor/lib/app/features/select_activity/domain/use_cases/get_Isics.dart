import '/app/features/_shared_feature_/domain/entities/lookUp_response.dart';
import '/app/features/select_activity/domain/entities/isics_request_params.dart';
import '/app/features/select_activity/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;

class GetIsicsUc extends UseCase<List<LookUpItem>, IsicsRequestParams> {
  final ActivitesRepository repository;

  GetIsicsUc({required this.repository});

  @override
  Future<Either<Failure, List<LookUpItem>>> call(
      IsicsRequestParams params) async {
    return await repository.getIsics(params);
  }
}
