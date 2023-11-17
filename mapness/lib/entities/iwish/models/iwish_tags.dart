import 'package:mapness/entities/iwish/models/iwish_feedback_tag.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'iwish_tags.g.dart';

@riverpod
class _IwishTags extends _$IwishTags {
  @override
  List<IwishFeedbackTag> build() {
    return [
      "rest_area",
      "playground",
      "restroom",
      "spot_ground",
      "parking",
      "bicycle",
      "seating",
      "infant_room",
    ]
        .map(
          (e) => IwishFeedbackTag(
            id: e,
            displayName:
                e[0].toUpperCase() + e.substring(1).replaceAll('_', ' '),
            assetUrl: 'assets/icons/svg/ic_$e.svg',
          ),
        )
        .toList();
  }
}

final iwishTagsProvider = _iwishTagsProvider;
