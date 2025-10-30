import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

abstract class BasePresenter<V extends BaseView> {
  V? view;

  void attachView(BaseView? view) {
    this.view = view as V?;
  }

  void detachView() {
    this.view = null;
  }

  bool get isViewAttached {
    return view != null;
  }

  void checkViewAttached() {
    if (view == null) {
      throw new Exception("attached view is null!");
    }
  }

  V? getView() {
    return view;
  }
}

abstract class BaseState<T extends StatefulWidget, P extends BasePresenter<V>,
    V extends BaseView> extends State<T> implements BaseView {
  P? presenter;

  bool isLoading = false;

  P initPresenter();

  Widget buildScreen(BuildContext context);

  void initData() {}

  @override
  void initState() {
    super.initState();
    presenter = initPresenter();
    if (presenter != null) {
      presenter?.attachView(this);
    }
    initData();
  }

  @override
  void dispose() {
    super.dispose();
    if (presenter != null) {
      presenter?.detachView();
      presenter = null;
    }
  }

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    return buildScreen(context);
  }

  @override
  void showLoading() {
    //setState(() {
    isLoading = true;
    //});
    EasyLoading.show();
  }

  @override
  void hideLoading() {
    // setState(() {
    isLoading = false;
    // });
    EasyLoading.dismiss();
  }

  @override
  void showError(String error) {
    //if (error != null && error.isNotEmpty)
    // Utility.showTopSnackBar(error, context);

    try {
      BotToast.showSimpleNotification(
          title: error,
          backgroundColor: const Color.fromARGB(255, 204, 51, 51),
          titleStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
              fontSize: 16.0),
          hideCloseButton: true,
          duration: const Duration(seconds: 3));
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

  @override
  void hideKeyboard() {
    FocusScope.of(context).unfocus();
  }
}

abstract class BaseView {
  void showLoading();
  void hideLoading();
  void showError(String error);
  void hideKeyboard();
  void sessionEnded();
}
