import 'package:freezed_annotation/freezed_annotation.dart';

part 'feedback_source.freezed.dart';

@freezed
sealed class FeedbackSource with _$FeedbackSource {
  const FeedbackSource._();

  const factory FeedbackSource.main() = FeedbackSourceMain;

  const factory FeedbackSource.navi() = FeedbackSourceNavi;

  const factory FeedbackSource.offer(String id) = FeedbackSourceOffer;
}
