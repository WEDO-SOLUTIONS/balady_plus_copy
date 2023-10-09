import 'dart:async';
import 'dart:io';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/entities/file_data_item.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/commercial_license_cancel/data/models/commercial_license_permits.dart';
import 'package:balady_plus/app/features/commercial_license_cancel/data/models/submit_response.dart';
import 'package:balady_plus/app/features/commercial_license_details/data/models/allowed_actions.dart';
import 'package:balady_plus/app/features/create_compliance/data/models/comliance_request_details_model.dart';
import 'package:dio/dio.dart';

class SubmitRatingViewModel extends BaseViewModel {
  final WebService webService;
  final SubmitResponse submitResponse;
  Map<String, dynamic>? responseRating;

  SubmitRatingViewModel({
    required this.webService,
    required this.submitResponse,
  });

  Future<Map?> addCommercialLicenseCancelSubmitRating(
      int value, String remarks) async {
    try {
      isLoading = true;
      notifyListeners();
      var response = await webService.dio
          .post(ApiUrl.commercialLicenseCancelSubmitRating, data: {
        "engOfficeId": null,
        "origin": "BENIFICIARY",
        "remarks": remarks,
        "requestId": submitResponse.requestId,
        "value": value
      });
      final data = response.data;
      final result = ResponseBodyModel.fromMap(data).data?.result;
      responseRating = result;
      return responseRating;
    } catch (e) {
      showError(e.toString());
    }
    isLoading = false;
    notifyListeners();
    return null;
  }
}
