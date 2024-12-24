import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/entities/app_feedback/app_feedback_tag_mapper.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class TagCloud extends HookWidget {
  final ValueChanged<Set<Tag>>? onTagsChanged;
  final int rating;

  const TagCloud({
    required this.rating,
    this.onTagsChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final tagKey = 'tag_cloud_$rating';

    final selectedTags = useState<Set<Tag>>({});
    final useTags = useMemoized(() => AppFeedbackTagMapper().getTags(rating), [tagKey]);

    return Padding(
      key: ValueKey(tagKey),
      padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
      child: ValueListenableBuilder(
        valueListenable: selectedTags,
        builder: (context, selectedTagsValue, _) => Wrap(
          alignment: WrapAlignment.center,
          spacing: 8.0,
          runSpacing: 10.0,
          children: useTags.map((tag) {
            final isSelected = selectedTagsValue.contains(tag);
            return GestureDetector(
              onTap: () {
                final newSelectedTags = Set<Tag>.from(selectedTags.value);
                if (newSelectedTags.contains(tag)) {
                  newSelectedTags.remove(tag);
                } else {
                  newSelectedTags.add(tag);
                }
                selectedTags.value = newSelectedTags;
                onTagsChanged?.call(newSelectedTags);
              },
              child: Chip(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: EdgeInsets.zero,
                labelPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                backgroundColor: isSelected ? context.colorsV2.accentDefault : context.colorsV2.backgroundSurface4,
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppFeedbackTagMapper.getLocalizedText(context.l10n, tag),
                      style: context.textStyleV3.bodySmallRegular.copyWith(
                        color: isSelected ? context.colorsV3.onAccent : context.colorsV2.foregroundDefault,
                      ),
                    ),
                    const SizedBox(width: 4),
                    SvgPicture.asset(
                      AppFeedbackTagMapper.getIconByTag(tag),
                      colorFilter: isSelected ? ColorFilter.mode(context.colorsV3.onAccent, BlendMode.srcIn) : null,
                      width: 16,
                      height: 16,
                      package: PackageConfig.packageName,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
