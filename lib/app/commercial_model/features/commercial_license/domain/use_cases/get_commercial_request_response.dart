import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../commercial_license_exports.dart';
import '../../data/models/commercial_request_details_response.dart';

class GetCommercialRequestData
    extends UseCase<CommercialRequestDetailsResponse, int> {
  final CrRepository repository;

  GetCommercialRequestData({required this.repository});
  @override
  Future<Either<Failure, CommercialRequestDetailsResponse>> call(
      int params) async {
    return await repository.getRequestDetails(params: params);
  }
}
