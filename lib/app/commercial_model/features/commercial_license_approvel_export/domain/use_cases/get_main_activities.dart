import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../commercial_license_exports.dart';
import '../../data/models/initialApproval/isics_main_activity.dart';

class GetMainActivities extends UseCase<List<IsicsMainActivity>, int> {
  final Repository repository;

  GetMainActivities({required this.repository});
  @override
  Future<Either<Failure, List<IsicsMainActivity>>> call(int params) async {
    return await repository.getMainActivities( params);
  }
}
