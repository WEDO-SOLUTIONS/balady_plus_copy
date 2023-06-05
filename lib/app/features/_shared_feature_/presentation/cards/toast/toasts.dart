import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart' show MessageType;
import '../../../shared_feature_exports.dart' show ToastNotificationCard;

abstract class _ToastNotification extends StatelessWidget {
  final Widget child;
  const _ToastNotification(this.child);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class ToastNotification extends _ToastNotification {
  ///
  ToastNotification.success(String msg)
      : super(ToastNotificationCard(
          msg: msg,
          msgType: MessageType.success,
        ));

  ///
  ToastNotification.error(String msg)
      : super(ToastNotificationCard(
          msg: msg,
          msgType: MessageType.error,
        ));

  ///
  ToastNotification.warning(String msg)
      : super(ToastNotificationCard(
          msg: msg,
          msgType: MessageType.warning,
        ));
}
