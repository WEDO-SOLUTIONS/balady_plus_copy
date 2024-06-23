import 'package:dartz/dartz.dart' show Either;
import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../../_shared_feature_/shared_feature_exports.dart';

import '../entity/construction_license_inquery_data_entity.dart';
import '../repository/repository.dart';

class GetConstructionLicenseInqueryData
    extends UseCase<ResponseBodyModel<ConstructionLicenseData>, (int, String)> {
  final ConstructionLicenseInqueryRepository repository;

  GetConstructionLicenseInqueryData({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<ConstructionLicenseData>>> call(
      (int, String) params) async {
    return await repository.getLicenseData(params.$1, params.$2);
  }
}
