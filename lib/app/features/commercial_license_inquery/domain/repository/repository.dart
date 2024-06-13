import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../_shared_feature_/data/models/response_body_model.dart';
import '../entity/commercial_license_data_entity.dart';

abstract class CommercialLicenseQueryRepository {
  Future<Either<Failure, ResponseBodyModel<CommercialLicenseData>>>
      getCommercialLicenseData(int licenseNumber, int unifiedFacilityNumber);
}
