import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/entities/app_feedback/app_feedback_tag_mapper.dart';
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
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final selectedTags = useState<Set<Tag>>({});
    final useTags = useMemoized(() => AppFeedbackTagMapper().getTags(rating, isRtl: isRtl), [tagKey]);

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
            final textColor = isSelected ? context.colors.accentOnAccent : context.colors.foregroundDefault;
            final iconColor = isSelected ? context.colors.accentOnAccent : context.colors.accentDefault;
            final backgroundColor = isSelected ? context.colors.accentDefault : context.colors.backgroundSurface1;

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
                  // Maximuem border value for the chip
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: EdgeInsets.zero,
                labelPadding: const EdgeInsets.symmetric(
                  horizontal: Spacing.$2x,
                  vertical: Spacing.$1x,
                ),
                backgroundColor: backgroundColor,
                label: Padding(
                  padding: const EdgeInsets.all(Spacing.$0_5x),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppFeedbackTagMapper.getLocalizedText(context.l10n, tag),
                        style: context.textStyles.bodySmallRegular.copyWith(
                          color: textColor,
                        ),
                      ),
                      const SizedBox(
                        width: Spacing.$1x,
                      ),
                      SvgPicture.asset(
                        AppFeedbackTagMapper.getIconByTag(tag),
                        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                        width: Spacing.$4x,
                        height: Spacing.$4x,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
