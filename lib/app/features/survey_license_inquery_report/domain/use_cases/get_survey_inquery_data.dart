import 'package:dartz/dartz.dart' show Either;
import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../../_shared_feature_/shared_feature_exports.dart';

import '../entity/survey_inquery_data_entity.dart';
import '../repository/repository.dart';

class GetSurveyInqueryData
    extends UseCase<ResponseBodyModel<SurveyInqueryData>, (int, String)> {
  final SurveyInqueryRepository repository;

  GetSurveyInqueryData({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<SurveyInqueryData>>> call(
      (int, String) params) async {
    return await repository.getLicenseData(params.$1, params.$2);
  }
}
