import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../commercial_license_exports.dart';
import '../../data/models/initialApproval/conclusion_response_entity.dart';

class ReplyWithNote extends UseCase<bool, List<String>> {
  final Repository repository;

  ReplyWithNote({required this.repository});
  @override
  Future<Either<Failure, bool>> call(List<String> params) async {
    return await repository.ReplyWithNote( params[0],params[1],params[2]);
  }
}
