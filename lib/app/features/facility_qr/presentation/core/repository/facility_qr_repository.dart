import 'dart:convert';

import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/features/facility_qr/data/latest_user_rating_response.dart';
import 'package:balady_plus/app/features/facility_qr/data/license_ratings_items.dart';
import 'package:balady_plus/app/features/facility_qr/data/qr_details_response.dart';
import 'package:balady_plus/app/features/facility_qr/data/submit_rating_response.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:tuple/tuple.dart';

import '../../../../../core/base/base_view_model.dart';
import '../../../../../core/remote_services/api_constants.dart';
import '../../../../../core/remote_services/web_service.dart';
import '../../../../../core/services/local/helpers.dart';

class FacilityQRRepository {
  final webServices = locator<WebService>();

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
    } catch (ex) {
      print(ex);
      CommonFunctions.showError(error);

      try {
        Helpers.sendLog(
            url: ApiConstants.QrDetailsUrl,
            data: data,
            qeuryParms: licenseId,
            errorMsg: ex.toString());
      } catch (ex) {}
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
    } catch (ex) {
      print(ex);
      try {
        Helpers.sendLog(
            url: ApiConstants.QrLicenseUserLatesetRatingItemsUrl,
            data: data,
            qeuryParms: licenseId,
            errorMsg: ex.toString());
      } catch (ex) {}
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
    String error = "لل"; //body['error'] ?? ("errors_server_error_1").tr; //MM
    try {
      result = LicenseRatingItems.fromJson(json.decode(data));
      if (!state) {
        error = result.data?.responseMessage ?? error;
      }
    } catch (ex) {
      print(ex);
      try {
        Helpers.sendLog(
            url: ApiConstants.QrLicenseRatingItemsUrl,
            data: data,
            errorMsg: ex.toString());
      } catch (ex) {}
    }
    return Tuple3<bool?, String?, LicenseRatingItems?>(state, error, result);
  }

  Future<Tuple3<bool?, String?, SubmitRatingResponse?>> postLicenseRatingitems(
      String licenseId, List<RatingItem> ratingItems) async {
    final body = await webServices.postApigeeRequest(ApiConstants.QrPostRating,
        relativePath: licenseId,
        body: {
          "notes": "",
          "ratings": ratingItems.map((e) {
            return {
              "key": e.id,
              "value": e.value,
            };
          }).toList(),
          "userBirthDate":
              CommonProperties.userInfo?.getFormattedBirthDate() ?? ""
        },
        extraHeadersParams: {
          "loginUsername": CommonProperties.userInfo?.idNo ?? "",
        });
    bool state = body['state'];
    dynamic data = body['data'];
    String error = body['error'] ?? ("errors_server_error_1").tr();
    SubmitRatingResponse? result;
    try {
      result = SubmitRatingResponse.fromJson(json.decode(data));

      if (!state) {
        error = result.responseMessage ?? error;
      }
    } catch (ex) {
      print(ex);
      try {
        Helpers.sendLog(
            url: ApiConstants.QrPostRating,
            data: data,
            errorMsg: ex.toString());
      } catch (ex) {}
    }

    return Tuple3<bool?, String?, SubmitRatingResponse?>(state, error, result);
  }
}
