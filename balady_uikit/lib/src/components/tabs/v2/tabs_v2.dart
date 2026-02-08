part of 'package:balady_uikit/src/components/tabs/tabs.dart';

sealed class TabsV2IconBuilder {
  Widget build(BuildContext context, {required bool isSelected});
}

final class TabsV2IconData extends TabsV2IconBuilder {
  TabsV2IconData(this.icon);

  final IconData icon;

  @override
  Widget build(BuildContext context, {required bool isSelected}) {
    final colors = context.colors;
    return SizedBox(
      height: SizeConstraints.sizeIconChips,
      width: SizeConstraints.sizeIconChips,
      child: Icon(
        icon,
        color: isSelected ? colors.foregroundDefault : colors.foregroundSoft,
      ),
    );
  }
}

final class TabsV2WidgetBuilder extends TabsV2IconBuilder {
  TabsV2WidgetBuilder(this.widget);

  final Widget Function({required bool isSelected}) widget;

  @override
  Widget build(BuildContext context, {required bool isSelected}) => widget(isSelected: isSelected);
}

/// A [TabsV2] component for the [Landing Page] used in the Filters and the Action Bar layers.
///
/// A widget displaying a chip button with optional icon (leading or trailing),
/// title, and label. One of them should be provided. The widget supports
/// tap actions, styles (on white and on colorful background) and sizes (Small or Medium).
///
/// See also:
/// * [Figma Design](https://www.figma.com/file/owbsr9Pf0mQSEHXlbiPGOv/Balady-%E2%80%93-Components-Library?type=design&node-id=1957%3A3562&mode=design&t=KcMUcDVwzyowGdUB-1), design specs
class _TabsV2 extends StatelessWidget {
  final TabsV2IconBuilder? leadingIcon;
  final TabsV2IconBuilder? trailingIcon;

  /// Primary label text for the Chip.
  final String? title;

  final bool isSelected;
  final VoidCallback onTap;
  final Color? activeColor;
  final Color? dismissedColor;
  final Color? activeTextColor;
  final Color? dismissedTextColor;
  final TextStyle? textStyle;

  const _TabsV2({
    required this.onTap,
    this.leadingIcon,
    this.trailingIcon,
    this.title,
    this.isSelected = false,
    this.activeColor,
    this.dismissedColor,
    this.activeTextColor,
    this.dismissedTextColor,
    this.textStyle,
  }) : assert(
          title != null || leadingIcon != null || trailingIcon != null,
          'TabsV2 must have a title or label or an icon!',
        );

  @override
  Widget build(BuildContext context) {
    final _leadingIcon = leadingIcon;
    final _trailingIcon = trailingIcon;
    final colors = context.colors;

    final _title = title;
    final _activeColor = activeColor ?? colors.foregroundSegmentedControl;
    final _dismissedColor = dismissedColor ?? Colors.transparent;
    final _activeTextColor = activeTextColor ?? colors.foregroundDefault;
    final _dismissedTextColor = dismissedTextColor ?? colors.foregroundSoft;
    final _textStyle = textStyle ?? context.textStyles.bodySmallSemiBold;

    return ShapeShadow(
      shape: SmoothRectangleBorder(
        borderRadius: BorderRadius.circular(RadiusBorder.ml),
        smoothness: 0.6,
      ),
      boxShadow: isSelected ? Shadows.s : [],
      child: SmoothClipRRect(
        smoothness: 0.6,
        borderRadius: BorderRadius.circular(RadiusBorder.ml),
        child: ColoredBox(
          color: isSelected ? _activeColor : _dismissedColor,
          child: InkWell(
            splashFactory: NoSplash.splashFactory,
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Spacing.$2x,
                horizontal: Spacing.$4x,
              ),
              child: SizedBox(
                height: SizeConstraints.sizeIconChips,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_leadingIcon != null) _leadingIcon.build(context, isSelected: isSelected),
                    if (_title != null)
                      Text(
                        _title,
                        textHeightBehavior: TextHeightBehavior(
                          applyHeightToLastDescent: Directionality.of(context) == TextDirection.ltr,
                        ),
                        style: _textStyle.copyWith(
                          color: isSelected ? _activeTextColor : _dismissedTextColor,
                        ),
                      ),
                    if (_trailingIcon != null) _trailingIcon.build(context, isSelected: isSelected),
                  ].insertBetween(const SizedBox(width: Spacing.$1_5x)).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
