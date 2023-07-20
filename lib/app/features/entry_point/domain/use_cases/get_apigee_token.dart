import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase, NoParams;
import '../../entry_point_exports.dart';

class GetAPIgeeToken extends UseCase<ApigeeTokenResponse, NoParams> {
  final EntryPointRepository repository;

  GetAPIgeeToken({required this.repository});
  @override
  Future<Either<Failure, ApigeeTokenResponse>> call(NoParams params) async {
    return await repository.getAPIgeeToken();
  }
}
