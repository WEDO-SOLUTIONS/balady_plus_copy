import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tuple/tuple.dart';

import '../../../../../../core/base/base_view_model.dart';
import '../../models/health_request_details.dart';
import '../../models/rating_info_response.dart';
import '../repository/health_license_repository.dart';

class MainHealthLicenseViewModel extends BaseViewModel {
  final _rpository = locator<HealthLicenseRepository>();

  RatingInfoResponse? newRatingResponse;
  RatingInfoResponse? renewRatingResponse;
  RatingInfoResponse? cancelRatingResponse;

  Future<HealthRequestDetails?> getHealthRequestDetails(int requestId,
      {bool showErrorAndLoad = true}) async {
    if (showErrorAndLoad) showLoading();
    HealthRequestDetails? result;
    Tuple3<bool?, String?, HealthRequestDetails?> response =
        await _rpository.getHealthRequestDetails(requestId);
    if (showErrorAndLoad) hideLoading();
    if (response.item1 != null &&
        response.item1! &&
        response.item3?.data?.result != null) {
      result = response.item3;
    } else {
      if (showErrorAndLoad) showError(response.item2 ?? "");
    }
    return result;
  }

  Future<bool> getNewServiceRating() async {
    // showLoading();
    if (newRatingResponse != null) return true;
    Tuple3<bool?, String?, RatingInfoResponse?> response =
        await _rpository.getRatingInfo("1301");
    // hideLoading();
    if (response.item1 != null &&
        response.item1! &&
        response.item3?.data?.result != null) {
      newRatingResponse = response.item3;
      return true;
    } else {
      //  showError(response.item2 ?? "");
    }
    return false;
  }

  Future<bool> getReNewServiceRating() async {
    // showLoading();
    if (renewRatingResponse != null) return true;
    Tuple3<bool?, String?, RatingInfoResponse?> response =
        await _rpository.getRatingInfo("1303");
    // hideLoading();
    if (response.item1 != null &&
        response.item1! &&
        response.item3?.data?.result != null) {
      renewRatingResponse = response.item3;
      return true;
    } else {
      //  showError(response.item2 ?? "");
    }
    return false;
  }

  Future<bool> getCancelServiceRating() async {
    // showLoading();
    if (cancelRatingResponse != null) return true;
    Tuple3<bool?, String?, RatingInfoResponse?> response =
        await _rpository.getRatingInfo("1302");
    // hideLoading();
    if (response.item1 != null &&
        response.item1! &&
        response.item3?.data?.result != null) {
      cancelRatingResponse = response.item3;
      return true;
    } else {
      //  showError(response.item2 ?? "");
    }
    return false;
  }

  @override
  showLoading() {
    //return super.showLoading();
    EasyLoading.show();
  }

  @override
  hideLoading() {
    //return super.showLoading();
    EasyLoading.dismiss();
  }
}
