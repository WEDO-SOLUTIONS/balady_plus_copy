import 'dart:convert';
import 'dart:typed_data';

import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/vd/domain/entities/gis/gis_params.dart';
import 'package:balady_plus/app/features/violation_guide/domain/entites/regulation_clauses_details_params.dart';

import 'package:dio/dio.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mime/mime.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/global/web_service.dart';
import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/constants/apis/api_headers.dart';
import '../../../../core/utils/constants/apis/api_info.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/constants/remote_config.dart';
import '../../domain/entites/regulation_clauses_params.dart';
import '../models/classification_response.dart';
import '../models/establishment_size_response.dart';
import '../models/regualation_cluses_details.dart';
import '../models/regulation_clause_response.dart';
import '../models/violator_response.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

abstract class ViolationGuideRemoteDataSource {
  /*Future<ApplyCreateComplianceResponseModel> applyCreateCompliance(
    ApplyCreateComplianceRequest params,
  );*/

  Future<RegulationClausesResponse> getRegulationClausesResponse(
    RegulationClausesParams params,
  );

  Future<EstablishmentSizeResponse> getEstablishmentSize();

  Future<ViolationClassificationResponse> getViolationsClassifications(
    GISParams params,
  );

  Future<ViolatorResponse> getViolatorsLookUp();
  Future<RegulationClauseDetails> getRegulationDetails(
      {RegulationClauseDetailsParams params});
}

class ViolationGuideRemoteDataSourceImpl
    extends ViolationGuideRemoteDataSource {
  final WebService webService;

  ViolationGuideRemoteDataSourceImpl({required this.webService});

  @override
  Future<EstablishmentSizeResponse> getEstablishmentSize() async {
    var response;
    try {
      response = await webService.dio.get(ApiUrl.establishmentSizes,
          options: Options(headers: {
            ApiHeader.requiresToken.eName: false,
          }));

      final data = response.data;

      return EstablishmentSizeResponse.fromJson(data["data"]);
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      var errorCode;
      try {
        final decodedResponse =
            ResponseBodyModel<EstablishmentSizeResponse>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException)
        throw error;
      else {
        try {} catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<RegulationClausesResponse> getRegulationClausesResponse(
      RegulationClausesParams params) async {
    var response;
    try {
      response = await webService.dio.get(ApiUrl.regulationClauses,
          queryParameters: params.toMap(),
          options: Options(headers: {
            ApiHeader.requiresToken.eName: false,
          }));

      final data = response.data;

      return RegulationClausesResponse.fromJson(data["data"]);
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      var errorCode;
      try {
        final decodedResponse =
            ResponseBodyModel<RegulationClausesResponse>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException)
        throw error;
      else {
        try {} catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<ViolationClassificationResponse> getViolationsClassifications(
      GISParams params) async {
    var response;
    try {
      response = await webService.dio.get(ApiUrl.violationsClassifications,
          queryParameters: {"Latitude": params.lat, "Longitude": params.lon},
          options: Options(headers: {
            ApiHeader.requiresToken.eName: false,
          }));
      var data = response.data;
      final result = ResponseBodyModel.fromMap(data).data?.result;

      return ViolationClassificationResponse.fromJson(result);
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      var errorCode;
      try {
        final decodedResponse =
            ResponseBodyModel<ViolationClassificationResponse>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {} catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<ViolatorResponse> getViolatorsLookUp() async {
    var response;
    try {
      response = await webService.dio.get(ApiUrl.violatorLookups,
          options: Options(headers: {
            ApiHeader.requiresToken.eName: false,
          }));

      final data = response.data;

      return ViolatorResponse.fromJson(data["data"]);
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      var errorCode;
      try {
        final decodedResponse = ResponseBodyModel<ViolatorResponse>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {} catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }

  @override
  Future<RegulationClauseDetails> getRegulationDetails(
      {RegulationClauseDetailsParams? params}) async {
    var response;
    try {
      String q = "${RemoteConfig.apigeeURL}${ApiUrl.regulationClauseDetails}?";
      params!.toMap().forEach((key, value) {
        q += "$key=$value&";
      });
      q = q.substring(0, q.length - 1);
      print(q);
      response = await webService.dio.get(ApiUrl.regulationClauseDetails,
          queryParameters: params.toMap(),
          options: Options(headers: {
            ApiHeader.requiresToken.eName: false,
            ApiHeader.verifyingKEY.name:
                CommonFunctions.hashRequest(q, "GET", authorization: false)
          }));

      final data = response.data;

      return RegulationClauseDetails.fromJson(data["data"]["result"]);
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      var errorCode;
      try {
        final decodedResponse = ResponseBodyModel<ViolatorResponse>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      if (error is ServerException)
        throw error;
      else {
        try {} catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }
}
/*@override
  Future<ApplyCreateComplianceResponseModel> applyCreateCompliance(
      ApplyCreateComplianceRequest params) async {
    var response;
    try {
      response = await webService.dio.post(
        ApiUrl.applyBeneficiaryCompliance,
        data: params.toMap(),
      );

      final data = response.data;

      return ApplyCreateComplianceResponseModel(
          result: ResponseBodyModel.fromMap(data).data?.result);
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      var errorCode;
      try {
        final decodedResponse =
            ResponseBodyModel<ApplyCreateComplianceResponseModel>.fromMap(
          error.response?.data,
        );
        errorCode = decodedResponse.data?.responseCode;
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }

      throw ServerException(
        error.toString(),
        errorCode: errorCode,
        statusCode: error.response?.statusCode,
        dioError: error,
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is ServerException)
        throw error;
      else {
        try {} catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
        throw ServerException("errors_server_error_2".tr(),
            exception: APIException(
              errorMessage: error.toString(),
            ),
            response: response);
      }
    }
  }*/
