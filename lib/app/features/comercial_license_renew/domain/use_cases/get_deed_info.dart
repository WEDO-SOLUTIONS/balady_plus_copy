/*import 'package:dartz/dartz.dart' show Either;
import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../renew_commercial_license_exports.dart'
    show DeedInfoResponse, DeedInfoRequest, CrRepository;

class GetDeedInfo extends UseCase<DeedInfoResponse, DeedInfoRequest> {
  final CrRepository repository;

  GetDeedInfo({required this.repository});
  @override
  Future<Either<Failure, DeedInfoResponse>> call(DeedInfoRequest params) async {
    return await repository.getDeedInfo(params);
  }
}
*/