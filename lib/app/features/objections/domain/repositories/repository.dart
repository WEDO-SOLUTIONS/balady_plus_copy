import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../objections_exports.dart'
    show
        ObjectionEntity,
        RequestStatusEntity,
        RequestSubTypeEntity,
        RequestSubTypeParamsModel,
        RequestTypeEntity,
        ObjectionsRequestsPrams;
import '../entities/objection_details.dart';

abstract class RequestsRepository {
  Future<Either<Failure, List<ObjectionEntity>>> getObjectionRequests(
    ObjectionsRequestsPrams params,
  );
  Future<Either<Failure, List<RequestStatusEntity>>> getRequestStatuses();
  Future<Either<Failure, List<RequestTypeEntity>>> getRequestTypes();
  Future<Either<Failure, List<RequestSubTypeEntity>>> getRequestSubTypes(
    RequestSubTypeParamsModel params,
  );

  Future<Either<Failure, ObjectionDetails>> getObjectionDetails(String id);

  Future<Either<Failure, bool>> cancelObjection(String id);

  Future<Either<Failure, String>> getPermitURL(String id);
}
