import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_exports.dart' show Failure;
import '../../../objections/domain/entities/objection_details.dart';
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
import '../entities/enquiry_objection_reply_params.dart';
import '../entities/objection_enquiry_details.dart';
import '../entities/transaction_details.dart';
import '../entities/transaction_details_params.dart';
import '../entities/validate_objection_params.dart';

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

      Future<Either<Failure, UploadFileResponse>> uploadFileV2(
      {required UploadFileParams params});

  Future<Either<Failure, CreateObjectionResponse>> createObjection(
      {required CreateObjectionParams params});

  Future<Either<Failure, ObjectionDetails>> getObjectionDetails(String id);

  Future<Either<Failure, TransactionDetails>> getTransactionDetails(
      TransactionDetailsParams params);

  Future<Either<Failure, bool>> validateObjectableTransaction(
      ValidateObjectionParams params);

  Future<Either<Failure, ObjectionEnquiryDetails>> getEnquiryObjectionDetails(
      String id);

  Future<Either<Failure, dynamic>> replyEnquiryObjectionDetails(
      EnquiryObjectionReplyDetails request);
}
