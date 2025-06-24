import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:tuple/tuple.dart';

import '../../../../../../core/base/base_view_model.dart';
import '../../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../../core/errors/exceptions.dart';
import '../../../../../../core/remote_services/api_constants.dart';
import '../../../../../../core/remote_services/pega_web_service.dart';
import '../../../../../../core/services/global/web_service.dart' as webService;
import '../../../../../../core/services/global/web_service.dart' as web;
import '../../../../../../core/services/local/helpers.dart';
import '../../../../../../core/utils/common_functions.dart';
import '../../../../../../core/utils/constants/apis/api_info.dart';
import '../../models/appointment_details_model.dart';
import '../../models/available_dates_response.dart';
import '../../models/available_times_response.dart';
import '../../models/cancel_appointment_response.dart';
import '../../models/confirm_appointment_response.dart';
import '../../models/department_model.dart';
import '../../models/lookup_list_model.dart';
import '../../models/main_class_response.dart';
import '../../models/municipality_model.dart';
import '../../models/my_appointments_response.dart';
import '../../models/request_real_state_response_model.dart';
import '../../models/save_appointment_reseponse.dart';
import '../../models/service_config_reseponse.dart';
import '../../models/sub_class_response.dart';
import '../../models/sub_municipalitiy_model.dart';
import '../../models/upload_file_resepnse.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class AppointmentRepository {
  final webServices = locator<PegaWebService>();

  Future<Tuple3<bool?, String?, LookUpList?>> getLookupList(String type) async {
    String query = type;
    final body = await webServices.getApigeeRequest(
        ApiConstants.AppointmentLookUpList,
        relativePath: query);
    bool state = body['state'];
    dynamic data = body['data'];
    LookUpList? result;
    String error = body['error'] ?? ("errors_server_error_1").tr();
    try {
      LookUpList response = LookUpList.fromJson(json.decode(data));
      result = response;
      if (!state) {
        error = result.data?.responseMessage ?? error;
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      try {
        Helpers.sendLog(
            url: ApiConstants.AppointmentLookUpList,
            qeuryParms: query,
            data: data,
            errorMsg: error.toString());
      } catch (error, stackTrace) {
        LogsViewModel().sendEventFromModel(
          event: ErrorExceptionModel(
            nameEvent: EventsName.handledException,
            message: error.toString(),
            stackTrace: stackTrace.toString(),
          ),
        );
      }
    }
    return Tuple3<bool?, String?, LookUpList?>(state, error, result);
  }

  Future<Tuple3<bool?, String?, RequeestRealStateResponseModel?>>
      checkRealStateRequest(String id) async {
    Response res;

    try {
      res = await sl<web.WebService>().dio.get(ApiUrl.validateRealEstate(id));

      return const Tuple3<bool?, String?, RequeestRealStateResponseModel?>(
          true, "", null);
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print("ERRRRO ${error.toString()}");
      ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
      return Tuple3<bool?, String?, RequeestRealStateResponseModel?>(
          false, error.toString(), null);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Tuple3<bool?, String?, RequeestRealStateResponseModel?>(
          false, error.toString(), null);
    }
  }

  Future<Tuple3<bool?, String?, Municipality?>> getMunicipalities() async {
    Response res;
    try {
      res = await sl<web.WebService>()
          .dio
          .get(ApiConstants.AppointmentMunicipalities);
      Municipality response = Municipality.fromJson(res.data);
      return Tuple3<bool?, String?, Municipality?>(true, "", response);
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print("ERRRRO ${error.toString()}");
      ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
      return Tuple3<bool?, String?, Municipality?>(
          false, error.toString(), null);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Tuple3<bool?, String?, Municipality?>(
          false, error.toString(), null);
    }
  }

  Future<Tuple3<bool?, String?, SubMunicipality?>> getSubMunicipalities(
      String municipalityId) async {
    Response res;
    try {
      res = await sl<web.WebService>()
          .dio
          .get(ApiConstants.AppointmentSubMunicipalities(municipalityId));
      SubMunicipality response = SubMunicipality.fromJson(res.data);
      return Tuple3<bool?, String?, SubMunicipality?>(true, "", response);
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print("ERRRRO ${error.toString()}");
      ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
      return Tuple3<bool?, String?, SubMunicipality?>(
          false, error.toString(), null);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Tuple3<bool?, String?, SubMunicipality?>(
          false, error.toString(), null);
    }
  }

  Future<Tuple3<bool?, String?, DepartmentList?>> getDepartments(
      String subMunicipalityId) async {
    String query = subMunicipalityId;
    final body = await webServices.getApigeeRequest(
        ApiConstants.AppointmentDepartments,
        relativePath: query);
    bool state = body['state'];
    dynamic data = body['data'];
    DepartmentList? result;
    String error = body['error'] ?? ("errors_server_error_1").tr();
    try {
      DepartmentList response = DepartmentList.fromJson(json.decode(data));
      result = response;
      if (!state || result.data?.responseCode == "2") {
        error = result.data?.responseMessage ?? error;
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      try {
        Helpers.sendLog(
            url: ApiConstants.AppointmentDepartments,
            qeuryParms: query,
            data: data,
            errorMsg: error.toString());
      } catch (error, stackTrace) {
        LogsViewModel().sendEventFromModel(
          event: ErrorExceptionModel(
            nameEvent: EventsName.handledException,
            message: error.toString(),
            stackTrace: stackTrace.toString(),
          ),
        );
      }
    }
    return Tuple3<bool?, String?, DepartmentList?>(state, error, result);
  }

  Future<Tuple3<bool?, String?, MainClassResponse?>> getMainClassifications(
      String subMunicipalityId) async {
    Response res;
    try {
      res = await sl<web.WebService>()
          .dio
          .get(ApiConstants.AppointmentMainClasssifications(subMunicipalityId));
      MainClassResponse response = MainClassResponse.fromJson(res.data);
      return Tuple3<bool?, String?, MainClassResponse?>(true, "", response);
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print("ERRRRO ${error.toString()}");
      ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
      return Tuple3<bool?, String?, MainClassResponse?>(
          false, error.toString(), null);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Tuple3<bool?, String?, MainClassResponse?>(
          false, error.toString(), null);
    }
  }

  Future<Tuple3<bool?, String?, SubClassResponse?>> getSubClassifications(
      String subMunicipalityId, String mainClassId) async {
    Response res;
    try {
      res = await sl<web.WebService>().dio.get(
          ApiConstants.AppointmentSubClasssifications(
              subMunicipalityId, mainClassId));
      SubClassResponse response = SubClassResponse.fromJson(res.data);
      return Tuple3<bool?, String?, SubClassResponse?>(true, "", response);
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print("ERRRRO ${error.toString()}");
      ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
      return Tuple3<bool?, String?, SubClassResponse?>(
          false, error.toString(), null);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Tuple3<bool?, String?, SubClassResponse?>(
          false, error.toString(), null);
    }
  }

  Future<Tuple3<bool?, String?, ServiceConfigResponse?>> getServiceConfig(
      String subMunicipalityId, String subClassId) async {
    Response res;
    try {
      res = await sl<web.WebService>().dio.get(
          ApiConstants.AppointmentServiceConfig(subMunicipalityId, subClassId));
      ServiceConfigResponse response = ServiceConfigResponse.fromJson(res.data);
      return Tuple3<bool?, String?, ServiceConfigResponse?>(true, "", response);
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print("ERRRRO ${error.toString()}");
      ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
      return Tuple3<bool?, String?, ServiceConfigResponse?>(
          false, error.toString(), null);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Tuple3<bool?, String?, ServiceConfigResponse?>(
          false, error.toString(), null);
    }
  }

  Future<Tuple3<bool?, String?, AvailableDatesResponse?>> getAppointmentDates(
      int serviceId,
      {String? currentDraftTime}) async {
    String query = "${(serviceId)}";
    final body = await webServices.getApigeeRequest(
        ApiConstants.AppointmentAvailableDates,
        relativePath: query);
    bool state = body['state'];
    dynamic data = body['data'];
    AvailableDatesResponse? result;
    String error = body['error'] ?? ("errors_server_error_1").tr();
    try {
      AvailableDatesResponse response = AvailableDatesResponse.fromJson(
          json.decode(data),
          currentDraftTime: currentDraftTime);
      result = response;
      if (!state) {
        error = result.data?.responseMessage ?? error;
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      try {
        Helpers.sendLog(
            url: ApiConstants.AppointmentAvailableDates,
            qeuryParms: query,
            data: data,
            errorMsg: error.toString());
      } catch (error, stackTrace) {
        LogsViewModel().sendEventFromModel(
          event: ErrorExceptionModel(
            nameEvent: EventsName.handledException,
            message: error.toString(),
            stackTrace: stackTrace.toString(),
          ),
        );
      }
    }
    return Tuple3<bool?, String?, AvailableDatesResponse?>(
        state, error, result);
  }

  Future<Tuple3<bool?, String?, AvailableTimesResponse?>> getAppointmentTimes(
      int serviceId, String date) async {
    String query = "${(serviceId)}/${(date)}";
    final body = await webServices.getApigeeRequest(
        ApiConstants.AppointmentAvailableTimes,
        relativePath: query);
    bool state = body['state'];
    dynamic data = body['data'];
    AvailableTimesResponse? result;
    String error = body['error'] ?? ("errors_server_error_1").tr();
    try {
      AvailableTimesResponse response =
          AvailableTimesResponse.fromJson(json.decode(data));
      result = response;
      if (!state) {
        error = result.data?.responseMessage ?? error;
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      try {
        Helpers.sendLog(
            url: ApiConstants.AppointmentAvailableTimes,
            qeuryParms: query,
            data: data,
            errorMsg: error.toString());
      } catch (error, stackTrace) {
        LogsViewModel().sendEventFromModel(
          event: ErrorExceptionModel(
            nameEvent: EventsName.handledException,
            message: error.toString(),
            stackTrace: stackTrace.toString(),
          ),
        );
      }
    }
    return Tuple3<bool?, String?, AvailableTimesResponse?>(
        state, error, result);
  }

  Future<Tuple3<bool?, String?, MyAppointmentsResponse?>> getMyAppointments({
    int pageSize = 20,
    int pageIndex = 0,
  }) async {
    Response res;

    try {
      res = await sl<web.WebService>()
          .dio
          .get(ApiConstants.MyAppointments, queryParameters: {
        "size": pageSize,
        "page": pageIndex,
      });

      MyAppointmentsResponse response =
          MyAppointmentsResponse.fromJson(res.data);

      return Tuple3<bool?, String?, MyAppointmentsResponse?>(
          true, "", response);
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
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
      return Tuple3<bool?, String?, MyAppointmentsResponse?>(
          false, error.toString(), null);
    }
  }

  // Future<Tuple3<bool?, String?, MyAppointmentsResponse?>> getMyAppointments(
  //     {int pageSize = 20,
  //     int pageIndex = 0,
  //     bool upcomingAppointments = true,
  //     bool autoLogout = true}) async {
  //   String searchText = upcomingAppointments
  //       ? "&search=aptStatus.id==1,aptStatus.id==2,aptStatus.id==5"
  //       : "" /*"&search=aptStatus.id==3,aptStatus.id==4"*/;
  //   String query =
  //       "${(CommonProperties.userInfo?.idNo ?? "")}/${(CommonProperties.userInfo?.getIdType() ?? "")}?size=$pageSize&page=$pageIndex$searchText";

  //   final body = await webServices.getApigeeRequest(ApiConstants.MyAppointments,
  //       relativePath: query, autoLogout: autoLogout);
  //   bool state = body['state'];
  //   dynamic data = body['data'];
  //   MyAppointmentsResponse? result;
  //   String error = body['error'] ?? ("errors_server_error_1").tr();

  //   try {
  //     MyAppointmentsResponse response =
  //         MyAppointmentsResponse.fromJson(json.decode(data));
  //     result = response;
  //     if (!state) {
  //       error = result.data?.responseMessage ?? error;
  //     }
  //   } catch (error, stackTrace) {
  //     LogsViewModel().sendEventFromModel(
  //       event: ErrorExceptionModel(
  //         nameEvent: EventsName.handledException,
  //         message: error.toString(),
  //         stackTrace: stackTrace.toString(),
  //       ),
  //     );
  //     try {
  //       Helpers.sendLog(
  //           url: ApiConstants.MyAppointments,
  //           qeuryParms: query,
  //           data: data,
  //           errorMsg: error.toString());
  //     } catch (error, stackTrace) {
  //       LogsViewModel().sendEventFromModel(
  //         event: ErrorExceptionModel(
  //           nameEvent: EventsName.handledException,
  //           message: error.toString(),
  //           stackTrace: stackTrace.toString(),
  //         ),
  //       );
  //     }
  //   }
  //   return Tuple3<bool?, String?, MyAppointmentsResponse?>(
  //       state, error, result);
  // }

  Future<Tuple3<bool?, String?, AppointmentDetails?>> getAppointmentDetails(
      int appointmentId) async {
    String query = appointmentId.toString();

    Response res;

    try {
      res =
          await sl<web.WebService>().dio.get(ApiUrl.getAppointmentById(query));

      AppointmentDetails response = AppointmentDetails.fromJson(res.data);

      return Tuple3<bool?, String?, AppointmentDetails?>(true, "", response);
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
      return Tuple3<bool?, String?, AppointmentDetails?>(
          false, error.toString(), null);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Tuple3<bool?, String?, AppointmentDetails?>(
          false, error.toString(), null);
    }
  }

  Future<Tuple4<bool?, String?, Uint8List?, String?>> printAppointment(
      int id) async {
    String query = "$id";

    final body = await webServices.getApigeeRequestWithoutUTF(
        ApiConstants.PrintAppointmentDetails,
        relativePath: query);
    bool state = body['state'];
    dynamic data = body['data'];
    Uint8List? result;
    String error = body['error'] ?? ("errors_server_error_1").tr();
    String? contentType = body['Content-Type'];

    try {
      result = data;
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      try {
        Helpers.sendLog(
            url: ApiConstants.PrintAppointmentDetails,
            qeuryParms: query,
            data: data,
            errorMsg: error.toString());
      } catch (error, stackTrace) {
        LogsViewModel().sendEventFromModel(
          event: ErrorExceptionModel(
            nameEvent: EventsName.handledException,
            message: error.toString(),
            stackTrace: stackTrace.toString(),
          ),
        );
      }
    }
    return Tuple4<bool?, String?, Uint8List?, String?>(
        state, error, result, contentType);
  }

  Future<Tuple3<bool?, String?, CancelAppointmentResponse?>> cancelAppointment(
      int requestId,
      List<LookUpItem> cancelReasons,
      String? otherReason) async {
    String query = "$requestId";

    final body =
        await webServices.postApigeeRequest(ApiConstants.CancelAppointment,
            body: {
              "cancelReason": [
                {
                  "id": cancelReasons.first.id,
                }
              ],
              if (cancelReasons.first.isOther == true) "note": otherReason
            },
            relativePath: query);
    bool state = body['state'];
    dynamic data = body['data'];
    CancelAppointmentResponse? result;
    String error = body['error'] ?? ("errors_server_error_1").tr();
    try {
      CancelAppointmentResponse response =
          CancelAppointmentResponse.fromJson(json.decode(data));
      result = response;
      if (!state) {
        error = result.data?.responseMessage ?? error;
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      try {
        Helpers.sendLog(
            url: ApiConstants.CancelAppointment,
            qeuryParms: query,
            data: data,
            errorMsg: error.toString());
      } catch (error, stackTrace) {
        LogsViewModel().sendEventFromModel(
          event: ErrorExceptionModel(
            nameEvent: EventsName.handledException,
            message: error.toString(),
            stackTrace: stackTrace.toString(),
          ),
        );
      }
    }
    return Tuple3<bool?, String?, CancelAppointmentResponse?>(
        state, error, result);
  }

  Future<Tuple3<bool?, String?, ConfirmAppointmentResponse?>>
      confirmAppointment(String requestId) async {
    Response res;
    try {
      res = await sl<web.WebService>()
          .dio
          .post(ApiConstants.ConfirmAppointment(requestId));
      ConfirmAppointmentResponse response =
          ConfirmAppointmentResponse.fromJson(res.data);
      return Tuple3<bool?, String?, ConfirmAppointmentResponse?>(
          true, "", response);
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print("ERRRRO ${error.toString()}");
      ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
      return Tuple3<bool?, String?, ConfirmAppointmentResponse?>(
          false, error.toString(), null);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Tuple3<bool?, String?, ConfirmAppointmentResponse?>(
          false, error.toString(), null);
    }
  }

  // Future<Tuple3<bool?, String?, ConfirmAppointmentResponse?>>
  //     confirmAppointment(String requestId) async {
  //   String query = requestId;

  //   final body = await webServices.postApigeeRequest(
  //       ApiConstants.ConfirmAppointmentNewAppointment(requestId),
  //       relativePath: query);
  //   bool state = body['state'];
  //   dynamic data = body['data'];
  //   ConfirmAppointmentResponse? result;
  //   String error = body['error'] ?? ("errors_server_error_1").tr();

  //   try {
  //     ConfirmAppointmentResponse response =
  //         ConfirmAppointmentResponse.fromJson(json.decode(data));
  //     result = response;
  //     if (!state) {
  //       error = result.data?.responseMessage ?? error;
  //     }
  //   } catch (error, stackTrace) {
  //     LogsViewModel().sendEventFromModel(
  //       event: ErrorExceptionModel(
  //         nameEvent: EventsName.handledException,
  //         message: error.toString(),
  //         stackTrace: stackTrace.toString(),
  //       ),
  //     );
  //     try {
  //       Helpers.sendLog(
  //           url: ApiConstants.ConfirmAppointment,
  //           qeuryParms: query,
  //           data: data,
  //           errorMsg: error.toString());
  //     } catch (error, stackTrace) {
  //       LogsViewModel().sendEventFromModel(
  //         event: ErrorExceptionModel(
  //           nameEvent: EventsName.handledException,
  //           message: error.toString(),
  //           stackTrace: stackTrace.toString(),
  //         ),
  //       );
  //     }
  //   }
  //   return Tuple3<bool?, String?, ConfirmAppointmentResponse?>(
  //       state, error, result);
  // }

  Future<Tuple3<bool?, String?, SaveAppointmentResponse?>> updateAppointment(
      var reqBody, int id) async {
    Response res;

    try {
      res = await sl<web.WebService>()
          .dio
          .put(ApiUrl.getAppointmentById(id.toString()), data: reqBody);

      return Tuple3<bool?, String?, SaveAppointmentResponse?>(
          true, "", SaveAppointmentResponse());
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
      return Tuple3<bool?, String?, SaveAppointmentResponse?>(
          false, error.toString(), null);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Tuple3<bool?, String?, SaveAppointmentResponse?>(
          false, error.toString(), null);
    }
  }

  Future<Tuple3<bool?, String?, SaveAppointmentResponse?>> saveAppointment(
      var reqBody) async {
    Response res;

    try {
      res = await sl<web.WebService>()
          .dio
          .post(ApiUrl.saveAppointment, data: reqBody);

      SaveAppointmentResponse response =
          SaveAppointmentResponse.fromJson(res.data);

      return Tuple3<bool?, String?, SaveAppointmentResponse?>(
          true, "", response);
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
      return Tuple3<bool?, String?, SaveAppointmentResponse?>(
          false, error.toString(), null);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Tuple3<bool?, String?, SaveAppointmentResponse?>(
          false, error.toString(), null);
    }
  }

  Future<Tuple3<bool?, String?, UploadFileResponse?>> uploadFile(
      Uint8List? base64,
      String? fileName,
      String? filePath,
      String? mimeType,
      int typeID) async {
    final body = await webServices.uploadApigeeFile(
        ApiConstants.AppointmentUploadFile(typeID),
        base64: base64,
        fileName: fileName,
        mimeType: mimeType);
    bool state = body['state'];
    dynamic data = body['data'];
    UploadFileResponse? result;
    String error = body['error'] ?? ("errors_server_error_1").tr();

    try {
      UploadFileResponse response =
          UploadFileResponse.fromJson(json.decode(data));
      result = response;
      if (!state) {
        error = result.data?.responseMessage ?? error;
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      try {
        Helpers.sendLog(
            url: ApiConstants.AppointmentUploadFile(typeID),
            qeuryParms: filePath,
            data: data,
            errorMsg: error.toString());
      } catch (error, stackTrace) {
        LogsViewModel().sendEventFromModel(
          event: ErrorExceptionModel(
            nameEvent: EventsName.handledException,
            message: error.toString(),
            stackTrace: stackTrace.toString(),
          ),
        );
      }
    }
    return Tuple3<bool?, String?, UploadFileResponse?>(state, error, result);
  }

  Future<Tuple3<bool?, String?, SaveAppointmentResponse?>> deleteAttachment(
    String udid,
  ) async {
    Response res;
    try {
      res = await sl<web.WebService>().dio.post(ApiUrl.deleteAppointment(udid));

      SaveAppointmentResponse response =
          SaveAppointmentResponse.fromJson(res.data);

      return Tuple3<bool?, String?, SaveAppointmentResponse?>(
          true, "", response);
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      ServerException(
        error.toString(),
        statusCode: error.response?.statusCode,
        dioError: error,
      );
      return Tuple3<bool?, String?, SaveAppointmentResponse?>(
          false, error.toString(), null);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return Tuple3<bool?, String?, SaveAppointmentResponse?>(
          false, error.toString(), null);
    }
  }
}
