import 'dart:convert';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:tuple/tuple.dart';

import '../../../../../core/base/base_view_model.dart';
import '../../../../../core/remote_services/api_constants.dart';
import '../../../../../core/remote_services/web_service.dart';
import '../../../../../core/utils/constants/remote_config.dart';
import '../models/classification.dart';
import '../models/classification_response_model.dart';
import '../models/create_incident_result.dart';
import '../models/gis_location_result.dart';

class InquiryRepository {
  final webServices = locator<WebService>();

  Future<GisLocationResult?> getGisLocation(LatLng location) async {
    String query =
        "?x=${location.longitude}&y=${location.latitude}&guid=ba2570d8-6778-4048-9916-e234fac1c04b";

    final body = await webServices.getRequest(
        RemoteConfig.gis + ApiConstants.GisGetLocation,
        relativePath: query);
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
    } catch (ex) {
      print(ex);
      CommonFunctions.showError(error);
      try {
        /*   Helpers.sendLog(
            url: RemoteConfig.gisURL + ApiConstants.GisGetLocation,
            data: data,
            qeuryParms: query,
            errorMsg: ex.toString());*/
      } catch (ex) {}
      return null;
    }
  }

  Future<Tuple3<bool?, String?, ClassificationResponse?>>
      getAllSplClassificationsLsit({required String category}) async {
    Map<String, dynamic> queryParms = {};

    queryParms = {
      if (CommonProperties.userInfo?.idNo != null &&
          CommonProperties.userInfo!.idNo!.startsWith("1"))
        "NationalID": "${CommonProperties.userInfo!.idNo}"
      else if (CommonProperties.userInfo?.idNo != null)
        "IqamaID": "${CommonProperties.userInfo!.idNo}",
      "type": "INQ",
      "SpecialClassificationType": category
    };
    print(queryParms);

    String url = ApiUrl.INQAllSPLClassifications;

    final body = await webServices.getPegaRequest(url, queryParams: queryParms);
    bool state = body['state'];
    dynamic data = body['data'];
    String? error = body['error'];
    ClassificationResponse? result;

    try {
      ClassificationResponse response =
          ClassificationResponse.fromJson(json.decode(data));
      result = response;
      if (response.data.isEmpty) {
        error = ("spl_classification_error").tr();
      }
    } catch (ex) {
      print(ex);
      try {
        String queryString = "?" + Uri(queryParameters: queryParms).query;

        //MM   Helpers.sendLog(url: url, data: data, qeuryParms: queryString);
      } catch (ex) {}
    }
    return Tuple3<bool?, String?, ClassificationResponse?>(
        state, error, result);
  }

  Future<Tuple3<bool?, String?, ClassificationResponse?>>
      getMainClassificationsLsit(String municipality,
          {String? category}) async {
    Map<String, dynamic> queryParms = {};

    queryParms = {
      if (CommonProperties.userInfo?.idNo != null &&
          CommonProperties.userInfo!.idNo!.startsWith("1"))
        "NationalID": "${CommonProperties.userInfo!.idNo}"
      else if (CommonProperties.userInfo?.idNo != null)
        "IqamaID": "${CommonProperties.userInfo!.idNo}",
      "type": "INQ",
    };
    print(queryParms);

    String url = ApiUrl.INQMainClassifications;

    final body = await webServices.getPegaRequest(url, queryParams: queryParms);
    bool state = body['state'];
    dynamic data = body['data'];
    String error = body['error'] ?? ("errors_server_error_1").tr();
    ClassificationResponse? result;

    try {
      ClassificationResponse response =
          ClassificationResponse.fromJson(json.decode(data));
      result = response;
      if (response.data.isEmpty) {
        error = ("main_classification_error").tr();
      }
    } catch (ex) {
      print(ex);
      try {
        String queryString = "?" + Uri(queryParameters: queryParms).query;

//
        /* Helpers.sendLog(
            url: url,
            data: data,
            qeuryParms: queryString,
            errorMsg: ex.toString());*/
      } catch (ex) {}
    }
    return Tuple3<bool?, String?, ClassificationResponse?>(
        state, error, result);
  }

  Future<Tuple3<bool?, String?, ClassificationResponse?>>
      getMainClassificationsList() async {
    Map<String, dynamic> queryParms = {};

    queryParms = {
      if (CommonProperties.userInfo?.idNo != null &&
          CommonProperties.userInfo!.idNo!.startsWith("1"))
        "NationalID": "${CommonProperties.userInfo!.idNo}"
      else if (CommonProperties.userInfo?.idNo != null)
        "IqamaID": "${CommonProperties.userInfo!.idNo}",
      "type": "INQ",
    };
    // print(queryParms);

    String url = ApiUrl.INQMainClassifications;

    final body = await webServices.getPegaRequest(url, queryParams: queryParms);
    bool state = body['state'];
    dynamic data = body['data'];
    String error = body['error'] ?? ("errors_server_error_1").tr();
    ClassificationResponse? result;

    try {
      ClassificationResponse response =
          ClassificationResponse.fromJson(json.decode(data));
      result = response;
      if (response.data.isEmpty) {
        error = ("main_classification_error").tr();
      }
    } catch (ex) {
      print(ex);
      // error = error ?? Helpers.translatingWord("errors_server_error_1");

      try {
        String queryString = "?" + Uri(queryParameters: queryParms).query;

//MM
        /* Helpers.sendLog(
            url: url,
            data: data,
            qeuryParms: queryString,
            errorMsg: ex.toString());*/
      } catch (ex) {}
    }
    return Tuple3<bool?, String?, ClassificationResponse?>(
        state, error, result);
  }

  Future<Tuple3<bool?, String?, SubMainClassification?>>
      getMainAndSubClassficiation(String splClassID) async {
    Map<String, dynamic> queryParms = {};

    queryParms = {
      if (CommonProperties.userInfo?.idNo != null &&
          CommonProperties.userInfo!.idNo!.startsWith("1"))
        "NationalID": "${CommonProperties.userInfo!.idNo}"
      else if (CommonProperties.userInfo?.idNo != null)
        "IqamaID": "${CommonProperties.userInfo!.idNo}",
      "ID": splClassID,
    };

    String url = ApiUrl.INQMainAndSubClassifications;

    final body = await webServices.getPegaRequest(url, queryParams: queryParms);
    bool state = body['state'];
    dynamic data = body['data'];
    String? error = body['error'];
    SubMainClassification? result;

    try {
      SubMainClassification response =
          SubMainClassification.fromMap(json.decode(data));
      result = response;
    } catch (ex) {
      print(ex);
      error = error ?? ("errors_server_error_1").tr();
      try {
        String queryString = "?" + Uri(queryParameters: queryParms).query;

        //MM     Helpers.sendLog(url: url, data: data, qeuryParms: queryString);
      } catch (ex) {}
    }
    return Tuple3<bool?, String?, SubMainClassification?>(state, error, result);
  }

  Future<Tuple3<bool?, String?, ClassificationResponse?>>
      getSubClassificationsList(String mainClassId) async {
    Map<String, dynamic> queryParms = {};

    queryParms = {
      if (CommonProperties.userInfo?.idNo != null &&
          CommonProperties.userInfo!.idNo!.startsWith("1"))
        "NationalID": "${CommonProperties.userInfo!.idNo}"
      else if (CommonProperties.userInfo?.idNo != null)
        "IqamaID": "${CommonProperties.userInfo!.idNo}",
      "mainClassificationID": mainClassId,
    };
    // print(queryParms);

    String url = ApiUrl.INQSubClassifications;

    final body = await webServices.getPegaRequest(url, queryParams: queryParms);
    bool state = body['state'];
    dynamic data = body['data'];
    String error = body['error'] ?? ("errors_server_error_1").tr();
    ClassificationResponse? result;

    try {
      ClassificationResponse response =
          ClassificationResponse.fromJson(json.decode(data));
      result = response;
      if (response.data.isEmpty) {
        error = ("sub_classification_error").tr();
      }
    } catch (ex) {
      print(ex);
      try {
        String queryString = "?" + Uri(queryParameters: queryParms).query;

        /*  Helpers.sendLog(
            url: url,
            data: data,
            qeuryParms: queryString,
            errorMsg: ex.toString());*/ //MM
      } catch (ex) {}
    }
    return Tuple3<bool?, String?, ClassificationResponse?>(
        state, error, result);
  }

  Future<Tuple3<bool?, String?, ClassificationResponse?>>
      getSplClassificationsList(String subId) async {
    Map<String, dynamic> queryParms = {};

    queryParms = {
      if (CommonProperties.userInfo?.idNo != null &&
          CommonProperties.userInfo!.idNo!.startsWith("1"))
        "NationalID": "${CommonProperties.userInfo!.idNo}"
      else if (CommonProperties.userInfo?.idNo != null)
        "IqamaID": "${CommonProperties.userInfo!.idNo}",
      "subClassificationID": subId,
    };
    // print(queryParms);

    String url = ApiUrl.INQSPLClassifications;

    final body = await webServices.getPegaRequest(url, queryParams: queryParms);
    bool state = body['state'];
    dynamic data = body['data'];
    String error = body['error'] ?? ("errors_server_error_1").tr();
    ClassificationResponse? result;

    try {
      ClassificationResponse response =
          ClassificationResponse.fromJson(json.decode(data));
      result = response;
      if (response.data.isEmpty) {
        error = ("spl_classification_error").tr();
      }
    } catch (ex) {
      print(ex);
    }
    return Tuple3<bool?, String?, ClassificationResponse?>(
        state, error, result);
  }

  Future<Tuple3<bool?, String?, CreateIncidentResult?>> createINQRequest(
    var body,
  ) async {
    String url = ApiUrl.INQCreate;

    final res = await webServices.postPegaRequest(url, body: body);
    print(res);
    bool? state = res['state'];
    dynamic data = res['data'];
    String? error = res['error'];
    //print(data);
    CreateIncidentResult? response;
    try {
      response = CreateIncidentResult.fromJson(json.decode(data));
    } catch (ex) {
      print(ex);
      try {
        // MM  Helpers.sendLog(
        //      url: url, data: data, body: body, errorMsg: ex.toString());
      } catch (ex) {}
    }
    return Tuple3<bool?, String?, CreateIncidentResult?>(
        state, error, response);
  }
}
