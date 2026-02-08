import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/widgets/decorated_smooth_radius.dart';
import 'package:balady_uikit/src/components/chips/tools/colors.dart';
import 'package:balady_uikit/src/layouts/size_constraint.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:urbi_utils/urbi_utils.dart';

part 'widgets/chips_wrapper.dart';
part 'widgets/chips_icon.dart';
part 'widgets/chips_label.dart';

@Deprecated('Old Chips styling parameter. Use [ChipsType] now')
enum ChipsStyle {
  /// Use this style if [Chips] is on white background.
  whiteBackground,

  /// Use this style if [Chips] is not on white background.
  colorfulBackground,
}

@Deprecated('Old Chips parameter. Now it\'s useless')
enum ChipsSize {
  small,
  medium,
}

extension ChipsSizeExt on ChipsSize {
  double get verticalSpacing => switch (this) {
        ChipsSize.small => Spacing.$2x,
        ChipsSize.medium => Spacing.$3x,
      };

  double get verticalSize => switch (this) {
        ChipsSize.small => SizeConstraints.chipsRowVerticalSmall,
        ChipsSize.medium => SizeConstraints.chipsRowVerticalMedium,
      };

  double get radius => switch (this) {
        ChipsSize.small => RadiusBorder.ml,
        ChipsSize.medium => RadiusBorder.l,
      };

  TextStyle textStyle(BuildContext context) => switch (this) {
        ChipsSize.small => context.textStyle.footNoteBold,
        ChipsSize.medium => context.textStyle.callout,
      };
}

/// A [Chips] component for the [Landing Page] used in the Filters and the Action Bar layers.
///
/// A widget displaying a chip button with optional icon (leading or trailing),
/// title, and label. One of them should be provided. The widget supports
/// tap actions, styles (on white and on colorful background) and sizes (Small or Medium).
///
/// See also:
/// * [Figma Design](https://www.figma.com/file/owbsr9Pf0mQSEHXlbiPGOv/Balady-%E2%80%93-Components-Library?type=design&node-id=1957%3A3562&mode=design&t=KcMUcDVwzyowGdUB-1), design specs
class Chips extends StatefulWidget {
  /// Type of the chips that represents the background, foreground and default text colors
  final ChipsType type;

  /// If the chips is enabled or disabled
  /// If chips is disabled, the background and foreground colors will be different and the onPressed will not be called
  final bool isEnabled;

  /// If the chips is selected or not
  /// If chips is selected, the background  and foreground colors will be different
  final bool isSelected;

  /// The [onPressed] callback that will be called when the chips is pressed
  /// Will not be triggered if the user press in the trailing icon if it exists and the [onTrailingIconPressed] is not null
  final VoidCallback? onPressed;

  /// The options that will be displayed in the chips
  /// It contains the icon, label and the trailing icon
  /// The options can be [ChipsIconOptions] or [ChipsLabelOptions]
  ///
  /// [ChipsIconOptions] is used when the chips contains only an icon. It made like this to avoid the creation of
  /// a label with an empty string and a null trailing icon
  /// [ChipsLabelOptions] is used when the chips contains a label and a trailing icon. [labelFirst] is required.
  final ChipsOptions options;

  Chips({
    ChipsType? type,
    ChipsOptions? options,
    this.isEnabled = true,
    this.isSelected = false,
    void Function()? onPressed,
    @Deprecated('Old field. Use [onPressed] now') void Function()? onTap,
    @Deprecated('Old field. Use [options: ChipsLabelOptions] now') ChipsIconBuilder? leadingIcon,
    @Deprecated('Old field. Use [options: ChipsLabelOptions] now') ChipsIconBuilder? trailingIcon,
    @Deprecated('Old field. Use [options: ChipsLabelOptions] now') String? title,
    @Deprecated('Old field. Use [options: ChipsLabelOptions] now') String? label,
    @Deprecated('Old field. Use [type] now') ChipsStyle? style,
    @Deprecated('Old field. Not used anymore.') ChipsSize size = ChipsSize.small,
    super.key,
  })  

  /// TODO: Remove this after deleting deprecated fields.
  : onPressed = onTap ?? onPressed,
        assert(style != null || type != null, 'Type or Style should be provided!'),
        type = style != null ? (style == ChipsStyle.colorfulBackground ? ChipsType.map : ChipsType.neutral) : type!,
        options = title != null || label != null || leadingIcon != null || trailingIcon != null
            ? ChipsLabelOptions(
                labelFirst: title ?? '',
                labelSecond: label,
                leadingIcon: leadingIcon,
                trailingIcon: trailingIcon,
              )
            : options!;

  @override
  State<Chips> createState() => _ChipsState();
}

class _ChipsState extends State<Chips> {
  // The state of the chips if it is pressed or not
  // It will be used to change the background color of the chips when it is pressed
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final options = widget.options;
    final isCurrentlyPressed = (bool isPressed) {
      if (widget.isEnabled) {
        setState(() {
          this.isPressed = isPressed;
        });
      }
    };
    final colors = getChipsColors(
      type: widget.type,
      isSelected: widget.isSelected,
      colors: context.colors,
      isEnabled: widget.isEnabled,
      isPressed: isPressed,
    );
    return ChipsWrapper(
      type: widget.type,
      isSelected: widget.isSelected,
      backgroundColor: colors.background,
      child: switch (options) {
        ChipsIconOptions() => ChipsIconElement(
            icon: options.icon,
            iconColor: options.color ?? colors.foreground,
            type: widget.type,
            isSelected: widget.isSelected,
            isEnabled: widget.isEnabled,
            onPressed: widget.onPressed,
            isPressedNow: isCurrentlyPressed,
            defaultIconColor: colors.foreground,
          ),
        ChipsLabelOptions() => () {
            final options = widget.options as ChipsLabelOptions;
            final trialingIcon = options.trailingIcon;
            final onTrailingIconPressed = options.onTrailingIconPressed;
            final shouldShowTrailingWidget = onTrailingIconPressed != null && trialingIcon != null;

            if (shouldShowTrailingWidget) {
              return ChipsWithPressedTrailing(
                options: options,
                onTrailingIconPressed: onTrailingIconPressed,
                isPressedNow: isCurrentlyPressed,
                onPressed: widget.isEnabled ? widget.onPressed : null,
                foregroundColor: colors.foreground,
              );
            }
            return ChipsDefault(
              options: options,
              onPressed: widget.isEnabled ? widget.onPressed : null,
              isPressedNow: isCurrentlyPressed,
              foregroundColor: colors.foreground,
            );
          }()
      },
    );
  }
}
