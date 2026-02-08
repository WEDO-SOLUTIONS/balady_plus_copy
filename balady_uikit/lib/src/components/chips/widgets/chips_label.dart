part of '../chips.dart';

class ChipsDefault extends StatelessWidget {
  final ChipsLabelOptions options;
  final Color? foregroundColor;
  // ignore: avoid_positional_boolean_parameters
  final void Function(bool isPressed) isPressedNow;
  final void Function()? onPressed;

  const ChipsDefault({
    required this.options,
    required this.isPressedNow,
    this.onPressed,
    this.foregroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final _labelFirst = options.labelFirst;
    final _labelSecond = options.labelSecond;

    final _leadingIcon = options.leadingIcon;
    final _trailingIcon = options.trailingIcon;

    final leadingIconColor = options.leadingIconColor ?? foregroundColor;
    final labelStyle = context.textStyles.bodySmallMedium;
    final firstLabelStyle = labelStyle.copyWith(color: options.labelFirstColor ?? foregroundColor);
    final secondLabelStyle = labelStyle.copyWith(color: options.labelSecondColor ?? foregroundColor);

    final trailingIconColor = options.trailingIconColor ?? foregroundColor;
    return InkWell(
      onTapDown: (_) => isPressedNow(true),
      onTapCancel: () => isPressedNow(false),
      onTapUp: (_) => isPressedNow(false),
      splashFactory: NoSplash.splashFactory,
      borderRadius: BorderRadius.circular(RadiusBorder.m),
      onTap: onPressed,
      child: Padding(
        padding: _getPadding(),
        child: SizedBox(
          height: AppSizes.m,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_leadingIcon != null) _leadingIcon.build(context, color: leadingIconColor),
              Text(_labelFirst, style: firstLabelStyle),
              if (_labelSecond != null) Text(_labelSecond, style: secondLabelStyle),
              if (_trailingIcon != null) _trailingIcon.build(context, color: trailingIconColor),
            ].insertBetween(const SizedBox(width: Spacing.$1_5x)).toList(),
          ),
        ),
      ),
    );
  }

  // left, right
  EdgeInsetsDirectional _getPadding() {
    double leading = Spacing.$2x;
    double trailing = Spacing.$2x;

    // If the label first (no leading icon), we add additional padding
    if (options.leadingIcon == null) {
      leading = Spacing.$4x;
    }
    // If the label last (no trailing icon), we add additional padding
    if (options.trailingIcon == null) {
      trailing = Spacing.$4x;
    }
    return EdgeInsetsDirectional.only(start: leading, end: trailing);
  }
}

/// The special chips that contains a trailing icon
/// This chips will have a different padding for the leading and trailing icon
/// It has been done to make sure that the trailing icon pressed area is bigger and contains the upper and lower paddings
/// Is has not been added to the default chips because it makes the layout logic more complex
class ChipsWithPressedTrailing extends StatelessWidget {
  final ChipsLabelOptions options;

  final VoidCallback onTrailingIconPressed;

  final Color foregroundColor;
  // ignore: avoid_positional_boolean_parameters
  final void Function(bool isPressed) isPressedNow;
  final void Function()? onPressed;

  const ChipsWithPressedTrailing({
    required this.options,
    required this.foregroundColor,
    required this.onTrailingIconPressed,
    required this.isPressedNow,
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final _labelFirst = options.labelFirst;
    final _labelSecond = options.labelSecond;

    final _leadingIcon = options.leadingIcon;
    final _trailingIcon = options.trailingIcon;
    if (_trailingIcon == null) {
      return const SizedBox.shrink();
    }

    final labelStyle = context.textStyles.bodySmallMedium;
    final firstLabelStyle = labelStyle.copyWith(color: options.labelFirstColor ?? foregroundColor);
    final secondLabelStyle = labelStyle.copyWith(color: options.labelSecondColor ?? foregroundColor);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTapDown: (_) => isPressedNow(true),
          onTapCancel: () => isPressedNow(false),
          onTapUp: (_) => isPressedNow(false),
          splashFactory: NoSplash.splashFactory,
          borderRadius: BorderRadius.circular(RadiusBorder.m),
          onTap: onPressed,
          child: Padding(
            padding: _getPaddingLeading(),
            child: SizedBox(
              height: AppSizes.m,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_leadingIcon != null)
                    _leadingIcon.build(context, color: options.leadingIconColor ?? foregroundColor),
                  Text(_labelFirst, style: firstLabelStyle),
                  if (_labelSecond != null) Text(_labelSecond, style: secondLabelStyle),
                ].insertBetween(const SizedBox(width: Spacing.$1_5x)).toList(),
              ),
            ),
          ),
        ),
        // We use CupertinoButton because we want to make opacity change when the user press the icon
        // @Dmitrii.Proshutinskii: I use it because it is robust and simple to use
        CupertinoButton(
          minSize: 0,
          padding: _getPaddingTrailing(),
          onPressed: onTrailingIconPressed,
          child: _trailingIcon.build(
            context,
            color: options.trailingIconColor ?? foregroundColor,
          ),
        )
      ],
    );
  }

  /// We have 2 options: with leading icon and leading text
  EdgeInsetsDirectional _getPaddingLeading() {
    // If we have leading icon
    if (options.leadingIcon != null) {
      return const EdgeInsetsDirectional.only(start: Spacing.$2x);
    }
    return const EdgeInsetsDirectional.only(start: Spacing.$4x);
  }

  /// We already know that we have label and trailing icon
  /// So we can calculate padding according to that information
  EdgeInsetsDirectional _getPaddingTrailing() {
    return const EdgeInsetsDirectional.only(
      top: (AppSizes.m - SizeConstraints.sizeIconChips) / 2,
      bottom: (AppSizes.m - SizeConstraints.sizeIconChips) / 2,
      start: Spacing.$1_5x,
      end: Spacing.$2x,
    );
  }
}
