import 'package:dartz/dartz.dart' show Either;

import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../../../../../features/_shared_feature_/data/models/response_body_model.dart';
import '../entity/permits_response_entity.dart';
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
