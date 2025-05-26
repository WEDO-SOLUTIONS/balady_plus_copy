import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../commercial_license_exports.dart';
import '../../data/models/conclusion_response_model.dart';

class GetCommercialConclusion extends UseCase<IssueCommercialConculsion, int> {
  final CrRepository repository;

  GetCommercialConclusion({required this.repository});
  @override
  Future<Either<Failure, IssueCommercialConculsion>> call(int params) async {
    return await repository.getCommercialConculsion(params: params);
  }
}
