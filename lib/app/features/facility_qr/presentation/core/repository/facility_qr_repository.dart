import 'dart:convert';

import 'package:balady_plus/app/core/services/services_exports.dart' as s;
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/features/facility_qr/data/latest_user_rating_response.dart';
import 'package:balady_plus/app/features/facility_qr/data/license_ratings_items.dart';
import 'package:balady_plus/app/features/facility_qr/data/qr_details_response.dart';
import 'package:balady_plus/app/features/facility_qr/data/submit_rating_response.dart';
import 'package:dio/dio.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:tuple/tuple.dart';

import '../../../../../core/base/base_view_model.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/remote_services/api_constants.dart';
import '../../../../../core/remote_services/pega_web_service.dart';
import '../../../../../core/services/local/helpers.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class FacilityQRRepository {
  final webServices = locator<PegaWebService>();
  final newWebServices = locator<s.WebService>();

  Future<QrDetailsResponse?> getEntityDetails(String licenseId) async {
    final body = await webServices.getApigeeRequest(ApiConstants.QrDetailsUrl,
        relativePath: licenseId, autoLogout: false);
    bool state = body['state'];
    dynamic data = body['data'];
    String error = body['error'] ?? ("errors_server_error_1").tr();

    try {
      QrDetailsResponse response =
          QrDetailsResponse.fromJson(json.decode(data));
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
      CommonFunctions.showError(error.toString());

      try {
        Helpers.sendLog(
            url: ApiConstants.QrDetailsUrl,
            data: data,
            qeuryParms: licenseId,
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

  Future<LatestUserRatingResponse?> getUserLatestRating(
      String licenseId) async {
    final body = await webServices.getApigeeRequest(
        ApiConstants.QrLicenseUserLatesetRatingItemsUrl,
        relativePath: licenseId,
        autoLogout: false,
        extraHeadersParams: {
          "loginUsername": CommonProperties.userInfo?.idNo ?? "",
        });
    bool state = body['state'];
    dynamic data = body['data'];
    String error = body['error'] ?? ("errors_server_error_1").tr();
    try {
      LatestUserRatingResponse response =
          LatestUserRatingResponse.fromJson(json.decode(data));
      //if (response != null)
      return response;
      // else
      //   showError(error);
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
            url: ApiConstants.QrLicenseUserLatesetRatingItemsUrl,
            data: data,
            qeuryParms: licenseId,
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
      // showError(error);
    }
  }

  Future<Tuple3<bool?, String?, LicenseRatingItems?>>
      getLicenseRatingitems() async {
    final body = await webServices.getApigeeRequest(
        ApiConstants.QrLicenseRatingItemsUrl,
        autoLogout: false);
    LicenseRatingItems? result;
    bool state = body['state'];
    dynamic data = body['data'];
    String error = ("errors_server_error_1").tr(); //MM
    try {
      result = LicenseRatingItems.fromJson(json.decode(data));
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
            url: ApiConstants.QrLicenseRatingItemsUrl,
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
    return Tuple3<bool?, String?, LicenseRatingItems?>(state, error, result);
  }

  Future<Tuple3<bool?, String?, SubmitRatingResponse?>> postLicenseRatingitems(
      String licenseId, List<RatingItem> ratingItems) async {
    String errorMsg = "";
    SubmitRatingResponse? result;

    try {
      Response body = await newWebServices.dio
          .post("${ApiConstants.QrPostRating}/$licenseId", data: {
        "notes": "",
        "ratings": ratingItems.map((e) {
          return {
            "key": e.id,
            "value": e.value,
          };
        }).toList(),
      });

      result = SubmitRatingResponse.fromJson(body.data);
    } on DioError catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      errorMsg = error.response?.data?["data"]?["responseMessage"] ??
          ("errors_server_error_1").tr();
      //throw ServerException(error.toString(),
      //     statusCode: error.response?.statusCode);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      try {
        // MM send data
        Helpers.sendLog(
            url: ApiConstants.QrPostRating,
            //   data:data,
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

    return Tuple3<bool?, String?, SubmitRatingResponse?>(
        result != null, errorMsg, result);
  }
}
