/*import 'package:dartz/dartz.dart' show Either;
import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../renew_commercial_license_exports.dart'
    show CleanContractsResponse, CleanContractsRequest, CrRepository;

class GetCleanContracts
    extends UseCase<CleanContractsResponse, CleanContractsRequest> {
  final CrRepository repository;

  GetCleanContracts({required this.repository});
  @override
  Future<Either<Failure, CleanContractsResponse>> call(
      CleanContractsRequest params) async {
    return await repository.getCleanContracts(params);
  }
}
*/