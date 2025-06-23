import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../commercial_license_exports.dart';
import '../../data/models/initialApproval/conclusion_response_entity.dart';

class CancelIntialApproval extends UseCase<bool, int> {
  final Repository repository;

  CancelIntialApproval({required this.repository});
  @override
  Future<Either<Failure, bool>> call(int params) async {
    return await repository.cancelIntialApproval(params: params);
  }
}
