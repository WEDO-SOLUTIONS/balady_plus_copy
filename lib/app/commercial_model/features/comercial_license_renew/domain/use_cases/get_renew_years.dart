import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../../../../features/_shared_feature_/data/models/response_body_model.dart';
import '../../renew_commercial_license_exports.dart' show RenewCrRepository;

class GetRenewYears extends UseCase<ResponseBodyModel<List<int>>, int> {
  final RenewCrRepository repository;

  GetRenewYears({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<List<int>>>> call(int params) async {
    return await repository.getRenewYears(params: params);
  }
}
