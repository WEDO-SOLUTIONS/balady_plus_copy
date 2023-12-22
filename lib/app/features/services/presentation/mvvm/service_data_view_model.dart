import 'dart:async';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/commercial_license_cancel/data/models/cancellation_rquest_response.dart';
import 'package:balady_plus/app/features/commercial_license_details/data/models/commercial_licence_details.dart';
import 'package:balady_plus/app/features/commercial_license_details/data/models/reason_cancel.dart';
import 'package:balady_plus/app/features/services/data/models/services_cards_details.dart';
import 'package:dio/dio.dart';
import 'package:dio/src/response.dart';

class ServiceDataViewModel extends BaseViewModel {
  final WebService webService;
  final int serviceId;

  ServicesCardsDetails? servicesCardsDetails;

  ServiceDataViewModel({
    required this.webService,
    required this.serviceId,
  }) {
    getServicesCards();
  }

  Future getServicesCards() async {
    showLoader();
    notifyListeners();
    Response? response;
    try {
      response = await webService.dio.get(ApiUrl.getServicesCards(serviceId));
      final data = response.data;
      final result = ResponseBodyModel.fromMap(data).data?.result;
      servicesCardsDetails = ServicesCardsDetails.fromJson(result[0]);
      hideLoader();
    } on Exception catch (exception) {
      CommonFunctions.sendEvent(
        dioError: exception is DioException ? exception : null,
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
    hideLoader();
    return null;
  }
}
