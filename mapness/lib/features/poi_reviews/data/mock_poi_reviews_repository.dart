import 'dart:math';

import 'package:mapness/features/poi_reviews/data/poi_reviews_repository.dart';
import 'package:mapness/features/poi_reviews/domain/poi_review.dart';

/// Deterministic per-POI fixtures with a simulated network delay; the user's own reviews live in memory
/// for the app session only.
class MockPoiReviewsRepository implements PoiReviewsRepository {
  final Duration latency;
  final DateTime Function() _now;
  final Map<int, PoiReview> _myReviews = {};

  MockPoiReviewsRepository({this.latency = const Duration(milliseconds: 400), DateTime Function()? now})
    : _now = now ?? DateTime.now;

  @override
  Future<PoiReviewsSummary> fetchSummary(int objectId) async {
    await Future<void>.delayed(latency);
    final base = _baseSummary(objectId);
    final mine = _myReviews[objectId];
    if (mine == null) {
      return base;
    }
    final histogram = [...base.histogram];
    histogram[mine.rating - 1]++;
    return base.copyWith(ratingsCount: base.ratingsCount + 1, histogram: histogram);
  }

  @override
  Future<PoiReviewsPage> fetchReviews(int objectId, {required int page, int pageSize = 10}) async {
    await Future<void>.delayed(latency);
    final summary = _baseSummary(objectId);
    final start = page * pageSize;
    final end = min(start + pageSize, summary.reviewsCount);
    final items = [for (var i = start; i < end; i++) _review(objectId, i, summary)];
    return PoiReviewsPage(items: items, hasMore: end < summary.reviewsCount);
  }

  @override
  Future<PoiReview?> fetchMyReview(int objectId) async {
    await Future<void>.delayed(latency);
    return _myReviews[objectId];
  }

  @override
  Future<PoiReview> saveMyReview(int objectId, MyReviewDraft draft) async {
    await Future<void>.delayed(latency);
    final isNew = !_myReviews.containsKey(objectId);
    final review = PoiReview(
      id: 'my-$objectId',
      authorName: '',
      authorReviewsCount: _myReviews.length + (isNew ? 1 : 0),
      rating: draft.rating,
      text: draft.text.trim(),
      createdAt: _now(),
      photos: draft.imagePaths,
    );
    _myReviews[objectId] = review;
    return review;
  }

  PoiReviewsSummary _baseSummary(int objectId) {
    // Every 8th place has no ratings at all, to keep the empty state reachable.
    if (objectId % 8 == 0) {
      return const PoiReviewsSummary(ratingsCount: 0, reviewsCount: 0, histogram: [0, 0, 0, 0, 0]);
    }
    final random = Random(objectId);
    final ratingsCount = 5 + random.nextInt(2500);
    final weights = [
      1 + random.nextDouble() * 3,
      1 + random.nextDouble() * 3,
      3 + random.nextDouble() * 6,
      8 + random.nextDouble() * 16,
      20 + random.nextDouble() * 40,
    ];
    final weightsSum = weights.reduce((a, b) => a + b);
    final histogram = [for (final w in weights) (ratingsCount * w / weightsSum).floor()];
    histogram[4] += ratingsCount - histogram.reduce((a, b) => a + b);
    final reviewsCount = max(1, (ratingsCount * (0.3 + random.nextDouble() * 0.5)).round());
    return PoiReviewsSummary(ratingsCount: ratingsCount, reviewsCount: reviewsCount, histogram: histogram);
  }

  PoiReview _review(int objectId, int index, PoiReviewsSummary summary) {
    final random = Random(objectId * 31 + index);
    final rating = _pickRating(random, summary.histogram, summary.ratingsCount);
    final texts = _texts[rating]!;
    final daysAgo = index == 0 ? 1 : index * 4 + random.nextInt(4);
    return PoiReview(
      id: '$objectId-$index',
      authorName: _authors[random.nextInt(_authors.length)],
      authorReviewsCount: 1 + random.nextInt(60),
      rating: rating,
      text: texts[random.nextInt(texts.length)],
      createdAt: _now().subtract(Duration(days: daysAgo, hours: random.nextInt(12))),
    );
  }

  int _pickRating(Random random, List<int> histogram, int total) {
    var roll = random.nextInt(total);
    for (var i = histogram.length - 1; i >= 0; i--) {
      roll -= histogram[i];
      if (roll < 0) {
        return i + 1;
      }
    }
    return 5;
  }

  static const _authors = [
    'Tariq Al Saleh',
    'Noura Al Fahad',
    'Abdullah Al Qahtani',
    'Sara Al Harbi',
    'Faisal Al Otaibi',
    'Reem Al Dossary',
    'Khalid Al Zahrani',
    'Lama Al Shehri',
    'محمد العتيبي',
    'نورة القحطاني',
    'فهد الدوسري',
    'ريم الشمري',
  ];

  static const _texts = {
    5: [
      'Great! Loved it',
      'Clean, spacious and the staff were very helpful.',
      'Easy parking and quick service. Will come back.',
      'مكان رائع وخدمة ممتازة',
      'من أفضل الأماكن في المدينة، أنصح بزيارته',
    ],
    4: [
      'Good place, a bit crowded in the evening.',
      'Nice atmosphere, prices are fair.',
      'جيد جدًا لكن الانتظار كان طويلًا قليلًا',
    ],
    3: [
      'Okay overall, nothing special.',
      'مقبول، يحتاج إلى تحسين النظافة',
    ],
    2: [
      'Hard to find the entrance, signs are missing.',
      'الخدمة بطيئة والمكان مزدحم',
    ],
    1: [
      'Closed although the opening hours said open.',
      'تجربة سيئة للأسف',
    ],
  };
}
