import 'dart:async';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/_shared_features/rating_feature/models/rating_request.dart';
import 'package:dio/dio.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class SubmitRatingViewModel extends BaseViewModel {
  final WebService webService;
  final RatingRequest ratingRequest;

  SubmitRatingViewModel({
    required this.webService,
    required this.ratingRequest,
  });

  Future<int?> submitRating() async {
    Response? response;
    try {
      isLoading = true;
      notifyListeners();
      String apiUrl = ApiUrl.submitRating;
      // Check if send servicesTypeId add this to url to call other API
      // First API depend on requestId, second depend on servicesTypeId
      if (ratingRequest.servicesTypeId != null) {
        apiUrl = "$apiUrl/${ratingRequest.servicesTypeId}";
      }
      response = await webService.dio.post(
        apiUrl,
        data: ratingRequest.toJson(),
      );
      final data = response.data;
      final result = ResponseBodyModel.fromMap(data).data?.result;
      return result;
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
    isLoading = false;
    notifyListeners();
    return null;
  }
}
