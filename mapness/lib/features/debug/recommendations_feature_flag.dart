import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recommendations_feature_flag.g.dart';

@Riverpod(keepAlive: true)
class RecommendationsFeatureFlag extends _$RecommendationsFeatureFlag {
  @override
  bool build() => false;

  bool get enabled => state;

  set enabled(bool value) => state = value;
}
