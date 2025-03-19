import 'dart:async';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_cancel/data/models/cancellation_rquest_response.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/data/models/allowed_actions.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/data/models/commercial_licence_details.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/data/models/reason_cancel.dart';
import 'package:balady_plus/app/commercial_model/features/request_commercial_license_details/data/models/request_allowed_actions.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:balady_plus/app/commercial_model/commercial_model_end_points.dart';


class RequestCommercialLicenseActionViewModel extends BaseViewModel {
  final WebService webService;
  final int requestId;
  final bool isFromInitialApproval;
  final requestTypeId;
  final ReasonCancel? reasonCancel;
  final bool availableCloseDate;

  List<RequestAllowedActions> actions = [];

  RequestCommercialLicenseActionViewModel({
    required this.webService,
    required this.requestId,
    required this.isFromInitialApproval,
    required this.reasonCancel,
    this.requestTypeId,
    required this.availableCloseDate,
  }) {
    getCommercialLicenseAllowedActions();
  }

  Future<void> getCommercialLicenseAllowedActions() async {
    try {
      isLoading = true;
      notifyListeners();
      var response = await webService.dio
          .get(CommercialModelEndPoints.getAllowedActionsForRequests(requestId));
      final data = response.data;
      final result = ResponseBodyModel.fromMap(data).data?.result;
      actions = requestAllowedActionsListFromJson(result)
          .where((element) => element.id == "edit")
          .toList();
      // actions = actions;
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
