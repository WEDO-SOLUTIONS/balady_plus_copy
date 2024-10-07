import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';
import 'package:mapness/widgets/feedback/feedback_label.dart';

class FeedbackChips extends StatelessWidget {
  final FeedbackChipsEntity field;

  const FeedbackChips({
    required this.field,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FeedbackLabel(text: field.label),
          FormBuilderField<int>(
            name: field.id,

            /// it require any string to mark field as error
            validator: (value) => !field.isRequired || value != null ? null : '',
            builder: (fieldState) => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: field.variants
                  .map(
                    (variant) => Chips(
                      title: variant.label,
                      isSelected: fieldState.value == variant.id,
                      leadingIcon: variant.iconUrl == null
                          ? null
                          : iconBuilder(
                              context: context,
                              iconUrl: variant.iconUrl!,
                            ),
                      onTap: () => fieldState.didChange(fieldState.value == variant.id ? null : variant.id),
                      style: ChipsStyle.whiteBackground,
                    ),
                  )
                  .toList(),
            ),
          ),
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
