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
import '../../../../../../core/services/local/helpers.dart';
import '../../../../../../core/utils/common_functions.dart';
import '../../../../../../core/utils/constants/apis/api_info.dart';
import '../../../../../new_appointment/presentation/core/models/appointment_details_model.dart';
import '../../../../../new_appointment/presentation/core/models/cancel_appointment_response.dart';
import '../../../../../new_appointment/presentation/core/models/confirm_appointment_response.dart';
import '../../../../../new_appointment/presentation/core/models/my_appointments_response.dart';
import '../../../../../new_appointment/presentation/core/models/save_appointment_reseponse.dart';
import '../../../../../../core/services/global/web_service.dart' as web;
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class AppointmentRepository {
  final webServices = locator<PegaWebService>();

  

  Future<Tuple3<bool?, String?, MyAppointmentsResponse?>> getMyAppointments(
      {int pageSize = 20,
      int pageIndex = 0,
      bool upcomingAppointments = true,
      bool autoLogout = true}) async {
    String searchText = upcomingAppointments
        ? "&search=aptStatus.id==1,aptStatus.id==2,aptStatus.id==5"
        : "" /*"&search=aptStatus.id==3,aptStatus.id==4"*/;
    String query =
        "${(CommonProperties.userInfo?.idNo ?? "")}/${(CommonProperties.userInfo?.getIdType() ?? "")}?size=$pageSize&page=$pageIndex$searchText";
    // print(query);
    final body = await webServices.getApigeeRequest(ApiConstants.MyAppointments,
        relativePath: query, autoLogout: autoLogout);
    bool state = body['state'];
    dynamic data = body['data'];
    MyAppointmentsResponse? result;
    String error = body['error'] ?? ("errors_server_error_1").tr();

    try {
      MyAppointmentsResponse response =
          MyAppointmentsResponse.fromJson(json.decode(data));
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
            url: ApiConstants.MyAppointments,
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
    return Tuple3<bool?, String?, MyAppointmentsResponse?>(
        state, error, result);
  }

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
      int requestId) async {
    String query = "$requestId";

    final body = await webServices
        .postApigeeRequest(ApiConstants.CancelAppointment, relativePath: query);
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
          .get(ApiConstants.ConfirmAppointment(requestId));
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
  //   String query = "$requestId";

  //   final body = await webServices.postApigeeRequest(
  //       ApiConstants.ConfirmAppointment,
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
  //   LogsViewModel().sendEventFromModel(
  //     event: ErrorExceptionModel(
  //       nameEvent: EventsName.handledException,
  //       message: error.toString(),
  //       stackTrace: stackTrace.toString(),
  //     ),
  //   );
  // }
  //   }
  //   return Tuple3<bool?, String?, ConfirmAppointmentResponse?>(
  //       state, error, result);
  // }

  Future<Tuple3<bool?, String?, SaveAppointmentResponse?>> saveAppointment(
      var reqBody) async {
    final body = await webServices
        .postApigeeRequest(ApiConstants.AppointmentSave, body: reqBody);
    bool state = body['state'];
    dynamic data = body['data'];
    SaveAppointmentResponse? result;
    String error = body['error'] ?? ("errors_server_error_1").tr();

    try {
      SaveAppointmentResponse response =
          SaveAppointmentResponse.fromJson(json.decode(data));
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
            url: ApiConstants.AppointmentSave,
            body: reqBody,
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
    return Tuple3<bool?, String?, SaveAppointmentResponse?>(
        state, error, result);
  }

/*
  Future<Tuple3<bool?, String?, RatingInfoResponse?>> getRatingInfo(
      String serviceId) async {
    String query = "$serviceId";

    final body = await webServices.getApigeeRequest(ApiConstants.RatingInfo,
        relativePath: query, autoLogout: false);
    bool state = body['state'];
    dynamic data = body['data'];
    RatingInfoResponse? result;
    String error =
        body['error'] ?? Helpers.translatingWord("errors_server_error_1");

    try {
      RatingInfoResponse response =
          RatingInfoResponse.fromJson(json.decode(data));
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
            url: ApiConstants.RatingInfo,
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
    return Tuple3<bool?, String?, RatingInfoResponse?>(state, error, result);
  }
*/
}
