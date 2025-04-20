import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tuple/tuple.dart';

import '../../../../../../core/base/base_view_model.dart';
import '../../../../../../core/utils/common_functions.dart';
import '../../../../../new_appointment/presentation/core/models/my_appointments_response.dart';
import '../../../../../new_appointment/presentation/core/services/repository/appointment_repository.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class MyAppointmentsViewModel extends BaseViewModel {
  final _repository = locator<AppointmentRepository>();
  MyAppointmentsResponse? myUpcomingAppointmentsResponse;
  MyAppointmentsResponse? myPreviousAppointmentsResponse;
  bool prevoiusNoResults = false;
  int prevoiusPageIndex = 0;

  Future<bool> getMyAppointmentsResponse(
      {bool showLoad = true,
      bool loadMore = false,
      bool showCircularLoader = false,
      int? pageSize,
      int? pageIndex,
      bool upcomingAppointments = true,
      bool showErrorMsg = false,
      bool autoLogout = true}) async {
    showCircularLoader ? showLoading() : {if (showLoad) showLoader()};
    Tuple3<bool?, String?, MyAppointmentsResponse?> response =
        await _repository.getMyAppointments(
            pageIndex: pageIndex ?? 0,
            pageSize: pageSize ?? 20,
            // upcomingAppointments: upcomingAppointments,
            // autoLogout: autoLogout
            );
    showLoad ? hideLoader() : null;
    if (response.item1 != null && response.item1!) {
      if (upcomingAppointments) {
        myUpcomingAppointmentsResponse = response.item3;
      } else {
        if (pageIndex == 0) {
          myPreviousAppointmentsResponse = response.item3;
          prevoiusPageIndex = 1;
          prevoiusNoResults = false;
          if ((myPreviousAppointmentsResponse?.data?.result?.length ?? 0) <
              20) {
            prevoiusNoResults = true;
          }
        } else {
          if (response.item3?.data?.result != null) {
            if (response.item3!.data!.result!.isEmpty) {
              prevoiusNoResults = true;
            } else {
              prevoiusPageIndex += 1;
              myPreviousAppointmentsResponse?.data?.result
                  ?.addAll(response.item3!.data!.result!);
            }
          }
        }
      }
      return true;
    } else {
      if (showErrorMsg) {
        if (response.item2 != null) showError(response.item2!);
      }
      return false;
    }
  }

  Future<bool> getMyAppointments(
      {bool showLoad = true,
      bool showErrorMsg = false,
      bool autoLogout = true}) async {
    if (!CommonProperties.isLoggedInMunicipality) {
      return false;
    } else {
      if (showLoad) showLoader();
      bool isSuccess = false;
      isSuccess = await getMyAppointmentsResponse(
          showLoad: showLoad,
          pageIndex: 0,
          upcomingAppointments: true,
          showErrorMsg: showErrorMsg,
          pageSize: 100,
          autoLogout: autoLogout);
      if (showLoad) hideLoader();
      return isSuccess;
    }
  }

  Future<bool> getMyPreviousAppointments(
      {int? pageSize,
      int? pageIndex,
      bool showLoad = true,
      bool showErrorMsg = false}) async {
    showLoader();
    bool isSuccess = false;
    isSuccess = await getMyAppointmentsResponse(
        showLoad: showLoad,
        pageIndex: pageIndex ?? prevoiusPageIndex,
        pageSize: pageSize,
        showErrorMsg: showErrorMsg,
        upcomingAppointments: false);
    hideLoader();
    return isSuccess;
  }

  List<AppointmentItem>? getMyHomeAppointmentsList() {
    try {
      return myUpcomingAppointmentsResponse?.data != null
          ? myUpcomingAppointmentsResponse?.data?.result
                  ?.where((element) =>
                      CommonFunctions.getDifferenceBetweenDays(
                          element.visitDate) >=
                      0)
                  .toList() ??
              []
          : null;
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      try {
        //MM  Helpers.sendLog(url: "getMyAppointmentsList", errorMsg: e.toString());
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
      return null;
    }
  }

  List<AppointmentItem> getMyAppointmentsList() {
    try {
      // return myUpcomingAppointmentsResponse?.data?.result!
      //         .where((element) => (element.statusId == 1 ||
      //             element.statusId == 2 ||
      //             element.statusId == 5))
      //         .toList() ??
      //     [];
      return myUpcomingAppointmentsResponse?.data?.result
              ?.where((element) =>
                  CommonFunctions.getDifferenceBetweenDays(element.visitDate) >=
                  0)
              .toList() ??
          [];
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      try {
        //MM  Helpers.sendLog(url: "getMyAppointmentsList", errorMsg: e.toString());
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
      return [];
    }
  }

  List<AppointmentItem> getMyPreviousAppointmentsList() {
    try {
      // return myUpcomingAppointmentsResponse?.data?.result!
      //         .where(
      //             (element) => (element.statusId == 3 || element.statusId == 6))
      //         .toList() ??
      //     [];
      //  return myPreviousAppointmentsResponse?.data?.result ?? [];
      return myPreviousAppointmentsResponse?.data?.result
              ?.where((element) =>
                  CommonFunctions.getDifferenceBetweenDays(element.visitDate) <
                      0 ||
                  element.statusId == 3 ||
                  element.statusId == 6)
              .toList() ??
          [];
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return [];
    }
  }

  Future getAppointmentsAfterLogin() async {
    showLoading();
    await Future.wait([
      getMyAppointments(showLoad: false),
      getMyPreviousAppointments(pageIndex: 0, showLoad: false)
    ]);

    hideLoading();
    return true;
  }

  @override
  showLoading() {
    EasyLoading.show();
  }

  @override
  hideLoading() {
    EasyLoading.dismiss();
  }

  void reset() {
    myUpcomingAppointmentsResponse = null;
    myPreviousAppointmentsResponse = null;
  }
}
