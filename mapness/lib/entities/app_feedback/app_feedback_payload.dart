import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_feedback_payload.freezed.dart';
part 'app_feedback_payload.g.dart';

enum AppFeedbackLocale { en, ar }

enum AppFeedbackMobileOs { android, ios }

@freezed
class AppFeedbackPayload with _$AppFeedbackPayload {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  factory AppFeedbackPayload({
    required final String reviewText,
    required final AppFeedbackContext context,
  }) = _AppFeedbackPayload;

  factory AppFeedbackPayload.fromJson(Map<String, dynamic> json) => _$AppFeedbackPayloadFromJson(json);
}

@freezed
class AppFeedbackContext with _$AppFeedbackContext {
  factory AppFeedbackContext({
    final String? appVersion,
    final AppFeedbackMobileOs? mobileOS,
    final AppFeedbackLocale? locale,
    final String? authId,
  }) = _AppFeedbackContext;

  factory AppFeedbackContext.fromJson(Map<String, dynamic> json) => _$AppFeedbackContextFromJson(json);
}
