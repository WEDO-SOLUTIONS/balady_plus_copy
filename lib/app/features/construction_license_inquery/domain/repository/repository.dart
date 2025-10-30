import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../_shared_feature_/data/models/response_body_model.dart';
import '../entity/construction_license_inquery_data_entity.dart';

abstract class ConstructionLicenseInqueryRepository {
  Future<Either<Failure, ResponseBodyModel<ConstructionLicenseData>>>
      getLicenseData(int licenseNumber, String date);
}
