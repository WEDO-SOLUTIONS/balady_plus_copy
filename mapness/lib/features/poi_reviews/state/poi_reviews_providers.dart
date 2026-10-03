import 'package:mapness/features/poi_reviews/data/poi_reviews_repository_provider.dart';
import 'package:mapness/features/poi_reviews/domain/poi_review.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'poi_reviews_providers.g.dart';

@riverpod
Future<PoiReviewsSummary> poiReviewsSummary(Ref ref, int objectId) =>
    ref.watch(poiReviewsRepositoryProvider).fetchSummary(objectId);

/// Reviews of other users, accumulated page by page.
@riverpod
class PoiReviewsFeed extends _$PoiReviewsFeed {
  int _nextPage = 1;

  @override
  Future<PoiReviewsPage> build(int objectId) {
    _nextPage = 1;
    return ref.watch(poiReviewsRepositoryProvider).fetchReviews(objectId, page: 0);
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore) {
      return;
    }
    final next = await ref.read(poiReviewsRepositoryProvider).fetchReviews(objectId, page: _nextPage);
    if (!ref.mounted) {
      return;
    }
    _nextPage++;
    state = AsyncData(PoiReviewsPage(items: [...current.items, ...next.items], hasMore: next.hasMore));
  }
}

@riverpod
class PoiMyReview extends _$PoiMyReview {
  @override
  Future<PoiReview?> build(int objectId) => ref.watch(poiReviewsRepositoryProvider).fetchMyReview(objectId);

  Future<void> save(MyReviewDraft draft) async {
    final saved = await ref.read(poiReviewsRepositoryProvider).saveMyReview(objectId, draft);
    if (!ref.mounted) {
      return;
    }
    state = AsyncData(saved);
    ref.invalidate(poiReviewsSummaryProvider(objectId));
  }
}
