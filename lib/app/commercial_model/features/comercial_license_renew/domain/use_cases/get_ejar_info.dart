import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../renew_commercial_license_exports.dart'
    show RenewCrRepository, EjarInfoRequest, EjarInfoResponse;

class GetEjarInfo extends UseCase<EjarInfoResponse, EjarInfoRequest> {
  final RenewCrRepository repository;

  GetEjarInfo({required this.repository});
  @override
  Future<Either<Failure, EjarInfoResponse>> call(EjarInfoRequest params) async {
    return await repository.getEjarInfo(params);
  }
}
