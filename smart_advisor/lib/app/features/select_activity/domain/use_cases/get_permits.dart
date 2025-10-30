import '/app/features/select_activity/domain/repositories/repository.dart';
import 'package:dartz/dartz.dart' show Either;

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../core/services/services_exports.dart' show UseCase;
import '../entities/addetional_activites_response.dart';
import '../entities/permit_request_params.dart';
import '../entities/permits_activites_response.dart';

class GetPermitsUc extends UseCase<List<PermitItem>, PermitRequestParams> {
  final ActivitesRepository repository;

  GetPermitsUc({required this.repository});

  @override
  Future<Either<Failure, List<PermitItem>>> call(
      PermitRequestParams params) async {
    return await repository.getPermits(params);
  }
}
