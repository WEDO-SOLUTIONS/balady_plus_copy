import 'package:mapness/features/poi_reviews/data/mock_poi_reviews_repository.dart';
import 'package:mapness/features/poi_reviews/data/poi_reviews_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'poi_reviews_repository_provider.g.dart';

// keepAlive: the mock holds the user's reviews in memory for the whole session.
@Riverpod(keepAlive: true)
PoiReviewsRepository poiReviewsRepository(Ref ref) => MockPoiReviewsRepository();
