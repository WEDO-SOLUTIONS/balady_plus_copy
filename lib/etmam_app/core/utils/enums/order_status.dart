import 'package:balady_plus/etmam_app/core/utils/constants/app_color.dart';
import 'package:flutter/material.dart';

enum OrderStatus {
  waitingForApproval(
      backGroundcolor: AppColor.waitingForApproveOrderBackgroundColor,
      textcolor: AppColor.waitingForApproveOrderTextColor),
  canceled(
      backGroundcolor: AppColor.canceledOrderBackgroundColor,
      textcolor: AppColor.canceledOrderTextColor),
  rejected(
      backGroundcolor: AppColor.canceledOrderBackgroundColor,
      textcolor: AppColor.canceledOrderTextColor),
  approved(
      backGroundcolor: AppColor.approvedOrderBackgroundColor,
      textcolor: AppColor.approvedOrderTextColor),
  inProgress(
      backGroundcolor: AppColor.waitingForApproveOrderBackgroundColor,
      textcolor: AppColor.waitingForApproveOrderTextColor),
  startFailed(
      backGroundcolor: AppColor.canceledOrderBackgroundColor,
      textcolor: AppColor.canceledOrderTextColor),
  completed(
      backGroundcolor: AppColor.approvedOrderBackgroundColor,
      textcolor: AppColor.approvedOrderTextColor),
  failed(
      backGroundcolor: AppColor.canceledOrderBackgroundColor,
      textcolor: AppColor.canceledOrderTextColor);

  const OrderStatus({required this.backGroundcolor, required this.textcolor});

  final Color? backGroundcolor;
  final Color? textcolor;
}
