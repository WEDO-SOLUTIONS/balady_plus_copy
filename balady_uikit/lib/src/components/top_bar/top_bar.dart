import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/src/components/top_bar/action_model.dart';
import 'package:balady_uikit/src/components/top_bar/common_text.dart';
import 'package:balady_uikit/src/layouts/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part 'action_item.dart';

/// The height of the Top Bar.
const double _topBarHeight = 40;

/// The width of the [leading] and [trailing] widget.
const double _defaultActionWidth = 112;

/// A [BaladyTopBar] is a Top Bar also known as [AppBar].
/// Has a [leading] and [trailing] widgets and [title].
/// The height of the Top Bar is 40.
/// Background color is transparent.
/// Leading width is constrained to 100.
///
/// Example:
/// ```dart
/// BaladyTopBar(
///   leading: Container(),
///   onLeadingPressed: () => print('Leading Pressed'),
///   trailing: Container(),
///   onTrailingPressed: () => print('Trailing Pressed'),
///   title: 'Title',
/// ),
/// ```
///
/// See also:
/// * [Figma]
/// https://www.figma.com/file/owbsr9Pf0mQSEHXlbiPGOv/Balady-%E2%80%93-Components-Library?type=design&node-id=2238%3A10446&mode=dev
class BaladyTopBar extends StatelessWidget implements PreferredSizeWidget {
  /// A [leading] widget. Has a constraint of 100 width and 40 height.
  final Widget? leading;

  /// A [onLeadingPressed] callback for the leading widget.
  final VoidCallback? onLeadingPressed;

  /// A [trailing] widget. Has a constraint of 40 height.
  final Widget? trailing;

  /// A [onTrailingPressed] callback for the trailing widget.
  final VoidCallback? onTrailingPressed;

  /// A [title] for the title of the Top Bar.
  /// If null the title will be set to an empty string.
  /// Text style is [text] with [textAndIconsBasePrimary] color.
  /// The title is centered.
  final String? title;
  final TextStyle? textStyle;
  final SystemUiOverlayStyle? systemUiOverlayStyle;
  final bool useSafeArea;

  /// Main constructor for the [BaladyTopBar].
  const BaladyTopBar({
    super.key,
    this.title,
    this.leading,
    this.onLeadingPressed,
    this.trailing,
    this.onTrailingPressed,
    this.textStyle,
    this.systemUiOverlayStyle,
    this.useSafeArea = true,
  });

  /// A factory constructor to create a [BaladyTopBar] with an icon and text.
  /// Has a [leadingIcon] and [leadingText] and [onLeadingPressed] for leading widget.
  /// Has a [trailingIcon] and [trailingText] and [onTrailingPressed] for trailing widget.
  /// Has a [title] for the title of the Top Bar.
  ///
  /// Example:
  /// ```dart
  /// BaladyTopBar.iconAndText(
  ///   leadingIcon: BaladyIcons.Back,
  ///   leadingText: 'Back',
  ///   onLeadingPressed: () => print('Leading Pressed'),
  ///   trailingIcon: BaladyIcons.Add,
  ///   trailingText: 'Add',
  ///   onTrailingPressed: () => print('Trailing Pressed'),
  ///   title: 'Title',
  /// ),
  /// ```
  ///
  /// See also:
  /// * [Figma]
  /// https://www.figma.com/file/owbsr9Pf0mQSEHXlbiPGOv/Balady-%E2%80%93-Components-Library?type=design&node-id=2238%3A10446&mode=dev
  factory BaladyTopBar.iconAndText({
    ActionModel? leading,
    ActionModel? trailing,
    String? title,
    Color? colorEnabled,
    Color? colorPressed,
    Color? colorDisabled,
    SystemUiOverlayStyle? systemUiOverlayStyle,
    TextStyle? textStyle,
    bool? useSafeArea,
    Key? key,
  }) {
    final leadingButton = leading != null
        ? ActionItem(
            action: leading,
            isEnabled: leading.isEnabled,
            colorEnabled: colorEnabled,
            colorPressed: colorPressed,
            colorDisabled: colorDisabled,
          )
        : null;
    final trailingButton = trailing != null
        ? SizedBox(
            height: _topBarHeight,
            width: _defaultActionWidth,
            child: ActionItem(
              isEnabled: trailing.isEnabled,
              colorEnabled: colorEnabled,
              colorPressed: colorPressed,
              colorDisabled: colorDisabled,
              action: trailing,
              reverseOrder: true,
            ),
          )
        : null;

    return BaladyTopBar(
      leading: leadingButton,
      trailing: trailingButton,
      title: title,
      systemUiOverlayStyle: systemUiOverlayStyle,
      textStyle: textStyle,
      useSafeArea: useSafeArea ?? true,
      key: key,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      primary: useSafeArea,
      systemOverlayStyle: systemUiOverlayStyle,
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: context.colors.foregroundDefault,
      leading: InkWell(
        onTap: onLeadingPressed,
        child: leading,
      ),
      leadingWidth: _defaultActionWidth,
      actions: trailing != null
          ? [
              InkWell(
                onTap: onTrailingPressed,
                child: trailing,
              ),
            ]
          : null,
      title: Text(
        title ?? '',
      ),
      centerTitle: true,
      titleTextStyle: textStyle ??
          context.textStyles.bodyLargeSemiBold.copyWith(
            color: context.colors.foregroundDefault,
          ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(_topBarHeight);
}
