import '/app/features/_shared_feature_/domain/entities/lookUp_response.dart';
import '/app/features/select_activity/domain/entities/rubrics_request_params.dart';
import '/app/features/select_activity/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;

class GetRubricsUc extends UseCase<List<LookUpItem>, RubricsRequestParams> {
  final ActivitesRepository repository;

  GetRubricsUc({required this.repository});
//get_rubrics
  @override
  Future<Either<Failure, List<LookUpItem>>> call(
      RubricsRequestParams params) async {
    return await repository.getRubrics(params);
  }
}
