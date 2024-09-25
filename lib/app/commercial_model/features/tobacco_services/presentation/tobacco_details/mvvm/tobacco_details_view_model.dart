import 'dart:async';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/data/models/allowed_actions.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/data/models/commercial_licence_details.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/data/models/reason_cancel.dart';
import 'package:balady_plus/app/commercial_model/features/tobacco_services/data/models/tobacco_schedule.dart';
import 'package:balady_plus/app/commercial_model/features/tobacco_services/data/repositories/repository_implementation.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';


class TobaccoDetailsViewModel extends BaseViewModel {
  final TobaccoListRepositoryImplementation repository;
  final String identityNumber;
  final String registrationNumber;

  TobaccoSchedule? tobaccoSchedule;
  final ValueNotifier<int?> year = ValueNotifier<int?>(null);

  TobaccoDetailsViewModel(
    this.repository,
    this.identityNumber,
    this.registrationNumber,
  ) {
    getUserFacilitiesDetails();
  }

  Future<void> getUserFacilitiesDetails() async {
    try {
      isLoading = true;
      notifyListeners();
      var response = await repository.getUserFacilitiesDetails(
        registrationNumber,
      );
      response.fold(
        (failure) {
          errorMessage = failure.toString();
        },
        (success) {
          tobaccoSchedule = success;
          if (tobaccoSchedule != null) {
            year.value = tobaccoSchedule!.years.first;
            year.notifyListeners();
          }
        },
      );
      isLoading = false;
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      errorMessage = error.toString();
      isLoading = false;
    }
    notifyListeners();
  }

  /////////////////////////////////////////////////////////
  void setDisclosureSchedules(int? year) {
    this.year.value = year;
    this.year.notifyListeners();
  }
///////////////////////////////////
}
