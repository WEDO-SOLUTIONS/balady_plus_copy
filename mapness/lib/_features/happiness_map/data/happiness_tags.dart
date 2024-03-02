import 'package:mapness/_features/happiness_map/domain/happiness_tag.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'happiness_tags.g.dart';

@riverpod
class HappinessTags extends _$HappinessTags {
  @override
  List<String> build() {
    final tags = ref.watch(happinessTagsWithIconsProvider);
    return tags.map((e) => e.code).toList();
  }
}

@riverpod
class HappinessTagsWithIcons extends _$HappinessTagsWithIcons {
  @override
  List<HappinessTag> build() {
    final tags = [
      ('visual_aesthetic', 'ic_eye.svg', 'Visual\naesthetic'),
      ('parks', 'ic_trees.svg', 'Parks'),
      ('buildings', 'ic_building.svg', 'Buildings'),
      ('streets', 'ic_car_side.svg', 'Streets'),
      ('comfort', 'ic_comment-heart.svg', 'Comfort'),
      ('lighting', 'ic_lightbulb-alt.svg', 'Lighting'),
      ('cleanness', 'ic_trash-alt.svg', 'Clean'),
    ];

    return tags.map(
      (tag) {
        final (code, path, title) = tag;
        return HappinessTag(
          code: code,
          iconAsset: 'assets/icons/svg/$path',
          title: title,
        );
      },
    ).toList();
  }
}
