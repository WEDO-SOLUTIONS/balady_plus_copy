import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../commercial_license_exports.dart';


class InitialApprovalSubmit
    extends UseCase<SubmitRequestResponseModel, int> {
  final Repository repository;

  InitialApprovalSubmit({required this.repository});
  @override
  Future<Either<Failure, SubmitRequestResponseModel>> call(
      int params) async {
    return await repository.submitInitialApproval(params);
  }
}
