import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../objections_exports.dart'
    show
        ObjectableTransactionsEntity,
        RequestStatusEntity,
        RequestSubTypeEntity,
        RequestSubTypeParamsModel,
        RequestTypeEntity,
        TransactionsRequestsPrams,
        UploadFileResponse,
        UploadFileParams,
        CreateObjectionResponse,
        CreateObjectionParams;

abstract class RequestsRepository {
  Future<Either<Failure, List<ObjectableTransactionsEntity>>>
      getObjectionRequests(
    TransactionsRequestsPrams params,
  );
  Future<Either<Failure, List<RequestStatusEntity>>> getRequestStatuses();
  Future<Either<Failure, List<RequestTypeEntity>>> getRequestTypes();
  Future<Either<Failure, List<RequestSubTypeEntity>>> getRequestSubTypes(
    RequestSubTypeParamsModel params,
  );

  Future<Either<Failure, UploadFileResponse>> uploadFile(
      {required UploadFileParams params});

  Future<Either<Failure, CreateObjectionResponse>> createObjection(
      {required CreateObjectionParams params});
}
