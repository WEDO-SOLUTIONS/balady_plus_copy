import 'dart:async';

import 'dart:typed_data';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../../../../../../core/base/base_view_model.dart';

import '../../models/available_dates_response.dart';
import '../../models/available_times_response.dart';
import '../../models/save_appointment_reseponse.dart';
import 'new_appointment_view_model.dart';

class NewAppointmentSecondStepViewModel extends BaseViewModel {
  final dataModel = locator<NewAppointmentViewModel>();

  set fromHomePage(bool? fromPage) =>
      dataModel.fromHomePage = fromPage ?? false;

  bool? get getFromHomePage => dataModel.fromHomePage;

  StreamController<bool> isFormValid = StreamController<bool>();

  int? get serviceId => dataModel.serviceConfigResponse?.data?.result?[0].id;

  TimeItem? get selectedTime => dataModel.selectedTime;

  DateItem? get selectedDate => dataModel.selectedDate;

// AvailableTimesResponse? get getAvailableTimesResponse =>
  //     dataModel.availableTimesResponse;

  AvailableDatesResponse? get availableDatesResponse =>
      dataModel.availableDatesResponse;

  //List<TimeItem> get getTimesTable =>
  //   dataModel.availableTimesResponse?.data?.result ?? [];

  List<DateItem> get getDatesTable =>
      dataModel.availableDatesResponse?.data?.result ?? [];

  // set setAvailableTimesResponse(AvailableTimesResponse? data) =>
  //  dataModel.availableTimesResponse = data;

  /*Future<bool> getAvailableTimes(int serviceId, String date) async {
    bool isSucess = await dataModel.getAvailableTimes(serviceId, date);
    notifyListeners();
    return isSucess;
  }*/

  set selectedTime(TimeItem? timeItem) {
    if (timeItem != null) {
      TimeItem? e = selectedDate?.times
          ?.firstWhereOrNull((element) => element.timeKey == timeItem.timeKey);
      if (e != null) {
        dataModel.selectedTime = e;
      }
    } else {
      dataModel.selectedTime = null;
    }
    notifyListeners();
  }

  set selectedDate(DateItem? dateItem) {
    if (dateItem != null) {
      DateItem? e = availableDatesResponse?.data?.result
          ?.firstWhereOrNull((element) => element.date == dateItem.date);
      if (e != null) {
        dataModel.selectedDate = e;
      }
    }
    notifyListeners();
  }

  void reset() {
    dataModel.init();
    isFormValid = StreamController<bool>();
  }

  void resetVariables() {
    dataModel.init();
    isFormValid = StreamController<bool>();
  }

  Future<bool> saveAppointment() async {
    SaveAppointmentResponse? response = await dataModel.saveAppointment();
    notifyListeners();

    return response != null;
  }

  Future<bool> updateAppointment() async {
    SaveAppointmentResponse? response = await dataModel.updateAppointment();
    notifyListeners();

    return response != null;
  }
}
