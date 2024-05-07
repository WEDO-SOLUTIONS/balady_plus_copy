import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../_shared_feature_/data/models/response_body_model.dart';
import '../entity/survey_inquery_data_entity.dart';

abstract class SurveyInqueryRepository {
  Future<Either<Failure, ResponseBodyModel<SurveyInqueryData>>> getLicenseData(
      int licenseNumber, String date);
}
