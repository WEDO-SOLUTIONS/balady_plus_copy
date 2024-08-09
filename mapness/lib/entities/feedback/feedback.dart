import 'package:mapness/entities/feedback/feedback_type.dart';

sealed class FeedbackData {
  final FeedbackType type;
  const FeedbackData({required this.type});
}

final class FeedbackCompanyName extends FeedbackData {
  final String companyName;

  const FeedbackCompanyName(this.companyName) : super(type: FeedbackType.companyName);
}

final class FeedbackAreaOfActivity extends FeedbackData {
  final String areaOfActivity;

  const FeedbackAreaOfActivity(this.areaOfActivity) : super(type: FeedbackType.areaOfActivity);
}

final class FeedbackAddress extends FeedbackData {
  final String address;

  const FeedbackAddress(this.address) : super(type: FeedbackType.address);
}

final class FeedbackWorkingHours extends FeedbackData {
  final String workingHours;

  const FeedbackWorkingHours(this.workingHours) : super(type: FeedbackType.workingHours);
}

final class FeedbackPhoneNumber extends FeedbackData {
  final String phoneNumber;

  const FeedbackPhoneNumber(this.phoneNumber) : super(type: FeedbackType.phoneNumber);
}

final class FeedbackWebsiteOrSocialMedia extends FeedbackData {
  final String websiteOrSocialMedia;

  const FeedbackWebsiteOrSocialMedia(this.websiteOrSocialMedia) : super(type: FeedbackType.websiteOrSocialMedia);
}

final class FeedbackCompanyHasBeenClosed extends FeedbackData {
  const FeedbackCompanyHasBeenClosed() : super(type: FeedbackType.companyHasBeenClosed);
}

final class FeedbackOther extends FeedbackData {
  final String other;

  const FeedbackOther(this.other) : super(type: FeedbackType.other);
}
