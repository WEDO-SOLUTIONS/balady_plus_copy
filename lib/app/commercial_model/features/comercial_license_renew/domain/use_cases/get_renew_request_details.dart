import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../data/models/renew_request_details.dart';
import '../../renew_commercial_license_exports.dart' show RenewCrRepository;

class GetRenewRequestDetails extends UseCase<RenewRequestDetails, int> {
  final RenewCrRepository repository;

  GetRenewRequestDetails({required this.repository});
  @override
  Future<Either<Failure, RenewRequestDetails>> call(int params) async {
    return await repository.getRequestDetails(params: params);
  }
}
