import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/widget_label.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapness/entities/feedback/feedback_base_entity.dart';

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
          Row(
            children: [
              Flexible(
                child: WidgetLabel(
                  isRequired: field.isRequired,
                  label: field.label,
                  labelStyle: context.textStyleV3.captionMediumRegular.copyWith(
                    color: context.colorsV2.foregroundDefault,
                  ),
                ),
              ),
            ],
          ),
          FormBuilderField<int>(
            name: field.id,

            /// it require any string to mark field as error
            validator: (value) => !field.isRequired || value != null ? null : '',
            builder: (fieldState) => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: field.variants.map((variant) {
                final isSelected = fieldState.value == variant.id;
                return ChipsElement(
                  options: ChipsLabelOptions(
                    labelFirst: variant.label,
                    leadingIcon: variant.iconUrl == null
                        ? null
                        : ChipIconWidgetV2(
                            ({color}) => SvgPicture.network(
                              variant.iconUrl!,
                              colorFilter: ColorFilter.mode(
                                isSelected ? context.color.surfaceBasePrimary : context.color.textAndIconsBasePrimary,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                  ),
                  isSelected: isSelected,
                  onPressed: () => fieldState.didChange(isSelected ? null : variant.id),
                  type: isSelected ? ChipsType.accent : ChipsType.map,
                );
              }).toList(),
            ),
          ),
        ],
      );
}
