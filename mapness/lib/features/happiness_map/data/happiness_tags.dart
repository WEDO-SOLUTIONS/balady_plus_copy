import 'package:mapness/features/happiness_map/domain/happiness_tag.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'happiness_tags.g.dart';

@riverpod
class HappinessTags extends _$HappinessTags {
  @override
  List<String> build() {
    return [
      "streets",
      "buildings",
      "parks",
      "visual_aesthetic",
      "cleanness",
      "lighting",
      "comfort",
    ];
  }
}

@riverpod
class HappinessTagsWithIcons extends _$HappinessTagsWithIcons {
  @override
  List<HappinessTag> build() {
    final tags = ref.watch(happinessTagsProvider);
    final data = [
      ("ic_building.svg", "Buildings"),
      ("ic_car_side.svg", "Streets"),
      ("ic_comment-heart.svg", "Comfort"),
      ("ic_eye.svg", "Visual aesthetic"),
      ("ic_lightbulb-alt.svg", "Lighting"),
      ("ic_trash-alt.svg", "Cleanness"),
      ("ic_trees.svg", "Parks"),
    ];
    // "ic_ellipsis.svg",
    return tags.indexed.map(
      (e) {
        final (path, title) = data[e.$1];
        return HappinessTag(
          code: e.$2,
          iconAsset: "assets/icons/svg/$path",
          title: title,
        );
      },
    ).toList();
  }
}
