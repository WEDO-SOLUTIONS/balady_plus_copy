part of '../chips.dart';

class ChipsIconElement extends StatelessWidget {
  /// Type of the chips that represents the background, foreground and default text colors
  final ChipsType type;

  /// If the chips is enabled or disabled
  /// If chips is disabled, the background color will be different and the onPressed will not be called
  final bool isEnabled;

  /// If the chips is selected or not
  /// If chips is selected, the background color will be different
  final bool isSelected;

  /// The [onPressed] callback that will be called when the chips is pressed
  /// Will not be triggered if the user press in the trailing icon if it exists and the [onTrailingIconPressed] is not null
  final VoidCallback? onPressed;

  /// The icon that will be displayed in the chips
  final ChipsIconBuilder icon;

  /// The color of the icon
  final Color? iconColor;

  /// Default foreground color
  final Color defaultIconColor;

  /// If the icon is pressed or not
  // ignore: avoid_positional_boolean_parameters
  final void Function(bool) isPressedNow;

  const ChipsIconElement({
    required this.type,
    required this.icon,
    required this.isPressedNow,
    required this.defaultIconColor,
    this.iconColor,
    this.isSelected = false,
    this.isEnabled = true,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTapDown: (_) => isPressedNow(true),
      onTapCancel: () => isPressedNow(false),
      onTapUp: (_) => isPressedNow(false),
      splashFactory: NoSplash.splashFactory,
      borderRadius: BorderRadius.circular(RadiusBorder.m),
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.$3x),
        child: SizedBox(
          height: AppSizes.m,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon.build(context, color: iconColor ?? defaultIconColor),
            ],
          ),
        ),
      ),
    );
  }
}
