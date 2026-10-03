import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reviews_feature_flag.g.dart';

/// Gates the mocked Reviews tab of the POI card until the reviews backend exists.
@Riverpod(keepAlive: true)
class ReviewsFeatureFlag extends _$ReviewsFeatureFlag {
  @override
  bool build() => kDebugMode;

  // ignore: avoid_setters_without_getters
  set enabled(bool value) => state = value;
}
