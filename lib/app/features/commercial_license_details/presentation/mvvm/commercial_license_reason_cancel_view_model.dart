import 'dart:async';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/commercial_license_details/data/models/allowed_actions.dart';
import 'package:balady_plus/app/features/commercial_license_details/data/models/commercial_licence_details.dart';
import 'package:balady_plus/app/features/commercial_license_details/data/models/reason_cancel.dart';
import 'package:dio/dio.dart';

class CommercialLicenseReasonCancelViewModel extends BaseViewModel {
  final WebService webService;
  final int licenseId;
  final SubmitterInfo? submitterInfo;
  List<ReasonCancel> reasonCancelList = [];
  ReasonCancel? reasonCancel;

  CommercialLicenseReasonCancelViewModel({
    required this.submitterInfo,
    required this.webService,
    required this.licenseId,
  }) {
    getCommercialLicenseCancellationReasons();
  }

  Future<void> getCommercialLicenseCancellationReasons() async {
    Response? response;
    try {
      isLoading = true;
      notifyListeners();
      response =
          await webService.dio.get(ApiUrl.commercialLicenseCancellationReasons);
      final data = response.data;
      final result = ResponseBodyModel.fromMap(data).data?.result;
      reasonCancelList = result
          .map<ReasonCancel>(
              (e) => ReasonCancel.fromJson(e as Map<String, dynamic>))
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

  void selectReasonCancel(ReasonCancel? selectReasonCancel) {
    reasonCancel = selectReasonCancel;
    notifyListeners();
  }
}
