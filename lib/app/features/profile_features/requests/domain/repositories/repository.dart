import 'package:dartz/dartz.dart';

import '../../../../../core/errors/errors_exports.dart' show Failure;
import '../../data/models/crm_requests_params_model.dart';
import '../../requests_exports.dart'
    show
        MunicipalityEntity,
        RequestEntity,
        RequestStatusEntity,
        RequestSubTypeEntity,
        RequestSubTypeParamsModel,
        RequestTypeEntity,
        RequestsPrams,
        SubMunicipalityEntity,
        SubMunicipalityParamsModel;
import '../entities/crm_request_entity.dart';

abstract class RequestsRepository {
  Future<Either<Failure, List<RequestEntity>>> getRequests(
    RequestsPrams params,
  );
  Future<Either<Failure, List<RequestStatusEntity>>> getRequestStatuses();
  Future<Either<Failure, List<MunicipalityEntity>>> getMunicipalities();
  Future<Either<Failure, List<SubMunicipalityEntity>>> getSubMunicipalities(
    SubMunicipalityParamsModel params,
  );
  Future<Either<Failure, List<RequestTypeEntity>>> getRequestTypes();
  Future<Either<Failure, List<RequestSubTypeEntity>>> getRequestSubTypes(
    RequestSubTypeParamsModel params,
  );

  Future<Either<Failure, CRMRequestEntity>> getCRMRequests(
    CRMRequestsParamsModel params,
  );
}
