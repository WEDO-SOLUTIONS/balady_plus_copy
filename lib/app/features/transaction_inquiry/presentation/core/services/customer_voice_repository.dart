import 'dart:convert';
import 'dart:io';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:dartz/dartz.dart' hide Tuple3;
import 'package:dgis_map/library.dart';
import 'package:dio/dio.dart';

import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:tuple/tuple.dart';

import '../../../../../core/services/global/web_service.dart' as web;

import '../../../../../core/base/base_view_model.dart';
import '../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../core/remote_services/api_constants.dart';
import '../../../../../core/remote_services/pega_web_service.dart';
import '../../../../../core/services/global/web_service.dart';
import '../../../../../core/services/local/helpers.dart';
import '../../../../../core/utils/constants/remote_config.dart';
import '../models/classification.dart';
import '../models/create_incident_result.dart';
import '../models/gis_location_result.dart';
import '../models/upload_file_result.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class CustomerVoiceRepository {
  final pegawebServices = locator<PegaWebService>();
  final webServices = sl<WebService>();

  // Future<GisLocationResult?> getGisLocation(LatLng location) async {
  //   String query =
  //       "?x=${location.longitude}&y=${location.latitude}&guid=ba2570d8-6778-4048-9916-e234fac1c04b";
  //
  //   final body = await pegawebServices.getRequest(
  //       RemoteConfig.gis + ApiConstants.GisGetLocation,
  //       relativePath: query);
  //   bool state = body['state'];
  //   dynamic data = body['data'];
  //   String error = body['error'] ?? ("errors_server_error_1").tr();
  //
  //   try {
  //     GisLocationResult response =
  //         GisLocationResult.fromJson(json.decode(data));
  //     if (response != null) {
  //       return response;
  //     } else {
  //       CommonFunctions.showError(error);
  //     }
  //   } catch (error, stackTrace) {
  //     LogsViewModel().sendEventFromModel(
  //       event: ErrorExceptionModel(
  //         nameEvent: EventsName.handledException,
  //         message: error.toString(),
  //         stackTrace: stackTrace.toString(),
  //       ),
  //     );
  //     CommonFunctions.showError(error.toString());
  //     try {
  //       Helpers.sendLog(
  //           url: RemoteConfig.gis + ApiConstants.GisGetLocation,
  //           data: data,
  //           qeuryParms: query,
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
  //     return null;
  //   }
  // }

  Future<GisLocationResult?> getApigeeGisLocation(LatLng location) async {
    String query =
        "?x=${location.longitude}&y=${location.latitude}&guid=ba2570d8-6778-4048-9916-e234fac1c04b";

    /*final body = await webServices.getRequest(
        RemoteConfig.gis + ApiConstants.GisGetLocation,
        relativePath: query);
*/

    try {
      var res = await sl<web.WebService>().dio.get(ApiUrl.gis,
          queryParameters: {"x": location.longitude, "y": location.latitude});

      Map<String, dynamic> x = {};
      var data = res.data["data"]["result"];

      x["Contents"] = data;

      GisLocationResult? response = GisLocationResult.fromJson(x);
      if (response != null) {
        return response;
      } else {
        CommonFunctions.showError(
            Helpers.translatingWord("errors_server_error_2"));
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      CommonFunctions.showError(("errors_server_error_1").tr());
    }
    return null;
/*

    bool state = body['state'];
    dynamic data = body['data'];
    String error = body['error'] ?? ("errors_server_error_1").tr();

    try {
      GisLocationResult response =
          GisLocationResult.fromJson(json.decode(data));
      if (response != null) {
        return response;
      } else {
        CommonFunctions.showError(error);
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      CommonFunctions.showError(error);
      try {
        Helpers.sendLog(
            url: RemoteConfig.gis + ApiConstants.GisGetLocation,
            data: data,
            qeuryParms: query,
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
      return null;
    }*/
  }

  ////////////// comment
  // Future<Tuple3<bool?, String?, SpecializedClassification?>> getSPlList(
  //     String municipality,
  //     {String? category}) async {
  //   Map<String, dynamic> queryParms = {};
  //
  //   queryParms = {
  //     if (CommonProperties.userInfo?.idNo != null &&
  //         CommonProperties.userInfo!.idNo!.startsWith("1"))
  //       "NationalID": "${CommonProperties.userInfo!.idNo}"
  //     else if (CommonProperties.userInfo?.idNo != null)
  //       "IqamaID": "${CommonProperties.userInfo!.idNo}",
  //     "ID": municipality,
  //     "action": "SplClsList",
  //     "ChannelType": "Mobile",
  //     "Type": category == "REGA" ? "REGA" : "CRM",
  //     if (category != null && category.isNotEmpty)
  //       "SpecialClassificationType": category
  //   };
  //
  //   String url = ApiUrl.IncidentRetrieveData;
  //
  //   final body = await webServices.getPegaRequest(url, queryParams: queryParms);
  //   bool state = body['state'];
  //   dynamic data = body['data'];
  //   String? error = body['error'] ?? ("errors_server_error_1").tr();
  //   SpecializedClassification? result;
  //
  //   try {
  //     SpecializedClassification response =
  //         SpecializedClassification.fromMap(json.decode(data));
  //     result = response;
  //     if (response.splClassificationList?.isEmpty ?? false) {
  //       error = ("no_spl_classification_error").tr();
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
  //       String queryString = "?" + Uri(queryParameters: queryParms).query;
  //
  //       Helpers.sendLog(
  //           url: url,
  //           data: data,
  //           qeuryParms: queryString,
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
  //   return Tuple3<bool?, String?, SpecializedClassification?>(
  //       state, error, result);
  // }

  Future<Tuple3<bool?, String?, SpecializedClassification?>> getMSRSPlList(
      String municipality,
      {String? category}) async {
    Map<String, dynamic> queryParms = {};
    String? errorMessage ;
    if (CommonProperties.userInfo?.idNo != null) {
      queryParms = {
        if (CommonProperties.userInfo!.idNo!.startsWith("1"))
          "NationalID": "${CommonProperties.userInfo!.idNo}"
        else
          "IqamaID": "${CommonProperties.userInfo!.idNo}",
        "ID": municipality,
        "Action": "SplClsList",
        if (category != null) "Category": category
      };
    }

    String url = ApiUrl.MSRRetrieveMSRData;

    try {
      final res = await webServices.dio.get(url, queryParameters: queryParms);
      bool state = false;
      // if(res.statusCode == HttpStatus.ok ) {
      //   state = true ;
      // }
      //
      dynamic data = res.data["data"]["result"];
      errorMessage = res.statusMessage ?? ("errors_server_error_1").tr();
      SpecializedClassification? result;
      SpecializedClassification response =
          SpecializedClassification.fromMap(data);
      result = response;
      if (response.splClassificationList?.isEmpty ?? false) {
        errorMessage = ("no_spl_classification_error").tr();
      }
      return Tuple3<bool?, String?, SpecializedClassification?>(
        state,
        errorMessage,
        result,
      );
    } on DioException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      errorMessage = error.response?.data["data"]["responseMessage"];
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );

      errorMessage = "error_please_try_again_later".tr();
    }
    return Tuple3<bool?, String?, SpecializedClassification?>(
      false,
      errorMessage,
      null,
    );
  }

  //////////////  comment by fawzi not used in app
  // Future<SubMainClassification?> getSPlDetails(String splId,
  //     {String? category}) async {
  //   Map<String, dynamic> queryParms = {};
  //
  //   queryParms = {
  //     if (CommonProperties.userInfo?.idNo != null &&
  //         CommonProperties.userInfo!.idNo!.startsWith("1"))
  //       "NationalID": "${CommonProperties.userInfo!.idNo}"
  //     else if (CommonProperties.userInfo?.idNo != null)
  //       "IqamaID": "${CommonProperties.userInfo!.idNo}",
  //     "ID": splId,
  //     "action": "MainSublClsList",
  //     "Type": category == "REGA" ? "REGA" : "CRM",
  //   };
  //
  //   String url = ApiUrl.IncidentRetrieveData;
  //
  //   final body = await webServices.getPegaRequest(url, queryParams: queryParms);
  //   bool state = body['state'];
  //   dynamic data = body['data'];
  //
  //   try {
  //     SubMainClassification response =
  //         SubMainClassification.fromMap(json.decode(data));
  //
  //     return response;
  //   } catch (error, stackTrace) {
  //     LogsViewModel().sendEventFromModel(
  //       event: ErrorExceptionModel(
  //         nameEvent: EventsName.handledException,
  //         message: error.toString(),
  //         stackTrace: stackTrace.toString(),
  //       ),
  //     );
  //     try {
  //       String queryString = "?" + Uri(queryParameters: queryParms).query;
  //
  //       //MM
  //
  //       Helpers.sendLog(
  //           url: url,
  //           data: data,
  //           qeuryParms: queryString,
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
  //     return null;
  //   }
  // }

  Future<SubMainClassification?> getMSRSPlDetails(String splId) async {
    Map<String, dynamic> queryParms = {};
    if (CommonProperties.userInfo?.idNo != null) {
      queryParms = {
        if (CommonProperties.userInfo!.idNo!.startsWith("1"))
          "NationalID": "${CommonProperties.userInfo!.idNo}"
        else
          "IqamaID": "${CommonProperties.userInfo!.idNo}",
        "ID": splId,
        "Action": "MSRClsData",
      };
    }

    String url = ApiUrl.MSRRetrieveMSRData;

    final res = await webServices.dio.get(url, queryParameters: queryParms);

    dynamic data = res.data["data"]["result"];

    try {
      SubMainClassification response = SubMainClassification.fromMap(data);
      return response;
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      try {
        String queryString = "?" + Uri(queryParameters: queryParms).query;

//MM
        Helpers.sendLog(
            url: url,
            data: data,
            qeuryParms: queryString,
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
      return null;
    }
  }

  Future<Tuple3<bool?, String?, UploadFileResult?>> uploadFile(
      String? caseID,
      String? fileName,
      String? fileBase64,
      String? fileMemo,
      String? lastMemo,
      String? pyDescription,
      String? catrogry) async {
    String? memo = fileMemo;
    int extensionIndex = fileName?.lastIndexOf(".") ?? -1;
    if (extensionIndex != -1) {
      memo = fileName?.substring(0, extensionIndex) ?? fileMemo;
    }
    var body = {};
    if (CommonProperties.isLoggedInMunicipality &&
        CommonProperties.userInfo?.idNo != null) {
      if (CommonProperties.userInfo!.idNo!.startsWith("1")) {
        body = {
          "CaseID": caseID,
          "Category": catrogry,
          "pxAttachName": fileName,
          "pyMemo": memo,
          "AttachStream": fileBase64,
          "NationalID": CommonProperties.userInfo?.idNo,
          if (pyDescription != null) "pyDescription": pyDescription,
        };
      } else {
        body = {
          "CaseID": caseID,
          "Category": catrogry,
          "pxAttachName": fileName,
          "pyMemo": memo,
          "AttachStream": fileBase64,
          "IqamaID": CommonProperties.userInfo?.idNo,
          if (pyDescription != null) "pyDescription": pyDescription,
        };
      }
    } else {
      body = {
        "CaseID": caseID,
        "Category": catrogry,
        "pxAttachName": fileName,
        "pyMemo": memo, //
        "AttachStream": fileBase64,
        if (pyDescription != null) "pyDescription": pyDescription,
      };
    }
    String url = ApiUrl.IncidentDaemUploadFile;
    final res = await webServices.dio.post(url, data: body);

    bool state = false;

    if (res.statusCode == HttpStatus.ok) {
      state = true;
    }
    dynamic data = res.data["data"]["result"];
    String error = res.statusMessage ?? ("errors_server_error_1").tr();

    UploadFileResult? response; //
    try {
      response = UploadFileResult.fromJson(data);
      if (response != null &&
          response.errors != null &&
          response.errors!.isNotEmpty) state = false;
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      try {
        //MM
        Helpers.sendLog(
            url: url,
            data: data,
            body: json.encode(body),
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
    return Tuple3<bool?, String?, UploadFileResult?>(state, error, response);
  }

  /////////////  comment by fawzi not used in app
  // Future<Tuple3<bool?, String?, CreateIncidentResult?>> createRequest(
  //   var body,
  // ) async {
  //   String url = ApiUrl.IncidentCreate;
  //
  //   final res = await webServices.postPegaRequest(url, body: body);
  //   bool? state = res['state'];
  //   dynamic data = res['data'];
  //   String? error = res['error'];
  //   CreateIncidentResult? response;
  //   try {
  //     response = CreateIncidentResult.fromJson(json.decode(data));
  //   } catch (error, stackTrace) {
  //     LogsViewModel().sendEventFromModel(
  //       event: ErrorExceptionModel(
  //         nameEvent: EventsName.handledException,
  //         message: error.toString(),
  //         stackTrace: stackTrace.toString(),
  //       ),
  //     );
  //     //MM
  //     try {
  //       Helpers.sendLog(
  //           url: url, data: data, body: body, errorMsg: error.toString());
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
  //   return Tuple3<bool?, String?, CreateIncidentResult?>(
  //       state, error, response);
  // }

  Future<Tuple3<bool?, String?, CreateIncidentResult?>> createMSRRequest(
    var body,
  ) async {
    String url = ApiUrl.MSRCreate;

    final res = await webServices.dio.post(url, data: body);
    bool state = false;
    if (res.statusCode == HttpStatus.ok) {
      state = true;
    }
    dynamic data = res.data["data"]["result"];
    String error = res.statusMessage ?? ("errors_server_error_1").tr();

    CreateIncidentResult? response;
    try {
      response = CreateIncidentResult.fromJson(data);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      try {
        //MM
        Helpers.sendLog(
            url: url, data: data, body: body, errorMsg: error.toString());
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
    return Tuple3<bool?, String?, CreateIncidentResult?>(
        state, error, response);
  }
}
