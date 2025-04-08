import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mapness/entities/app_feedback/feedback_source.dart';

// ignore_for_file: invalid_annotation_target

part 'app_feedback_payload.freezed.dart';

part 'app_feedback_payload.g.dart';

enum AppFeedbackLocale { en, ar }

enum AppFeedbackMobileOs { android, ios }

@freezed
class AppFeedbackPayload with _$AppFeedbackPayload {
  @JsonSerializable(explicitToJson: true)
  factory AppFeedbackPayload({
    required final AppFeedbackReview review,
    final AppFeedbackContext? context,
  }) = _AppFeedbackPayload;

  factory AppFeedbackPayload.fromJson(Map<String, dynamic> json) => _$AppFeedbackPayloadFromJson(json);
}

@freezed
class AppFeedbackReview with _$AppFeedbackReview {
  @JsonSerializable(explicitToJson: true)
  factory AppFeedbackReview({
    required final int stars,
    final String? text,
    final List<String>? tags,
  }) = _AppFeedbackReview;

  factory AppFeedbackReview.fromJson(Map<String, dynamic> json) => _$AppFeedbackReviewFromJson(json);
}

@freezed
class AppFeedbackContext with _$AppFeedbackContext {
  factory AppFeedbackContext({
    final String? appVersion,
    final AppFeedbackMobileOs? mobileOS,
    final AppFeedbackLocale? locale,
    final String? authId,
    @JsonKey(toJson: _sourceToJson, fromJson: _sourceFromJson) final FeedbackSource? feedbackSource,
    final String? deviceId,
  }) = _AppFeedbackContext;

  factory AppFeedbackContext.fromJson(Map<String, dynamic> json) => _$AppFeedbackContextFromJson(json);
}

FeedbackSource? _sourceFromJson(String? value) => switch (value) {
      'main' => const FeedbackSource.main(),
      'navi' => const FeedbackSource.navi(),
      _ => null,
    };

String? _sourceToJson(FeedbackSource? source) => switch (source) {
      FeedbackSourceMain() => 'main',
      FeedbackSourceNavi() => 'navi',
      _ => null,
    };
