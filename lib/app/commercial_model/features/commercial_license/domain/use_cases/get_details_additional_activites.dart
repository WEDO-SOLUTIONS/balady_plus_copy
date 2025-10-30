import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../commercial_license_exports.dart';
import '../../data/models/additional_activity_details_response.dart';
import '../entities/addetional_activity_details_request.dart';

class GetAddetionalDetailsActivites extends UseCase<
    AddetionalActivityDetailsResponse, AddetionalActivityDetailsRequest> {
  final CrRepository repository;

  GetAddetionalDetailsActivites({required this.repository});
  @override
  Future<Either<Failure, AddetionalActivityDetailsResponse>> call(
      AddetionalActivityDetailsRequest params) async {
    return await repository.getAddetionalDetailsActivites(params: params);
  }
}
