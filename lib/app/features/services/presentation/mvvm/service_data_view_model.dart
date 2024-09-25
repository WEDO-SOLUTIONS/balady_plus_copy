import 'dart:async';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/services/data/models/services_cards_details.dart';
import 'package:dio/dio.dart';
import 'package:dio/src/response.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

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
    } on Exception catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      showError(error.toString());
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      showError(error.toString());
    }
    hideLoader();
    return null;
  }
}
