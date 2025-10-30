import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../renew_commercial_license_exports.dart' show RenewCrRepository;

class SubmitRenewAttachments extends UseCase<dynamic, int> {
  final RenewCrRepository repository;

  SubmitRenewAttachments({required this.repository});
  @override
  Future<Either<Failure, dynamic>> call(int params) async {
    return await repository.submitRenewAttachments(params: params);
  }
}
