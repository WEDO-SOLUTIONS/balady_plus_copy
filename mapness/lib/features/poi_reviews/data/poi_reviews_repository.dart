import 'package:mapness/features/poi_reviews/domain/poi_review.dart';

/// Data source of POI reviews. Only [MockPoiReviewsRepository] exists until the backend contract is agreed.
abstract class PoiReviewsRepository {
  Future<PoiReviewsSummary> fetchSummary(int objectId);

  /// [page] is zero-based.
  Future<PoiReviewsPage> fetchReviews(int objectId, {required int page, int pageSize = 10});

  /// `null` when the current user has not reviewed the place yet.
  Future<PoiReview?> fetchMyReview(int objectId);

  Future<PoiReview> saveMyReview(int objectId, MyReviewDraft draft);
}
