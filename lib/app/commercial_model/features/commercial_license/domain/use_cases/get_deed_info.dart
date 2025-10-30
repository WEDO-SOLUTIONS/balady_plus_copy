import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../commercial_license_exports.dart'
    show DeedInfoResponse, DeedInfoRequest, CrRepository;

class GetDeedInfo extends UseCase<DeedInfoResponse, DeedInfoRequest> {
  final CrRepository repository;

  GetDeedInfo({required this.repository});
  @override
  Future<Either<Failure, DeedInfoResponse>> call(DeedInfoRequest params) async {
    return await repository.getDeedInfo(params);
  }
}
