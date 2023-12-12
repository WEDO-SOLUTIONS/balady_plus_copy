import 'package:balady_plus/app/features/objections/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/use_case.dart';
import '../../data/models/allowed_actions_response.dart';
import '../../data/models/permits_alerts_response.dart';
import '../repositores/repository.dart';

class GetPermitsAlerts extends UseCase<PermitTobaccoAlertsResponse, NoParams> {
  final PermitsTobaccoRepository repository;
  GetPermitsAlerts({required this.repository});
  @override
  Future<Either<Failure, PermitTobaccoAlertsResponse>> call(
      NoParams params) async {
    return await repository.getPermitsAlerts();
  }
}
