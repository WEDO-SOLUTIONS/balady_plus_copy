import 'package:balady_plus/app/events_logs/controller/logs_controller.dart';
import 'package:balady_plus/app/events_logs/events_names.dart';
import 'package:balady_plus/app/events_logs/models/error_exception_model.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_it/get_it.dart';

import '../services/local/navigation_services.dart';

GetIt locator = GetIt.instance;

class BaseViewModel extends ChangeNotifier {
  bool isLoading = false;
  final navigation = NavigationService.navigatorKey;

  // final webService = locator<WebService>();
  // final apiServie = locator<APIService>();

  String? errorMessage;

  void showLoading() {
    EasyLoading.show();
    isLoading = true;
    notifyListeners();
  }

  void hideLoading() {
    EasyLoading.dismiss();
    isLoading = false;
    notifyListeners();
  }

  void showCenterLoading() {
    EasyLoading.show();
  }

  void hideCenterLoading() {
    EasyLoading.dismiss();
  }

  void showLoader() {
    isLoading = true;
    notifyListeners();
  }

  void hideLoader() {
    EasyLoading.dismiss();
    isLoading = false;
    notifyListeners();
  }

  void showError(String error) {
    if (error.isNotEmpty) {
      try {
        BotToast.showSimpleNotification(
          title: error,
          backgroundColor: const Color.fromARGB(255, 204, 51, 51),
          titleStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
            fontSize: 16.0,
          ),
          hideCloseButton: true,
          duration: const Duration(seconds: 3),
        );
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
  }

  void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
