import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../commercial_license_exports.dart';
import '../../data/models/additional_activity_response.dart';

class GetAddetionalActivites
    extends UseCase<AddetionalActivityResponse, String> {
  final CrRepository repository;

  GetAddetionalActivites({required this.repository});
  @override
  Future<Either<Failure, AddetionalActivityResponse>> call(
      String params) async {
    return await repository.getAddetionalActivites(subActivityId: params);
  }
}
