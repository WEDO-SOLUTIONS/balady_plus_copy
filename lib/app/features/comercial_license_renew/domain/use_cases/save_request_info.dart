import 'package:dartz/dartz.dart' show Either;
import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../renew_commercial_license_exports.dart' show RenewCrRepository;
import '../entities/save_renew_request.dart';

class SaveRenewRequestInfo extends UseCase<dynamic, SaveRenewRequest> {
  final RenewCrRepository repository;

  SaveRenewRequestInfo({required this.repository});
  @override
  Future<Either<Failure, dynamic>> call(SaveRenewRequest params) async {
    return await repository.saveRenewRequestInfo(params: params);
  }
}
