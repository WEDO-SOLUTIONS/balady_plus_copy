part of '../content_row.dart';

/// Options for the trailing widget in the ContentRow.
///
/// The trailing widget can be a toggle
class ContentRowTrailingToggle extends StatelessWidget {
  final EdgeInsetsDirectional? padding;
  final ContentRowToggleTrailingOptions options;

  const ContentRowTrailingToggle({
    required this.options,
    this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsetsDirectional.zero,
      child: Toggle(value: options.value, onChanged: options.onChanged),
    );
  }
}

/// Options for the trailing widget in the ContentRow.
///
/// The trailing widget can be a text or an icon.
class ContentRowTrailingText extends StatelessWidget {
  final EdgeInsetsDirectional? padding;
  final ContentRowTextTrailingOptions options;
  const ContentRowTrailingText({required this.options, super.key, this.padding});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: options.onPressed,
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Row(
          children: <Widget>[
            if (options.text != null)
              Text(
                options.text!,
                style: options.textStyle ??
                    context.textStyles.bodySmallSemiBold.copyWith(
                      color: context.colors.foregroundSoft,
                    ),
              ),
            if (options.icon != null)
              AppIcons(
                iconData: options.icon,
                color: options.iconColor ?? context.colors.foregroundDefault,
              ),
          ].insertBetween(Spacing.$1x.widthBox).toList(),
        ),
      ),
    );
  }
}
