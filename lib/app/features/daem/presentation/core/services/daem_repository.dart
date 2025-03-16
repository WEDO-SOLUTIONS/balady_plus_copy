import 'dart:convert';
import 'dart:io';

import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/core/utils/extensions/log.dart';
import 'package:dio/dio.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:tuple/tuple.dart';

import '../../../../../core/base/base_view_model.dart';
import '../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../core/remote_services/pega_web_service.dart';
import '../../../../../core/services/global/web_service.dart';
import '../../../../../core/services/local/helpers.dart';
import '../../../../../core/utils/common_functions.dart';
import '../../../../transaction_inquiry/presentation/core/models/download_file_result.dart';
import '../../../../transaction_inquiry/presentation/core/models/upload_file_result.dart';
import '../../../data/models/daem_area_type_response.dart';
import '../../../data/models/daem_category_type_response.dart';
import '../../../data/models/daem_create_ticket.dart';
import '../../../data/models/daem_issue_type_response.dart';
import '../../../data/models/daem_municipality_response.dart';
import '../../../data/models/daem_sub_category_type_response.dart';
import '../../../data/models/daem_submuncipality.response.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class DaemRepository {
  final pegaWebServices = locator<PegaWebService>();
  final webServices = sl<WebService>();
  Future<Tuple3<bool?, String?, DaemCategoryTypeResponse?>> getDaemCategoryList() async {
    Map<String, dynamic> queryParms = {};
    if (CommonProperties.userInfo?.idNo != null) {
      queryParms = {
        if (CommonProperties.userInfo!.idNo!.startsWith("1"))
          "NationalID": "${CommonProperties.userInfo!.idNo}"
        else
          "IqamaID": "${CommonProperties.userInfo!.idNo}",
        "Action": "Category",
        "Channel": "Citizen"
      };
    }

    String url = ApiUrl.DaemRetrieveData;

    final res = await webServices.dio.get(url, queryParameters: queryParms);

    bool state = false;


    if(res.statusCode == HttpStatus.ok ) {
     state = true ;
    }
    dynamic data = res.data["data"]["result"];
    String error = res.statusMessage ?? ("errors_server_error_1").tr();
    DaemCategoryTypeResponse? result;
    try {
      DaemCategoryTypeResponse response =
          DaemCategoryTypeResponse.fromJson(data);
      result = response;
      if (result.errors != null && result.errors!.isNotEmpty) {
        error = result.errors![0].message ?? error;
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
        Helpers.sendLog(url: url, data: data, errorMsg: error.toString());
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
    return Tuple3<bool?, String?, DaemCategoryTypeResponse?>(
        state, error, result);
  }

  Future<Tuple3<bool?, String?, DaemSubCategoryTypeResponse?>> getDaemSubCategoryList(String category) async {
    Map<String, dynamic> queryParms = {};
    if (CommonProperties.userInfo?.idNo != null) {
      queryParms = {
        if (CommonProperties.userInfo!.idNo!.startsWith("1"))
          "NationalID": "${CommonProperties.userInfo!.idNo}"
        else
          "IqamaID": "${CommonProperties.userInfo!.idNo}",
        "Category": category,
        "Action": "SubCategory",
        "Channel": "Citizen"
      };
    }

    String url = ApiUrl.DaemRetrieveData;

    final res = await webServices.dio.get(url, queryParameters: queryParms);
    bool state = false;

    if(res.statusCode == HttpStatus.ok ) {
      state = true ;
    }
    dynamic data = res.data["data"]["result"];
    String error = res.statusMessage ?? ("errors_server_error_1").tr();
    DaemSubCategoryTypeResponse? result;
    try {
      DaemSubCategoryTypeResponse response =
          DaemSubCategoryTypeResponse.fromJson(data);
      result = response;
      if (result.errors != null && result.errors!.isNotEmpty) {
        error = result.errors![0].message ?? error;
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
        Helpers.sendLog(url: url, data: data, errorMsg: error.toString());
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
    return Tuple3<bool?, String?, DaemSubCategoryTypeResponse?>(
        state, error, result);
  }

  Future<Tuple3<bool?, String?, DaemAreaTypeResponse?>> getDaemAreaList(
      {required String category, required String subCategory}) async {
    Map<String, dynamic> queryParms = {};
    if (CommonProperties.userInfo?.idNo != null) {
      queryParms = {
        if (CommonProperties.userInfo!.idNo!.startsWith("1"))
          "NationalID": "${CommonProperties.userInfo!.idNo}"
        else
          "IqamaID": "${CommonProperties.userInfo!.idNo}",
        "Category": category,
        "SubCategory": subCategory,
        "Action": "AreaList",
        "Channel": "Citizen"
      };
    }

    String url = ApiUrl.DaemRetrieveData;

    final res = await webServices.dio.get(url, queryParameters: queryParms);
    bool state = false;

    if(res.statusCode == HttpStatus.ok ) {
      state = true ;
    }
    dynamic data = res.data["data"]["result"];
    String error = res.statusMessage ?? ("errors_server_error_1").tr();

    DaemAreaTypeResponse? result;
    try {
      DaemAreaTypeResponse response =
          DaemAreaTypeResponse.fromJson(data);
      result = response;
      if (result.errors != null && result.errors!.isNotEmpty) {
        error = result.errors![0].message ?? error;
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
        Helpers.sendLog(url: url, data: data, errorMsg: error.toString());
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
    return Tuple3<bool?, String?, DaemAreaTypeResponse?>(state, error, result);
  }

  Future<Tuple3<bool?, String?, DaemIssueTypeResponse?>> getDaemIssueTypeList(
      {required String category,
      required String subCategory,
      required String area}) async {
    Map<String, dynamic> queryParms = {};
    if (CommonProperties.userInfo?.idNo != null) {
      queryParms = {
        if (CommonProperties.userInfo!.idNo!.startsWith("1"))
          "NationalID": "${CommonProperties.userInfo!.idNo}"
        else
          "IqamaID": "${CommonProperties.userInfo!.idNo}",
        "Category": category,
        "SubCategory": subCategory,
        "Area": area,
        "Action": "IssueTypeList",
        "Channel": "Citizen"
      };
    }

    String url = ApiUrl.DaemRetrieveData;

    final res = await webServices.dio.get(url, queryParameters: queryParms);
    bool state = false;

    if(res.statusCode == HttpStatus.ok ) {
      state = true ;
    }
    dynamic data = res.data["data"]["result"];
    String error = res.statusMessage ?? ("errors_server_error_1").tr();
    DaemIssueTypeResponse? result;
    try {
      DaemIssueTypeResponse response =
          DaemIssueTypeResponse.fromJson(data);
      result = response;
      if (result.errors != null && result.errors!.isNotEmpty) {
        error = result.errors![0].message ?? error;
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
        Helpers.sendLog(url: url, data: data, errorMsg: error.toString());
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
    return Tuple3<bool?, String?, DaemIssueTypeResponse?>(state, error, result);
  }

  Future<Tuple3<bool?, String?, DaemMunicipalityResponse?>> getAmanat() async {
    Map<String, dynamic> queryParms = {};
    if (CommonProperties.userInfo?.idNo != null) {
      queryParms = {
        if (CommonProperties.userInfo!.idNo!.startsWith("1"))
          "NationalID": "${CommonProperties.userInfo!.idNo}"
        else
          "IqamaID": "${CommonProperties.userInfo!.idNo}",
        "Action": "Amanat",
        "Channel": "Citizen"
      };
    }

    String url = ApiUrl.DaemRetrieveData;

    final res = await webServices.dio.get(url, queryParameters: queryParms);
    bool state = false;

    if(res.statusCode == HttpStatus.ok ) {
      state = true ;
    }
    dynamic data = res.data["data"]["result"];
    String error = res.statusMessage ?? ("errors_server_error_1").tr();


    DaemMunicipalityResponse? result;
    try {
      DaemMunicipalityResponse response =
          DaemMunicipalityResponse.fromJson(data);
      result = response;
      if (result.errors != null && result.errors!.isNotEmpty) {
        error = result.errors![0].message ?? error;
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
        Helpers.sendLog(url: url, data: data, errorMsg: error.toString());
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
    return Tuple3<bool?, String?, DaemMunicipalityResponse?>(
        state, error, result);
  }

  Future<Tuple3<bool?, String?, DaemSubMunicipalityResponse?>> getBaladiat(
      {required String amanaID}) async {
    Map<String, dynamic> queryParms = {};
    if (CommonProperties.userInfo?.idNo != null) {
      queryParms = {
        if (CommonProperties.userInfo!.idNo!.startsWith("1"))
          "NationalID": "${CommonProperties.userInfo!.idNo}"
        else
          "IqamaID": "${CommonProperties.userInfo!.idNo}",
        "Action": "AmanatBaladiah",
        "ID": amanaID,
        "Channel": "Citizen"
      };
    }

    String url = ApiUrl.DaemRetrieveData;

    final res = await webServices.dio.get(url, queryParameters: queryParms);
    bool state = false;

    if(res.statusCode == HttpStatus.ok ) {
      state = true ;
    }
    dynamic data = res.data["data"]["result"];
    String error = res.statusMessage ?? ("errors_server_error_1").tr();
    DaemSubMunicipalityResponse? result;
    try {
      DaemSubMunicipalityResponse response =
          DaemSubMunicipalityResponse.fromJson(data);
      result = response;
      if (result.errors != null && result.errors!.isNotEmpty) {
        error = result.errors![0].message ?? error;
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
        Helpers.sendLog(url: url, data: data, errorMsg: error.toString());
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
    return Tuple3<bool?, String?, DaemSubMunicipalityResponse?>(
        state, error, result);
  }

  Future<Tuple3<bool?, String?, DaemCreateTicket?>> createTicket(
      {required String category,
      required String subCategory,
      required String area,
      required String issueType,
      required String endUserLocation,
      required String baladiah,
      required String phone,
      required String description,
      required String citizenCompanyName,
      required String IdNumber,
      required String contactEmail}) async {
    String url = ApiUrl.DaemCreateTikcet;
    var bodyRequest = {
      "IncidentManagementBaladyIntCRM": {
        "Category": category,
        "SubCategory": subCategory,
        "Area": area,
        "IssueType": issueType,
        "EndUserLocation": endUserLocation,
        "Baladiah": baladiah,
        "Phone": phone,
        "Description": description,
        "CitizenCompanyName": citizenCompanyName,
        "ContactEmail": contactEmail
      },
      "CustomerInformation": {
        if (IdNumber.startsWith("1"))
          "NationalID": CommonProperties.userInfo!.idNo!,
        if (!IdNumber.startsWith("1"))
          "IqamaID": "" + CommonProperties.userInfo!.idNo!,
      }
    };

    dynamic data;
    bool state = false;
    String? err = ("errors_server_error_1").tr();
    DaemCreateTicket? result;

    try {

      final res = await webServices.dio.post(url, data: bodyRequest);

      if(res.statusCode == HttpStatus.ok ) {
        state = true ;
      }
      data = res.data["data"]["result"];
      err = res.statusMessage ?? ("errors_server_error_1").tr();
      DaemCreateTicket response = DaemCreateTicket.fromJson(data);
      result = response;
      if (result.errors != null && result.errors!.isNotEmpty) {
        err = result.errors![0].message ?? err;
        if (err.isEmpty) {
          err = ("errors_server_error_1").tr();
        }
        if (result.errors![0].id == "CS_API_049") {
          err = ("daem_duplicate_error").tr();
        }
      }
    }
    on DioError catch (error, stackTrace) {

      if(error.response?.data &&error.response?.data['data']['responseMessage'] != null) {
        err = error.response?.data['data']['responseMessage'];
      }

      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      try {
        Helpers.sendLog(url: url, data: data, errorMsg: error.toString());
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


    catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      try {
        Helpers.sendLog(url: url, data: data, errorMsg: error.toString());
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
    return Tuple3<bool?, String?, DaemCreateTicket?>(state, err, result);
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
          "pyMemo": fileName,
          "AttachStream": fileBase64,
          "NationalID": CommonProperties.userInfo?.idNo,
        };
      } else {
        body = {
          "CaseID": caseID,
          "Category": catrogry,
          "pxAttachName": fileName,
          "pyMemo": fileName,
          "AttachStream": fileBase64,
          "IqamaID": CommonProperties.userInfo?.idNo,
        };
      }
    } else {
      body = {
        "CaseID": caseID,
        "Category": catrogry,
        "pxAttachName": fileName,
        "pyMemo": fileName,
        "AttachStream": fileBase64,
      };
    }
    String url = ApiUrl.IncidentDaemUploadFile;

    CommonProperties.token.actionLog();

    final res = await webServices.dio.post(url, data: body);

    bool state = false;


    if(res.statusCode == HttpStatus.ok ) {
      state = true ;
    }
    dynamic data = res.data["data"]["result"];
    String error = res.statusMessage ?? ("errors_server_error_1").tr();

    UploadFileResult? response;
    try {
      response = UploadFileResult.fromJson(data);
      if (response != null &&
          response.errors != null &&
          response.errors!.isNotEmpty) {
        state = false;
        try {
          //MM
          Helpers.sendLog(
              url: url,
              data: data,
              body: json.encode(body),
              errorMsg: response.errors![0].message);
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
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      //MM
      try {
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

  Future<DownloadFileResult?> downloadFile(
      String fileKey, String DaemID) async {
    Map<String, dynamic> queryParms = {};
    if (CommonProperties.userInfo?.idNo != null) {
      queryParms = {
        if (CommonProperties.userInfo!.idNo!.startsWith("1"))
          "NationalID": "${CommonProperties.userInfo!.idNo}"
        else
          "IqamaID": "${CommonProperties.userInfo!.idNo}",
        "FileKey": fileKey,
        "DaemID": DaemID
      };
    }
    String url = ApiUrl.IncidentDownloadFile;
    DownloadFileResult? result;
    dynamic data;
    try {
      final res = await webServices.dio.get(url, queryParameters: queryParms);
       data = res.data["data"]["result"];
      result = DownloadFileResult.fromJson(data);
    }



    catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      try {
        String queryString = "?" + Uri(queryParameters: queryParms).query;

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
    }

    return result;
  }
}
