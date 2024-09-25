import 'package:dartz/dartz.dart' show Either;
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../commercial_license_exports.dart';
import '../../data/models/salama_warning_request.dart';

class GetWarningMessage extends UseCase<String, SalamaWarningRequest> {
  final CrRepository repository;

  GetWarningMessage({required this.repository});
  @override
  Future<Either<Failure, String>> call(SalamaWarningRequest params) async {
    return await repository.getWarningMessage(params: params);
  }
}
