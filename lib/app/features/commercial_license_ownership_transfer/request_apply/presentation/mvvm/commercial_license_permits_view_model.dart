import 'dart:async';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/commercial_license_cancel/data/models/commercial_license_permits.dart';
import 'package:dio/dio.dart';

class CommercialLicensePermitsViewModel extends BaseViewModel {
  final WebService webService;
  final int requestId;

  List<CommercialLicensePermits>? permits;

  CommercialLicensePermitsViewModel(
      {required this.webService, required this.requestId}) {
    getCommercialLicensePermits();
  }

  Future<void> getCommercialLicensePermits() async {
    Response? response;
    try {
      isLoading = true;
      notifyListeners();
      response = await webService.dio.get(
        ApiUrl.commercialLicensePermits(requestId),
      );
      final data = response.data;
      final result = ResponseBodyModel.fromMap(data).data?.result;
      permits = result
          .map<CommercialLicensePermits>((e) =>
              CommercialLicensePermits.fromJson(e as Map<String, dynamic>))
          .toList();
    } on Exception catch (exception) {
      CommonFunctions.sendEvent(
        dioError: exception is DioException ? exception : null,
        response: response,
        ex: exception,
      );
    } catch (exception) {
      CommonFunctions.sendEvent(
        dioError: null,
        response: response,
        ex: Exception(exception.toString()),
      );
    }
    isLoading = false;
    notifyListeners();
  }
}
