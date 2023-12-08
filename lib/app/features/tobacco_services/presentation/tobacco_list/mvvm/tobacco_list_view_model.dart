import 'dart:async';

import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/commercial_license_details/data/models/allowed_actions.dart';
import 'package:balady_plus/app/features/commercial_license_details/data/models/commercial_licence_details.dart';
import 'package:balady_plus/app/features/commercial_license_details/data/models/reason_cancel.dart';
import 'package:balady_plus/app/features/tobacco_services/data/models/facility.dart';
import 'package:balady_plus/app/features/tobacco_services/data/repositories/repository_implementation.dart';
import 'package:dio/dio.dart';

class TobaccoListViewModel extends BaseViewModel {
  final TobaccoListRepositoryImplementation repository;
  List<Facility>? facilities;

  TobaccoListViewModel(this.repository) {
    getUserFacilities();
  }

  Future<void> getUserFacilities() async {
    try {
      isLoading = true;
      errorMessage = null ;
      notifyListeners();
      var response = await repository.getUserFacilities(
        "1005830086",
      );
      response.fold(
        (failure) {
          errorMessage = failure.toString();
        },
        (facilities) {
          this.facilities = facilities;
        },
      );
      isLoading = false;
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
    }
    notifyListeners();
  }
}
