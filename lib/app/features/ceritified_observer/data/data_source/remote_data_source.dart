import 'dart:convert';

import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/core/utils/constants/apis/env_types.dart';
import 'package:balady_plus/app/core/utils/extensions/delay.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/ceritified_observer/domain/entity/user_certificates.dart';
import 'package:balady_plus/app/features/ceritified_observer/domain/lookups.dart';
import 'package:dio/dio.dart' show DioError;
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;
import '../../domain/entity/MunicipalityLookUp.dart';
import '../../domain/entity/city_entity.dart';
import '../../domain/entity/observer_status_entity.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

import '../../domain/entity/register_observer_request.dart';

abstract class CertifiedObserverRemoteDataSource {
  Future<ObserverStatusEntity> getObserverStatus(String identityNumber);

  Future<ResponseBodyModel<List<MunicipalityLookUp>>> getMuncipalityList();

  Future<ResponseBodyModel<bool>> checkMuncipalityAcceptance(String id);

  Future<ResponseBodyModel<List<CityEntity>>> getCityList(
      String municipalityId);

  Future<List<DistrictsEntity>> getDistrictByCityIdList(String cityId);

  Future<bool> registrationObserver(RegisterObserverRequest request);

  ////////////////// For Freelancer Certificate //////////////////

  Future<Map<String, dynamic>> createNewFreelancerCertificate();

  Future<Map<String, dynamic>> registerFreelancerCertificate();

  Future<Map<String, dynamic>> getFreelancerCertificateStatus();

  Future<Map<String, dynamic>> updateFreelancerCertificate(
      String certificateNumber);
}

