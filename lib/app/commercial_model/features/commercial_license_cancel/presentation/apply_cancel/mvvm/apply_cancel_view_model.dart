import 'dart:async';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_cancel/data/models/cancellation_rquest_response.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/data/models/commercial_licence_details.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/data/models/reason_cancel.dart';
import 'package:dio/dio.dart';
import 'package:balady_plus/app/commercial_model/commercial_model_end_points.dart';

class ApplyCancelViewModel extends BaseViewModel {
  final WebService webService;
  final int licenseId;
  final SubmitterInfo submitterInfo;
  final ReasonCancel reasonCancel;
  String? messageHtml;
  ApplyCancelViewModel({
    required this.webService,
    required this.licenseId,
    required this.reasonCancel,
    required this.submitterInfo,
  });

  Future<CancellationRequestResponse?>
      applyCommercialLicenseCancellation() async {
    isLoading = true;
    notifyListeners();
    Response? response;
    try {
      response = await webService.dio.post(
        CommercialModelEndPoints.commercialLicenseApplyCancel(licenseId),
        data: {
          "submitterType": submitterInfo.submitterType,
          "crNumber": submitterInfo.crNumber,
        },
      );
      final data = response.data;
      final result = ResponseBodyModel.fromMap(data).data?.result;
      isLoading = false;
      notifyListeners();
      return CancellationRequestResponse.fromJson(result);
    } on Exception catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      String message = error.toString();
      if (message.contains('href')) {
        messageHtml = message;
      } else {
        showError(message);
      }
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
    isLoading = false;
    notifyListeners();
    return null;
  }
}
