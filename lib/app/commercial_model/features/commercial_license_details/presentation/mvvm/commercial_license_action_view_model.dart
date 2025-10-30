import 'dart:async';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/errors/errors_exports.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/data/models/allowed_actions.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/data/models/commercial_licence_details.dart';
import 'package:dio/dio.dart';

import 'package:balady_plus/app/commercial_model/commercial_model_end_points.dart';


class CommercialLicenseActionViewModel extends BaseViewModel {
  final WebService webService;
  final int licenseId;
  final SubmitterInfo submitterInfo;
  CommercialLicenceDetails? commercialLicenceDetails;

  List<AllowedActions> actions = [];

  CommercialLicenseActionViewModel(
      {required this.webService,
      required this.licenseId,
      required this.submitterInfo,
      this.commercialLicenceDetails}) {
    getCommercialLicenseAllowedActions();
  }

  Future<void> getCommercialLicenseAllowedActions() async {
    Response? response;
    try {
      isLoading = true;
      notifyListeners();
      response = await webService.dio
          .get(CommercialModelEndPoints.getCommercialLicenseAllowedActions(licenseId));
      final data = response.data;
      final result = ResponseBodyModel.fromMap(data).data?.result;
      actions = allowedActionsListFromJson(result);

      //actions = actions.where((element) => element.id == 1008).toList();
    } on Exception catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
    isLoading = false;
    notifyListeners();
  }
}
