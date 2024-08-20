/*import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../renew_commercial_license_exports.dart'
    show RnewCrRepository, CrCalculateFeesResponse, CrCalculateFeesRequest;

class CrCalculateFees
    extends UseCase<CrCalculateFeesResponse, CrCalculateFeesRequest> {
  final RnewCrRepository repository;

  CrCalculateFees({required this.repository});
  @override
  Future<Either<Failure, CrCalculateFeesResponse>> call(
      CrCalculateFeesRequest params) async {
    return await repository.crCalculateFee(params: params);
  }
}
*/
