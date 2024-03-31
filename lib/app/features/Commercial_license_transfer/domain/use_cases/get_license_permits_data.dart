import 'package:balady_plus/app/features/Commercial_license_transfer/domain/entity/permits_response_entity.dart';
import 'package:dartz/dartz.dart' show Either;
import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../../_shared_feature_/shared_feature_exports.dart';
import '../repository/repository.dart';

class GetLicensePermitsData
    extends UseCase<ResponseBodyModel<PermitsResponseEntity>, (String,)> {
  final TransferLicenseRepository repository;

  GetLicensePermitsData({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<PermitsResponseEntity>>> call(
      (String,) params) async {
    return await repository.getLicensePermits(params.$1);
  }
}
