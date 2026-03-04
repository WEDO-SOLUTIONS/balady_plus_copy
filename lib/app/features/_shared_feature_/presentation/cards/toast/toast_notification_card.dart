import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart' show AppColor, AppStyle, MessageType, UIHelper, WidgetConversion;
import '../../../shared_feature_exports.dart' show CustomAutoSizeTextWidget, DrawIconBasedTypeWidget;

class ToastNotificationCard extends StatelessWidget {
  final MessageType msgType;
  final String msg;
  const ToastNotificationCard({
    super.key,
    required this.msgType,
    required this.msg,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      color: msgType.color ?? Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: Padding(
        padding: const EdgeInsets.all(UIHelper.smallPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Check Icon
            DrawIconBasedTypeWidget(
              icon: msgType.icon ?? '',
              iconSize: 20.0,
              iconColor: AppColor.white,
            ),
            // Label
            Expanded(
              child: CustomAutoSizeTextWidget(
                msg,
                maxLines: 3,
                textOverflow: TextOverflow.ellipsis,
                textStyle: msgStyle,
              ),
            ),
          ].addPadding(end: 12.0),
        ),
      ),
    );
  }

  EdgeInsetsGeometry get margin => const EdgeInsets.symmetric(horizontal: UIHelper.middlePadding - 2.0);
  BorderRadiusGeometry get borderRadius => const BorderRadius.all(Radius.circular(8.0));

  TextStyle get msgStyle => AppStyle.mainTextSecondaryStyle.copyWith(color: AppColor.white, height: 1.3);
}
