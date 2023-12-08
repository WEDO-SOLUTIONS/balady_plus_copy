import 'dart:async';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/commercial_license_cancel/data/models/submit_response.dart';
import 'package:dio/dio.dart';

class SubmitRatingViewModel extends BaseViewModel {
  final WebService webService;
  final SubmitResponse submitResponse;
  int? responseRating;

  SubmitRatingViewModel({
    required this.webService,
    required this.submitResponse,
  });

  Future<int?> addCommercialLicenseCancelSubmitRating(
      int value, String remarks) async {
    Response? response;
    try {
      isLoading = true;
      notifyListeners();
      response = await webService.dio.post(
        ApiUrl.commercialLicenseCancelSubmitRating,
        data: {
          "engOfficeId": null,
          "origin": "BENIFICIARY",
          "remarks": remarks,
          "requestId": submitResponse.requestId,
          "value": value
        },
      );
      final data = response.data;
      final result = ResponseBodyModel.fromMap(data).data?.result;
      responseRating = result;
    } on Exception catch (exception) {
      CommonFunctions.sendEvent(
        dioError: exception is DioException ? exception :  null,
        response: response,
        ex: exception,
      );
      showError(exception.toString());
    } catch (exception) {
      CommonFunctions.sendEvent(
        dioError: null,
        response: response,
        ex: Exception(exception.toString()),
      );
      showError(exception.toString());
    }
    isLoading = false;
    notifyListeners();
    return null;
  }
}
