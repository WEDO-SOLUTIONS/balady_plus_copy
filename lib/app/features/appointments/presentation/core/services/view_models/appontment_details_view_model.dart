import 'dart:io';
import 'dart:typed_data';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tuple/tuple.dart';

import '../../../../../../core/base/base_view_model.dart';
import '../../../../../../core/services/local/navigation_services.dart';
import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../_shared_feature_/data/entities/drop_down_item.dart';
import '../../../../../_shared_feature_/data/entities/success_screen_args.dart';
import '../../../../../new_appointment/presentation/core/models/appointment_details_model.dart';
import '../../../../../new_appointment/presentation/core/models/cancel_appointment_response.dart';
import '../../../../../new_appointment/presentation/core/models/confirm_appointment_response.dart';
import '../../../../../new_appointment/presentation/core/models/lookup_list_model.dart';
import '../../../../../new_appointment/presentation/core/services/repository/appointment_repository.dart';
import 'my_appointments_view_model.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';


class AppointmentDetailsViewModel extends BaseViewModel {
  final _repository = locator<AppointmentRepository>();

  AppointmentDetails? appointmentDetailsVariable;
  bool? isCancelable;
  bool? isPrintable;
  int? appointmentID;
  LookUpList? cancelReasonsList;
  DropDownItem? selectedCancelReason;
  LookUpItem? selectedCancelReasonItem;
  List<DropDownItem> cancelList = [];
  String? cancelReason;

  AppointmentDetailsViewModel(
      {this.appointmentID, this.appointmentDetailsVariable, this.isCancelable, this.isPrintable});

  AppointmentDetails? appointmentDetailsResponse;

  bool fromHomePage = false;

