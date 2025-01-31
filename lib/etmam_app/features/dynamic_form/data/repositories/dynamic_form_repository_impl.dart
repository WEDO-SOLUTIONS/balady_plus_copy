import 'package:balady_plus/etmam_app/core/errors/failures.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show ApigeeResponse, ProviderResponse;
import 'package:balady_plus/etmam_app/features/dynamic_form/data/models/form_data_response_model.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/bidding_type/bidding_type_response.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/form_data_response.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/get_data_params.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/offers/get_offers_params.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/offers/offers_response.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/submit/submit_form_response.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/submit/submit_form_params.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/validate/validate_form_response.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/validate/validate_form_params.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/dynamic_forms_exports.dart';
import 'package:dartz/dartz.dart' show Either, Left, Right;

import '../../../../../app/features/_shared_feature_/data/entities/drop_down_item.dart';
import '../../../../core/errors/errors_exports.dart'
    show Failure, ServerException, ServerFailure;
import 'package:balady_plus/app/events_logs/balady_logs.dart';


import 'package:balady_plus/app/core/errors/errors_exports.dart' as balday;

class DynamicFormsRepositoryImpl implements DynamicFormsRepository {
  final DynamicFormRemoteDataSource remoteDataSource;
  DynamicFormsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ApigeeResponse<List<CreateFormItemResponse>>>>
      createBiddingForm({required CreateFormParams params}) async {
    try {
      final data = await remoteDataSource.createForm(params: params);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ApigeeResponse<List<DropDownItem>>>> getFormFieldData(
      {required GetDataParams params}) async {
    try {
      final data = await remoteDataSource.getFormFieldData(params: params);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    } on balday.NoInternetConnectionException  catch (error, stackTrace) {
      return Left(NoInternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, ApigeeResponse<List<BiddingTypeResponse>>>>
      findByRequestType() async {
    try {
      final data = await remoteDataSource.findByRequestType();
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, ApigeeResponse<SubmitFormResponse>>> submitForm(
      {required SubmitFormParams params}) async {
    try {
      final data = await remoteDataSource.submitForm(params);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ApigeeResponse<ValidateFormResponse>>> validateForm(
      {required ValidateFormParams params}) async {
    try {
      final data = await remoteDataSource.validateForm(params: params);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ApigeeResponse<FormDataResponse>>> getFormData(
      {required String paramas}) async {
    try {
      final data = await remoteDataSource.getFormData(paramas: paramas);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ApigeeResponse<OffersResponse>>> getOffers(
      {required GetOffersParams paramas}) async {
    try {
      final data = await remoteDataSource.getOffers(paramas: paramas);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(ServerFailure(error.errorMessage,
          statusCode: error.statusCode, errorCode: error.errorCode));
    }
  }

  @override
  Future<Either<Failure, ApigeeResponse>> acceptOffer(
      {required String paramas}) async {
    try {
      final data = await remoteDataSource.acceptOffer(paramas: paramas);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ApigeeResponse>> rejectOffer(
      {required String paramas}) async {
    try {
      final data = await remoteDataSource.rejectOffer(paramas: paramas);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ApigeeResponse>> submitOrder(
      {required String paramas}) async {
    try {
      final data = await remoteDataSource.submitOrder(paramas: paramas);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ApigeeResponse>> cancelRequest(
      {required String paramas}) async {
    try {
      final data = await remoteDataSource.cancelRequest(paramas: paramas);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ApigeeResponse<CreateFormItemResponse>>>
      getEditFormData({required String paramas}) async {
    try {
      final data = await remoteDataSource.getEditFormData(paramas: paramas);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ApigeeResponse<SubmitFormResponse>>> editForm(
      {required SubmitFormParams params}) async {
    try {
      final data = await remoteDataSource.editForm(params);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }

  @override
  Future<Either<Failure, ApigeeResponse<UploadBidAttachmentResponse>>>
      uploadBidAttachment(UploadBidAttachment params) async {
    try {
      final data = await remoteDataSource.uploadBidAttachment(params);
      return Right(data);
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Left(
          ServerFailure(error.errorMessage, statusCode: error.statusCode));
    }
  }
}
