import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

/// Types of the feedback that the user can provide.
enum FeedbackType {
  companyName,
  areaOfActivity,
  address,
  workingHours,
  phoneNumber,
  websiteOrSocialMedia,
  companyHasBeenClosed,
  other,
}

extension FeedbackTypeExt on FeedbackType {
  String title(AppLocalizations l10n) {
    switch (this) {
      case FeedbackType.companyName:
        return l10n.feedbackCompanyName;
      case FeedbackType.areaOfActivity:
        return l10n.feedbackAreaOfActivity;
      case FeedbackType.address:
        return l10n.feedbackAddress;
      case FeedbackType.workingHours:
        return l10n.feedbackWorkingHours;
      case FeedbackType.phoneNumber:
        return l10n.feedbackPhoneNumber;
      case FeedbackType.websiteOrSocialMedia:
        return l10n.feedbackWebsiteOrSocialMedia;
      case FeedbackType.companyHasBeenClosed:
        return l10n.feedbackCompanyHasBeenClosed;
      case FeedbackType.other:
        return l10n.feedbackOther;
    }
  }

  IconData icon({required bool isLTR}) {
    switch (this) {
      case FeedbackType.companyName:
        // TODO: Add new icon in UIKit
        return GeneralIcons.circleNull;
      case FeedbackType.areaOfActivity:
        return isLTR ? GeneralIcons.messageTextLTR : GeneralIcons.messageTextRTL;
      case FeedbackType.address:
        return GeneralIcons.pin;
      case FeedbackType.workingHours:
        return GeneralIcons.timeQuarter;
      case FeedbackType.phoneNumber:
        return isLTR ? GeneralIcons.phoneLTR : GeneralIcons.phoneRTL;
      case FeedbackType.websiteOrSocialMedia:
        return GeneralIcons.web;
      case FeedbackType.companyHasBeenClosed:
        return GeneralIcons.clearCircle;
      case FeedbackType.other:
        return GeneralIcons.questionCircle;
    }
  }
}
