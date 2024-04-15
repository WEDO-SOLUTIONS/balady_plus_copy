import 'package:dartz/dartz.dart' show Either;

import '../../../../../core/errors/failures.dart';
import '../../../../../core/services/local/use_case.dart';
import '../../../../_shared_feature_/data/models/response_body_model.dart';
import '../entity/apply_request_entity.dart';
import '../entity/transfer_license_request.dart';
import '../entity/validate_owner_entity.dart';
import '../repository/repository.dart';

class PostToNewOwner extends UseCase<ResponseBodyModel<ApplyRequestEntity>,
    (String, TransferLicenseRequest)> {
  final TransferLicenseRepository repository;

  PostToNewOwner({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<ApplyRequestEntity>>> call(
      (String, TransferLicenseRequest) params) async {
    return await repository.sendToNewOwner(params.$1, params.$2);
  }
}
