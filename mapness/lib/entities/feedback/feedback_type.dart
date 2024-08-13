import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';

extension FeedbackTypeExt on String {
  IconData? feedbackIcon({required bool isLTR}) {
    switch (this) {
      case 'nameChange':
        // TODO: Add new icon in UIKit
        return GeneralIcons.circleNull;
      case 'messageText':
        return isLTR ? GeneralIcons.messageTextLTR : GeneralIcons.messageTextRTL;
      case 'pin':
        return GeneralIcons.pin;
      case 'timeQuarter':
        return GeneralIcons.timeQuarter;
      case 'phone':
        return isLTR ? GeneralIcons.phoneLTR : GeneralIcons.phoneRTL;
      case 'web':
        return GeneralIcons.web;
      case 'clearCircle':
        return GeneralIcons.clearCircle;
      case 'questionCircle':
        return GeneralIcons.questionCircle;
      default:
        return null;
    }
  }
}
