import 'dart:async';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/commercial_model/features/tobacco_services/data/models/facility.dart';
import 'package:balady_plus/app/commercial_model/features/tobacco_services/data/repositories/repository_implementation.dart';
import 'package:localize_and_translate/localize_and_translate.dart';


import 'package:balady_plus/app/events_logs/balady_logs.dart';


class TobaccoListViewModel extends BaseViewModel {
  final TobaccoListRepositoryImplementation repository;
  List<Facility>? facilities;

  TobaccoListViewModel(this.repository) {
    getUserFacilities();
  }

  Future<void> getUserFacilities() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();
      var response = await repository.getUserFacilities();
      response.fold(
        (failure) {
          errorMessage = failure.toString();
        },
        (facilities) {
          this.facilities = facilities;
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
      errorMessage = "error_please_try_again_later".tr();
      isLoading = false;
    }
    notifyListeners();
  }
}
