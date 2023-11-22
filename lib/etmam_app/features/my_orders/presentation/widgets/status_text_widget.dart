import 'package:balady_plus/etmam_app/core/utils/enums/order_status.dart';
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, trans;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show CustomHorizontalSpace, CustomTextWidget;
import 'package:flutter/material.dart';

class StatusTextWidget extends StatelessWidget {
  final OrderStatus orderStatus;
  final String text;
  final int maxLines;
  final double? textSize;

  const StatusTextWidget(
      {Key? key,
      required this.orderStatus,
      required this.text,
      this.maxLines = 1,
      this.textSize = 13})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: textSize == 13 ? 12 : 8, vertical: 4),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          color: orderStatus.backGroundcolor),
      child: CustomTextWidget(
        text,
        fontSize: textSize,
        fontWeight: AppFontWeight.regular,
        fontColor: orderStatus.textcolor,
        maxLines: maxLines,
        textOverflow: TextOverflow.ellipsis,
        textAlign: TextAlign.start,
      ),
    );
  }
}

class StatusWidget extends StatelessWidget {
  final OrderStatus orderStatus;
  final String text;
  final int maxLines;
  final double? statusTextSize;

  const StatusWidget(
      {Key? key,
      required this.orderStatus,
      required this.text,
      this.maxLines = 1,
      this.statusTextSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomTextWidget(
          trans('etmam_order_status'),
          fontSize: 14.0,
          fontWeight: AppFontWeight.regular,
          fontColor: AppColor.bottomNavigationShadow,
          maxLines: 1,
          textOverflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
        ),
        const CustomHorizontalSpace(width: 9),
        StatusTextWidget(
          orderStatus: orderStatus,
          text: text,
          maxLines: maxLines,
          textSize: statusTextSize,
        )
      ],
    );
  }
}
