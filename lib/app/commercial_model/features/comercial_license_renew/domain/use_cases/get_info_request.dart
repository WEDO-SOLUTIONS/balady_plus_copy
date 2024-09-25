import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../renew_commercial_license_exports.dart'
    show RenewInfoRequest, RenewCrRepository, RenewRequestInfo;

class CalculateRequestInfo extends UseCase<RenewRequestInfo, RenewInfoRequest> {
  final RenewCrRepository repository;

  CalculateRequestInfo({required this.repository});
  @override
  Future<Either<Failure, RenewRequestInfo>> call(
      RenewInfoRequest params) async {
    return await repository.calculateRequestInfo(params: params);
  }
}
