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
Future<PoiReview?> poiMyReview(Ref ref, int objectId) =>
    ref.watch(poiReviewsRepositoryProvider).fetchMyReview(objectId);

/// keepAlive: the refresh after a save must not depend on the tab or the sheet still being mounted.
@Riverpod(keepAlive: true)
class PoiReviewsActions extends _$PoiReviewsActions {
  @override
  void build() {}

  /// Completes once the user's review and the summary are refetched, so the caller closes on fresh data.
  Future<void> saveMyReview(int objectId, MyReviewDraft draft) async {
    await ref.read(poiReviewsRepositoryProvider).saveMyReview(objectId, draft);
    ref
      ..invalidate(poiMyReviewProvider(objectId))
      ..invalidate(poiReviewsSummaryProvider(objectId));
    await Future.wait([
      _refetch(poiMyReviewProvider(objectId).future),
      _refetch(poiReviewsSummaryProvider(objectId).future),
    ]);
  }

  // Listening keeps an autoDispose provider alive until the fetch ends; its own errors are shown by the UI.
  Future<void> _refetch<T>(ProviderListenable<Future<T>> provider) async {
    final subscription = ref.listen(provider, (_, _) {});
    try {
      await subscription.read();
    } catch (_) {
    } finally {
      subscription.close();
    }
  }
}
