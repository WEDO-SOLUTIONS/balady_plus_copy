import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';
import 'package:mapness/widgets/feedback/feedback_label.dart';

class FeedbackChips extends StatelessWidget {
  final FeedbackChipsEntity field;
  final void Function(Set<int>) onValueChange;

  const FeedbackChips({
    required this.field,
    required this.onValueChange,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FeedbackLabel(text: field.label),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: field.variants
                .map(
                  (variant) => Chips(
                    title: variant.label,
                    isSelected: field.value?.contains(variant.id) ?? false,
                    leadingIcon: variant.iconUrl == null
                        ? null
                        : iconBuilder(
                            context: context,
                            iconUrl: variant.iconUrl!,
                          ),
                    onTap: () {
                      final Set<int> selected;
                      if (field.value?.contains(variant.id) ?? false) {
                        selected = {...?field.value}..remove(variant.id);
                      } else {
                        selected = {variant.id};
                      }
                      onValueChange(selected);
                    },
                    style: ChipsStyle.whiteBackground,
                  ),
                )
                .toList(),
          )
        ],
      );

  ChipIconWidget iconBuilder({
    required BuildContext context,
    required String iconUrl,
  }) =>
      ChipIconWidget(
        ({required isSelected}) => SvgPicture.network(
          iconUrl,
          colorFilter: ColorFilter.mode(
            isSelected ? context.color.textAndIconsStatusAccent : context.color.textAndIconsBasePrimary,
            BlendMode.srcIn,
          ),
        ),
      );
}
