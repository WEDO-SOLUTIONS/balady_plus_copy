import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../../../../features/_shared_feature_/shared_feature_exports.dart';
import '../../commercial_license_exports.dart';
import '../../data/models/initialApproval/sub_activity_details_data.dart';

class GetSubActivityDetails
    extends UseCase<ResponseBodyModel<SubActivityDetailsData>, String> {
  final Repository repository;

  GetSubActivityDetails({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<SubActivityDetailsData>>> call(
      String params) async {
    return await repository.getSubActivityDetails(id: params);
  }
}
