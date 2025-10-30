import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../commercial_license_exports.dart';

class ValidateAprovals extends UseCase<bool, int> {
  final CrRepository repository;

  ValidateAprovals({required this.repository});
  @override
  Future<Either<Failure, bool>> call(int params) async {
    return await repository.validateApprovals(params: params);
  }
}
