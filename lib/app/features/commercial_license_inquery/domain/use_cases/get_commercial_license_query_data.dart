import 'package:dartz/dartz.dart' show Either;
import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../../_shared_feature_/shared_feature_exports.dart';

import '../entity/commercial_license_data_entity.dart';
import '../repository/repository.dart';

class GetCommercialLicenseQueryData
    extends UseCase<ResponseBodyModel<CommercialLicenseData>, (int, int)> {
  final CommercialLicenseQueryRepository repository;

  GetCommercialLicenseQueryData({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<CommercialLicenseData>>> call(
      (int, int) params) async {
    return await repository.getCommercialLicenseData(params.$1, params.$2);
  }
}
