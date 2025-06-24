import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../../../../features/_shared_feature_/shared_feature_exports.dart';
import '../../commercial_license_exports.dart';
import '../../data/models/initialApproval/request_details_model.dart';

class getInitialApprovalRequestDetails
    extends UseCase<ResponseBodyModel<RequestDetailsModel>, int> {
  final Repository repository;

  getInitialApprovalRequestDetails({required this.repository});
  @override
  Future<Either<Failure, ResponseBodyModel<RequestDetailsModel>>> call(int params) async {
    return await repository.getInitialApprovalRequestDetails(params);
  }
}
