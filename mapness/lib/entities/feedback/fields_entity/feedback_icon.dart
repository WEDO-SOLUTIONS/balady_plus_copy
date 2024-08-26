import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';

enum FeedbackIcon {
  nameChange,
  messageText,
  pin,
  timeQuarter,
  phone,
  web,
  clearCircle,
  questionCircle,
  unknown,
}

typedef _FI = FeedbackIcon;

extension FeedbackTypeExt on FeedbackIcon {
  IconData iconData({required bool isLTR}) => switch (this) {
        _FI.nameChange => GeneralIcons.nameChange,
        _FI.messageText when !isLTR => GeneralIcons.messageTextRTL,
        _FI.messageText => GeneralIcons.messageTextLTR,
        _FI.pin => GeneralIcons.pin,
        _FI.timeQuarter => GeneralIcons.timeQuarter,
        _FI.phone when !isLTR => GeneralIcons.phoneRTL,
        _FI.phone => GeneralIcons.phoneLTR,
        _FI.web => GeneralIcons.web,
        _FI.clearCircle => GeneralIcons.clearCircle,
        _FI.questionCircle => GeneralIcons.questionCircle,
        _FI.unknown => GeneralIcons.questionCircle,
      };
}
