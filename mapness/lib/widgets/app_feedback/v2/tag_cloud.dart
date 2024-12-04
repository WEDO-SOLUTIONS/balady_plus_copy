import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mapness/entities/app_feedback/app_feedback_tag_mapper.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class TagCloud extends HookWidget {
  final ValueChanged<Set<String>>? onTagsChanged;
  final int rating;

  const TagCloud({required this.rating, this.onTagsChanged, super.key});

  @override
  Widget build(BuildContext context) {
    final tagKey = 'tag_cloud_$rating';

    final selectedTags = useState<Set<String>>({});
    final useTags = useMemoized(() => AppFeedbackTagMapper().getTags(rating), [tagKey]);

    return Padding(
      key: ValueKey(tagKey),
      padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
      child: ValueListenableBuilder(
        valueListenable: selectedTags,
        builder: (context, selectedTagsValue, _) => Wrap(
          alignment: WrapAlignment.center,
          spacing: 8.0,
          children: useTags.map((tag) {
            final isSelected = selectedTagsValue.contains(tag);
            return GestureDetector(
              onTap: () {
                final newSelectedTags = Set<String>.from(selectedTags.value);
                if (newSelectedTags.contains(tag)) {
                  newSelectedTags.remove(tag);
                } else {
                  newSelectedTags.add(tag);
                }
                selectedTags.value = newSelectedTags;
                onTagsChanged?.call(newSelectedTags);
              },
              child: Chip(
                backgroundColor: isSelected ? context.colorsV2.accentDefault : context.colorsV2.backgroundSurface4,
                label: Text(AppFeedbackTagMapper.getLocalizedText(context.l10n, tag),
                    style: context.textStyleV3.bodySmallRegular.copyWith(
                      color: isSelected ? context.colorsV3.onAccent : context.colorsV2.foregroundDefault,
                    )),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
