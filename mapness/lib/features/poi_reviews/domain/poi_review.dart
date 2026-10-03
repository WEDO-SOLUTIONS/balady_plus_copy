import 'package:freezed_annotation/freezed_annotation.dart';

part 'poi_review.freezed.dart';

@freezed
abstract class PoiReview with _$PoiReview {
  const factory PoiReview({
    required String id,
    required String authorName,
    required int authorReviewsCount,

    /// 1..5
    required int rating,
    required String text,
    required DateTime createdAt,
    @Default(<String>[]) List<String> photos,
  }) = _PoiReview;
}

@freezed
abstract class PoiReviewsSummary with _$PoiReviewsSummary {
  const factory PoiReviewsSummary({
    required int ratingsCount,
    required int reviewsCount,

    /// Number of ratings per star value, index 0 holds 1-star ratings.
    required List<int> histogram,
  }) = _PoiReviewsSummary;

  const PoiReviewsSummary._();

  double get average {
    if (ratingsCount == 0) {
      return 0;
    }
    var sum = 0;
    for (var i = 0; i < histogram.length; i++) {
      sum += (i + 1) * histogram[i];
    }
    return sum / ratingsCount;
  }

  int countFor(int stars) => histogram[stars - 1];
}

@freezed
abstract class PoiReviewsPage with _$PoiReviewsPage {
  const factory PoiReviewsPage({required List<PoiReview> items, required bool hasMore}) = _PoiReviewsPage;
}

@freezed
abstract class MyReviewDraft with _$MyReviewDraft {
  const factory MyReviewDraft({
    required int rating,
    @Default('') String text,
    @Default(<String>[]) List<String> imagePaths,
  }) = _MyReviewDraft;
}
