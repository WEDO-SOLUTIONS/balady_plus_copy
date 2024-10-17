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
                      style: ChipsStyle.colorfulBackground,
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