class CertifiedObserverRemoteDataSourceImplementation
    implements CertifiedObserverRemoteDataSource {
  final WebService webService;

  CertifiedObserverRemoteDataSourceImplementation({required this.webService});

  @override
  Future<ObserverStatusEntity> getObserverStatus(String identityNumber) async {
    var response;
    try {
      response =
          await webService.dio.get(ApiUrl.getObserverStatus(identityNumber));
      final data = response.data;

      var parsedResult = data != null
          ? ObserverStatusEntity.fromJson(data["data"]["result"])
          : null;

      if (parsedResult != null) {
        return parsedResult;
      }
      throw ServerException("no_data".tr());
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
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
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: error.toString(),
          ),
          response: response,
        );
      }
    }
  }

  @override
  Future<ResponseBodyModel<List<MunicipalityLookUp>>>
      getMuncipalityList() async {
    var response;
    try {
      response = await webService.dio.get(ApiUrl.getMuncipalitList);
      var data = response.data["data"]?["result"];

      List<MunicipalityLookUp> parsedResult = data != null
          ? List<MunicipalityLookUp>.from(
              data.map((x) => MunicipalityLookUp.fromJson(x)))
          : [];

      final decodedResponse =
          ResponseBodyModel<List<MunicipalityLookUp>>.fromMap(response.data,
              parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
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
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: error.toString(),
          ),
          response: response,
        );
      }
    }
  }

  @override
  Future<ResponseBodyModel<bool>> checkMuncipalityAcceptance(String id) async {
    var response;
    try {
      response =
          await webService.dio.get(ApiUrl.checkMuncipalityAcceptance(id));
      var data = response.data["data"]?["result"];

      bool? parsedResult =
          data != null ? data['RegisterNewCertifiedObservers'] : false;
      final decodedResponse = ResponseBodyModel<bool>.fromMap(response.data,
          parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is NoDataFoundException) {
        rethrow;
      }
      var s = error.response?.data["data"];
      throw ServerException(
        error.toString(),
        errorCode: error.response?.data["data"]['responseCode'],
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
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: error.toString(),
          ),
          response: response,
        );
      }
    }
  }

  @override
  Future<ResponseBodyModel<List<CityEntity>>> getCityList(
      String municipalityId) async {
    var response;
    try {
      response =
          await webService.dio.get(ApiUrl.getMuncipalityCites(municipalityId));
      var data = response.data["data"]?["result"];

      List<CityEntity> parsedResult = data != null
          ? List<CityEntity>.from(data.map((x) => CityEntity.fromJson(x)))
          : [];

      final decodedResponse = ResponseBodyModel<List<CityEntity>>.fromMap(
          response.data,
          parsedResult: parsedResult);

      return decodedResponse.toFuture();
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
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
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: error.toString(),
          ),
          response: response,
        );
      }
    }
  }

  @override
  Future<List<DistrictsEntity>> getDistrictByCityIdList(String cityId) async {
    var response;
    try {
      response = await webService.dio.get(
        "${ApiUrl.urlDistrictsList}/$cityId",
      );

      var data = response.data["data"]?["result"];

      List<DistrictsEntity> parsedResult = data != null
          ? List<DistrictsEntity>.from(
              data.map(
                (x) => DistrictsEntity.fromJson(x),
              ),
            )
          : [];

      return parsedResult;
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
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
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: error.toString(),
          ),
          response: response,
        );
      }
    }
  }

  @override
  Future<bool> registrationObserver(RegisterObserverRequest request) async {
    var response;
    try {
      response = await webService.dio.post(
        ApiUrl.registerObserver,
        data: request.toJson(),
      );

      return true;
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
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
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: error.toString(),
          ),
          response: response,
        );
      }
    }
  }

  ////////////////// For Freelancer Certificate //////////////////

  @override
  Future<Map<String, dynamic>> registerFreelancerCertificate() async {
    var response;
    try {
      response = await webService.dio.post(
        ApiUrl.registerNewFreelancer,
        data: {
          "fullNameEn": CommonProperties.userInfo?.enName,
          "mobileNumber": CommonProperties.userInfo?.phone,
          "nationalId": CommonProperties.userInfo?.idNo,
          "dateOfBirth": CommonProperties.userInfo
              ?.getHijriBirthDate()
              .replaceAll("/", "-"), //"1394-02-04"
        },
      );
      return response.data["data"]["result"];
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
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
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: error.toString(),
          ),
          response: response,
        );
      }
    }
  }

  @override
  Future<Map<String, dynamic>> createNewFreelancerCertificate() async {
    var response;
    try {
      DateTime dateTime =
      (await CommonFunctions.fetchOnlineDateTimeForKSA() ?? DateTime.now());
      await registerFreelancerCertificate();
      UserCertificates userCertificates = await getAllFreelancerCertificate();
      if (userCertificates.certificate.isNotEmpty) {
        for (var certificate in userCertificates.certificate) {
            if (certificate.speciality?.code == specialityCode[sl<EnvType>().name]) {
              if(certificate.status == "ACTIVE" && dateTime.isBefore(certificate.expiryDate!)) {
                return {
                  "certificateNumber": certificate.number,
                  "certificateExpiryDate": certificate.expiryDate,
                  "certificateStatus": "ACTIVE",
                };
              }
            }
          }
      }

      String issueAt = DateFormat("yyyy-MM-dd").format(
        dateTime,
      );
      String expiryDate = DateFormat("yyyy-MM-dd").format(
        dateTime.add(const Duration(days: 365)),
      );
      response = await webService.dio.post(
        ApiUrl.createNewFreelancerCertificate,
        data: {
          "nationalId": CommonProperties.userInfo?.idNo,
          // whats the specialityCode for Certified Observer
          // For Stg -> AS615 , For Prodcaction -> S615
          "specialityCode": specialityCode[sl<EnvType>().name],
          "issueAt": issueAt,
          "expiryDate": expiryDate,
        },
      );
      return response.data["data"];
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
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
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: error.toString(),
          ),
          response: response,
        );
      }
    }
  }

  @override
  Future<Map<String, dynamic>> getFreelancerCertificateStatus() async {
    var response;
    try {

      //await registerFreelancerCertificate();
      UserCertificates userCertificates = await getAllFreelancerCertificate();
      if (userCertificates.certificate.isNotEmpty) {
        for (var certificate in userCertificates.certificate) {

          if (certificate.speciality?.code == specialityCode[sl<EnvType>().name]) {
            DateTime dateTime = (await CommonFunctions.fetchOnlineDateTimeForKSA() ?? DateTime.now());
            if(certificate.status == "ACTIVE" && dateTime.isBefore(certificate.expiryDate!)) {
              return {
                "certificateNumber": certificate.number,
                "certificateExpiryDate": certificate.expiryDate,
                "certificateStatus": "ACTIVE",
              };
            }
          }
        }
      }
      return response.data["data"];
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
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
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: error.toString(),
          ),
          response: response,
        );
      }
    }
  }

  @override
  Future<Map<String, dynamic>> updateFreelancerCertificate(
      String certificateNumber) async {
    var response;
    try {
      DateTime dateTime =
          (await CommonFunctions.fetchOnlineDateTimeForKSA() ?? DateTime.now());
      String issueAt = DateFormat("YYYY-MM-DD").format(
        dateTime,
      );
      String expiryDate = DateFormat("yyyy-MM-dd").format(
        dateTime.add(const Duration(days: 365)),
      );
      response = await webService.dio.post(
        ApiUrl.updateFreelancerCertificate,
        data: {
          "certificateNumber": certificateNumber,
          "nationalId": CommonProperties.userInfo?.idNo,
          "message": "",
          "status": "",
          "expiryDate": expiryDate,
        },
      );
      return response.data["data"];
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
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
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: error.toString(),
          ),
          response: response,
        );
      }
    }
  }

  Future<UserCertificates> getAllFreelancerCertificate() async {
    var response;
    try {
      response = await webService.dio.get(
        ApiUrl.getFreelancerCertificate,
        data: {},
      );
      return UserCertificates.fromJson(response.data["data"]['result']);
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      if (error is NoDataFoundException) {
        rethrow;
      }
      throw ServerException(
        error.toString(),
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
      if (error is ServerException) {
        rethrow;
      } else {
        throw ServerException(
          "errors_server_error_2".tr(),
          exception: APIException(
            errorMessage: error.toString(),
          ),
          response: response,
        );
      }
    }
  }
}