  Future<bool> getAppointmentDetailsResponse(int appointmentId) async {
    isLoading = true;
    notifyListeners();
    Tuple3<bool?, String?, AppointmentDetails?> response = await _repository.getAppointmentDetails(appointmentId);
    if (response.item1 != null && response.item1! && response.item3?.data?.result != null) {
      appointmentDetailsResponse = response.item3;
      isLoading = false;
      notifyListeners();
      return true;
    } else {
      showError(response.item2 ?? "");
    }
    isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> getAppointmentDetails(int appointmentId) async {
    bool isSuccess = false;
    isSuccess = await getAppointmentDetailsResponse(appointmentId);
    return isSuccess;
  }

  AppointmentItemInfo getAppointmentsInfo() {
    try {
      return appointmentDetailsResponse?.data?.result ?? AppointmentItemInfo();
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      return AppointmentItemInfo();
    }
  }

  Future<Tuple2<Uint8List?, String?>> printAppointment(int appointmentId) async {
    showLoading();

    Tuple4<bool?, String?, Uint8List?, String?> response = await _repository.printAppointment(appointmentId);
    hideLoading();
    if (response.item3 != null && response.item1 != null && response.item1!) {
      return Tuple2<Uint8List?, String?>(response.item3, response.item4);
    } else {
      showError(response.item2 ?? "");
    }
    return Tuple2<Uint8List?, String?>(response.item3, response.item4);
  }

  void printAppointmentFunction(int appointmentId) async {
    Tuple2<Uint8List?, String?> res = await printAppointment(appointmentId);
    if (res.item1 != null) openFile(res.item1!, contentType: res.item2);
  }

  void shareAppointmentFunction(int appointmentId) async {
    Tuple2<Uint8List?, String?> res = await printAppointment(appointmentId);
    if (res.item1 != null) shareFile(res.item1!, contentType: res.item2);
  }

  void shareFile(Uint8List bytes, {String? contentType}) async {
    String extension = contentType != null ? (".${contentType.split("/").last}") : "";
    try {
      if (extension.isNotEmpty) {
        Share.shareXFiles([XFile.fromData(bytes)]);
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
    }
  }

  void openFile(Uint8List bytes, {String? contentType}) async {
    String extension = contentType != null ? (".${contentType.split("/").last}") : "";
    try {
      if (extension.isNotEmpty) {
        String dir = (await getTemporaryDirectory()).path;

        File filetemp = File("$dir/" "${DateTime.now().millisecondsSinceEpoch.toString()}$extension");
        await filetemp.writeAsBytes(bytes);

        OpenFile.open(filetemp.path).then(
          (value) => CommonFunctions.sendEvent(
            dioError: DioException(requestOptions: RequestOptions(baseUrl: "OpenFile")),
            ex: Exception(value),
          ),
        );
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
  }

  Future<CancelAppointmentResponse?> cancelAppointment() async {
    CancelAppointmentResponse? result = await cancelAppointmentApi(
        appointmentDetailsResponse?.data?.result?.id ?? 0, [selectedCancelReasonItem!], cancelReason);
    if (result != null && result.data?.result != null && result.data?.result == true) {
      locator<MyAppointmentsViewModel>().getMyAppointments();
      locator<MyAppointmentsViewModel>().getMyPreviousAppointments(pageIndex: 0);

      NavigationService.navigatorKey.currentState!.pushNamedAndRemoveUntil(
          RouteName.successRoute, ModalRoute.withName(RouteName.AppointmentsListScreen),
          arguments: SuccessScreenArgs(type: PAGE_TYPE.cancelAppointment, fromHomePage: false));
    }
    return result;
  }

  Future<ConfirmAppointmentResponse?> confirmAppointment() async {
    ConfirmAppointmentResponse? result =
        await confirmAppointmentApi(appointmentDetailsResponse?.data?.result?.uuid ?? "");
    if (result != null && result.data?.result != null) {
      locator<MyAppointmentsViewModel>().getMyAppointments();
      locator<MyAppointmentsViewModel>().getMyPreviousAppointments(pageIndex: 0);

      NavigationService.navigatorKey.currentState!.pushNamedAndRemoveUntil(
          RouteName.successRoute, ModalRoute.withName(RouteName.AppointmentsListScreen),
          arguments: SuccessScreenArgs(type: PAGE_TYPE.confirmAppointment, fromHomePage: false));
    }
    return result;
  }

  Future<CancelAppointmentResponse?> cancelAppointmentApi(
      int requestNumber, List<LookUpItem> cancelReasons, String? otherReason) async {
    showLoading();
    Tuple3<bool?, String?, CancelAppointmentResponse?> response =
        await _repository.cancelAppointment(requestNumber, cancelReasons, otherReason);
    hideLoading();
    if (response.item3 != null && response.item3?.data != null && response.item1 != null && response.item1!) {
      return response.item3;
    } else {
      showError(response.item2 ?? "");
    }
    return null;
  }

  Future<ConfirmAppointmentResponse?> confirmAppointmentApi(String requestNumber) async {
    showLoading();
    Tuple3<bool?, String?, ConfirmAppointmentResponse?> response = await _repository.confirmAppointment(requestNumber);
    hideLoading();
    if (response.item3 != null && response.item3?.data != null && response.item1 != null && response.item1!) {
      return response.item3;
    } else {
      showError(response.item2 ?? "");
    }
    return null;
  }

  Future<bool> getLookUpList() async {
    showLoading();
    Tuple3<bool?, String?, LookUpList?> response = await _repository.getLookupList("CANCEL_REASONS");
    hideLoading();
    if (response.item1 != null && response.item1! && response.item3?.data?.result != null) {
      setCancelReasons(response.item3);

      return true;
    } else {
      showError(response.item2 ?? "");
    }
    return false;
  }

  void setCancelReasons(LookUpList? data) {
    cancelReasonsList = data;
    cancelList = cancelReasonsList!.data!.result!
        .map<DropDownItem>((e) => DropDownItem(id: e.id.toString(), name: e.name ?? ""))
        .toList();
  }

  void reset() {
    appointmentDetailsResponse = null;
    selectedCancelReason = null;
    selectedCancelReasonItem = null;
    cancelReason = null;
  }
}
