import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../../../../features/_shared_feature_/data/models/response_body_model.dart';
import '../../commercial_license_exports.dart';
import '../../data/models/initialApproval/save_activity_and_location_response_model.dart';

class SaveActivityDetails extends UseCase<ResponseBodyModel<SaveActivityAndLocationResponseModel>, SubmitActivityDetailRequest> {
  final Repository repository;

  SaveActivityDetails({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<SaveActivityAndLocationResponseModel>>> call(SubmitActivityDetailRequest params) async {
    return await repository.saveActivityDetails(params);
  }
}
