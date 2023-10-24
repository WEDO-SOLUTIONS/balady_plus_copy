import 'dart:async';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/errors/errors_exports.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/commercial_license_details/data/models/allowed_actions.dart';
import 'package:balady_plus/app/features/commercial_license_details/data/models/commercial_licence_details.dart';
import 'package:dio/dio.dart';

class CommercialLicenseActionViewModel extends BaseViewModel {
  final WebService webService;
  final int licenseId;
  final SubmitterInfo submitterInfo;

  List<AllowedActions> actions = [];

  CommercialLicenseActionViewModel({
    required this.webService,
    required this.licenseId,
    required this.submitterInfo,
  }) {
    getCommercialLicenseAllowedActions();
  }

  Future<void> getCommercialLicenseAllowedActions() async {
    Response? response;
    try {
      isLoading = true;
      notifyListeners();
      response = await webService.dio
          .get(ApiUrl.getCommercialLicenseAllowedActions(licenseId));
      final data = response.data;
      final result = ResponseBodyModel.fromMap(data).data?.result;
      actions = allowedActionsListFromJson(result);
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
