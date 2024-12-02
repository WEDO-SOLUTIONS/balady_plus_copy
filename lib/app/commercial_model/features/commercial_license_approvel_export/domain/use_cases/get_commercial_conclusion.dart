import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../commercial_license_exports.dart';
import '../../data/models/conclusion_response_entity.dart';

class GetCommercialConclusion extends UseCase<IssueCommercialConculsionEntity, int> {
  final Repository repository;

  GetCommercialConclusion({required this.repository});
  @override
  Future<Either<Failure, IssueCommercialConculsionEntity>> call(int params) async {
    return await repository.getCommercialConculsion(params: params);
  }
}
