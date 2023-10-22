/*import 'package:dartz/dartz.dart' show Either;
import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../renew_commercial_license_exports.dart'
    show EjarInfoResponse, EjarInfoRequest, CrRepository;

class GetEjarInfo extends UseCase<EjarInfoResponse, EjarInfoRequest> {
  final CrRepository repository;

  GetEjarInfo({required this.repository});
  @override
  Future<Either<Failure, EjarInfoResponse>> call(EjarInfoRequest params) async {
    return await repository.getEjarInfo(params);
  }
}
*/