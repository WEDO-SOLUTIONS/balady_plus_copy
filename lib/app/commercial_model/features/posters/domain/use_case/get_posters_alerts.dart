import 'package:dartz/dartz.dart' show Either;

import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import '../../data/models/permits_alerts_response.dart';
import '../repositores/repository.dart';

class GetPostersAlerts extends UseCase<PermitAlertsResponse, NoParams> {
  final PostersRepository repository;
  GetPostersAlerts({required this.repository});
  @override
  Future<Either<Failure, PermitAlertsResponse>> call(NoParams params) async {
    return await repository.getPermitsAlerts();
  }
}
