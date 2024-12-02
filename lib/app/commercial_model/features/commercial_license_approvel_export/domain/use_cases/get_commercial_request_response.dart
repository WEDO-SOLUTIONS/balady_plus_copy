import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../commercial_license_exports.dart';
import '../../data/models/commercial_request_details_response_entity.dart';

class GetCommercialRequestData
    extends UseCase<CommercialRequestDetailsResponseEntity, int> {
  final Repository repository;

  GetCommercialRequestData({required this.repository});
  @override
  Future<Either<Failure, CommercialRequestDetailsResponseEntity>> call(
      int params) async {
    return await repository.getRequestDetails(params: params);
  }
}
