import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../commercial_license_exports.dart';

class GetSubActivities extends UseCase<List<SubActivityEntity>, String> {
  final CrRepository repository;

  GetSubActivities({required this.repository});
  @override
  Future<Either<Failure, List<SubActivityEntity>>> call(String params) async {
    return await repository.getSubActivities(isicCode: params);
  }
}
