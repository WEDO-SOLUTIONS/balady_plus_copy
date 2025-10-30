import 'package:balady_plus/app/features/profile_features/requests/domain/entities/crm_request_params.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../../../../core/services/services_exports.dart' show UseCase;
import '../../requests_exports.dart' show RequestsRepository;
import '../entities/crm_request_entity.dart';

class GetCRMRequests extends UseCase<CRMRequestEntity, CRMRequestsParams> {
  final RequestsRepository repository;

  GetCRMRequests({required this.repository});

  @override
  Future<Either<Failure, CRMRequestEntity>> call(
      CRMRequestsParams params) async {
    return await repository.getCRMRequests(params);
  }
}
