import 'package:balady_plus/etmam_app/core/utils/constants/app_color.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/constans.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/icon_path.dart';
import 'package:flutter/material.dart';

enum OrderAction {
  update(action: Constants.changeProvider, icon: IconPath.changeProvider),
  rate(action: Constants.rate, icon: IconPath.evaluateOrder),
  cancel(
      action: Constants.cancel,
      icon: IconPath.cancelOrder,
      color: AppColor.redForCancel),
  none(action: "", icon: IconPath.changeProvider);

  const OrderAction({required this.action, required this.icon, this.color});

  final String action;
  final String icon;
  final Color? color;

  factory OrderAction.getAction(String action) {
    switch (action) {
      case Constants.changeProvider:
        return OrderAction.update;
      case Constants.rate:
        return OrderAction.rate;
      case Constants.cancel:
        return OrderAction.cancel;
    }
    return OrderAction.none;
  }
}
