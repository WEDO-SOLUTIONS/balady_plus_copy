import 'dart:io';
import 'dart:typed_data';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tuple/tuple.dart';

import '../../../../../../core/base/base_view_model.dart';
import '../../../../../../core/services/local/navigation_services.dart';
import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../_shared_feature_/data/entities/success_screen_args.dart';
import '../../models/appointment_details_model.dart';
import '../../models/cancel_appointment_response.dart';
import '../../models/confirm_appointment_response.dart';
import '../repository/appointment_repository.dart';

class AppointmentDetailsViewModel extends BaseViewModel {
  final _repository = locator<AppointmentRepository>();

  AppointmentDetails? appointmentDetailsVariable;
  bool? isCancelable;
  bool? isPrintable;
  int? appointmentID;

  AppointmentDetailsViewModel(
      {this.appointmentID,
      this.appointmentDetailsVariable,
      this.isCancelable,
      this.isPrintable});

  AppointmentDetails? appointmentDetailsResponse;

  bool fromHomePage = false;

  Future<bool> getAppointmentDetailsResponse(int appointmentId) async {
    showLoading();
    Tuple3<bool?, String?, AppointmentDetails?> response =
        await _repository.getAppointmentDetails(appointmentId);
    hideLoading();
    if (response.item1 != null &&
        response.item1! &&
        response.item3?.data?.result != null) {
      appointmentDetailsResponse = response.item3;
      return true;
    } else {
      showError(response.item2 ?? "");
    }
    return false;
  }

  Future<bool> getAppointmentDetails(int appointmentId) async {
    showLoader();
    bool isSuccess = false;
    isSuccess = await getAppointmentDetailsResponse(appointmentId);
    hideLoader();
    return isSuccess;
  }

  AppointmentItemInfo getAppointmentsInfo() {
    try {
      return appointmentDetailsResponse?.data?.result ?? AppointmentItemInfo();
    } catch (e) {
      print(e);
      return AppointmentItemInfo();
    }
  }

  // bool showCancelButton() {
  //   print("showCancelButton");
  //   print(appointmentDetails?.data?.result?.cancelable);
  //   return appointmentDetails?.data?.result?.cancelable ?? false;
  // }
  //
  // bool isPrintableAppointment() {
  //   print("isPrintableAppointment");
  //   print(appointmentDetails?.data?.result?.printable);
  //   return appointmentDetails?.data?.result?.printable ?? false;
  // }

  Future<Tuple2<Uint8List?, String?>> printAppointment(
      int appointmentId) async {
    showLoading();

    Tuple4<bool?, String?, Uint8List?, String?> response =
        await _repository.printAppointment(appointmentId);
    hideLoading();
    if (response.item3 != null && response.item1 != null && response.item1!) {
      return Tuple2<Uint8List?, String?>(response.item3, response.item4);
    } else {
      showError(response.item2 ?? "");
    }
    return Tuple2<Uint8List?, String?>(response.item3, response.item4);
  }

  void printAppointmentFunction(int appointmentId) async {
    if (appointmentId != null) {
      Tuple2<Uint8List?, String?> res = await printAppointment(appointmentId);
      if (res.item1 != null) openFile(res.item1!, contentType: res.item2);
    }
  }

  void shareAppointmentFunction(int appointmentId) async {
    if (appointmentId != null) {
      Tuple2<Uint8List?, String?> res = await printAppointment(appointmentId);
      if (res.item1 != null) shareFile(res.item1!, contentType: res.item2);
    }
  }

  void shareFile(Uint8List bytes, {String? contentType}) async {
    String extension =
        contentType != null ? ("." + contentType.split("/").last) : "";
    try {
      if (extension.isNotEmpty) {
        String dir = (await getTemporaryDirectory()).path;
        File filetemp = File("$dir/" +
            "${DateTime.now().millisecondsSinceEpoch.toString()}$extension");
        await filetemp.writeAsBytes(bytes);
        // print(filetemp.path);
        Share.shareFiles([filetemp.path]);
      }
    } catch (ex) {
      print(ex);
    }
  }

  void openFile(Uint8List bytes, {String? contentType}) async {
    print("content toye");
    print(contentType);
    String extension =
        contentType != null ? ("." + contentType.split("/").last) : "";
    try {
      if (extension.isNotEmpty) {
        String dir = (await getTemporaryDirectory()).path;
        File filetemp = File("$dir/" +
            "${DateTime.now().millisecondsSinceEpoch.toString()}$extension");
        await filetemp.writeAsBytes(bytes);
        //print(filetemp.path);
        OpenFile.open(filetemp.path);
      }
    } catch (ex) {
      print(ex);
    }
  }

  Future<CancelAppointmentResponse?> cancelAppointment() async {
    CancelAppointmentResponse? result = await cancelAppointmentApi(
        appointmentDetailsResponse?.data?.result?.id ?? 0);

    return result;
  }

  Future<ConfirmAppointmentResponse?> confirmAppointment() async {
    ConfirmAppointmentResponse? result = await confirmAppointmentApi(
        appointmentDetailsResponse?.data?.result?.uuid ?? "");

    return result;
  }

  Future<CancelAppointmentResponse?> cancelAppointmentApi(
      int requestNumber) async {
    showLoading();
    Tuple3<bool?, String?, CancelAppointmentResponse?> response =
        await _repository.cancelAppointment(requestNumber);
    hideLoading();
    if (response.item3 != null &&
        response.item3?.data != null &&
        response.item1 != null &&
        response.item1!) {
      return response.item3;
    } else {
      showError(response.item2 ?? "");
    }
    return null;
  }

  Future<ConfirmAppointmentResponse?> confirmAppointmentApi(
      String requestNumber) async {
    showLoading();
    Tuple3<bool?, String?, ConfirmAppointmentResponse?> response =
        await _repository.confirmAppointment(requestNumber);
    hideLoading();
    if (response.item3 != null &&
        response.item3?.data != null &&
        response.item1 != null &&
        response.item1!) {
      return response.item3;
    } else {
      showError(response.item2 ?? "");
    }
    return null;
  }

  void reset() {
    appointmentDetailsResponse = null;
  }
}
