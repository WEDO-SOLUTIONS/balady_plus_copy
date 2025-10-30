import 'dart:async';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/jod_services/presentation/models/regions.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class JodDonationViewModel extends BaseViewModel {
  final WebService repository;
  double? amount;
  TextEditingController textController = TextEditingController();

  List<Regions>? regions;
  Regions? region;

  JodDonationViewModel(this.repository) {
    getRegions();
  }

  Future getJoodEskanServicesGenerateDonationUrl() async {
    isLoading = true;
    notifyListeners();
    Response? response;
    try {
      Map<String, dynamic> queryParameters = {
        "amount": amount?.toInt(),
        "locale": "ar",
        "region": region!.code,
        "agentId": 1,
      };
      if (CommonProperties.userInfo != null) {
        queryParameters['mobile'] = CommonProperties.userInfo!.phone!;
      }
      response = await repository.dio.get(
        ApiUrl.joodEskanGenerateDonation,
        queryParameters: queryParameters,
      );
      final data = response.data;
      final result = ResponseBodyModel.fromMap(data).data?.result;
      isLoading = false;
      notifyListeners();
      return result['url'];
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
  }

  Future getRegions() async {
    isLoading = true;
    notifyListeners();
    Response? response;
    try {
      response = await repository.dio.get(ApiUrl.joodEskanRegions);
      final data = response.data;
      List result = ResponseBodyModel.fromMap(data).data?.result;
      regions = result.map((e) => Regions.fromMap(e)).toList();
      isLoading = false;
      notifyListeners();
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
  }

  void setAmount(double amount) {
    this.amount = amount;
    textController.text = "$amount";
    notifyListeners();
  }

  void setAmountNotInsertTextFiled(double amount) {
    this.amount = amount;
    notifyListeners();
  }

  void selectedRegion(Regions item) {
    region = item;
    notifyListeners();
  }
}
