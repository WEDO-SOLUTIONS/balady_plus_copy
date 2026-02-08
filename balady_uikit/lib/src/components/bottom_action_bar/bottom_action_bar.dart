import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:urbi_utils/urbi_utils.dart';

/// The [BottomActionBar] class is used to create a customizable bottom navigation bar in Flutter applications.
/// The [items] parameter is a list of action bar items that represent the buttons displayed in the bottom navigation bar.
/// Each [ItemActionBar] represents an action bar item and requires a label, an onPressed callback function, and a color scheme.
/// Optionally, an icon can be provided to display alongside the label.
/// See also:
/// * [Figma Design](https://www.figma.com/file/owbsr9Pf0mQSEHXlbiPGOv/Balady-%E2%80%93-Components-Library?type=design&node-id=2413-515&mode=design&t=bzIa3J4BQZlMhSq0-0) for design specifications.
class BottomActionBar extends StatelessWidget {
  final List<ItemActionBar> items;
  final bool displayShadow;

  /// Creates a new instance of [BottomActionBar].
  ///
  /// The [items] parameter is a list of action bar items that represent the buttons displayed in the bottom navigation bar.
  ///
  /// The [items] list are required.
  const BottomActionBar({
    required this.items,
    this.displayShadow = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: context.colors.backgroundSurface1,
          boxShadow: displayShadow ? [Elevation.s] : [],
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: Spacing.$3x),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: Spacing.$10x + Spacing.$3x),
            child: Padding(
              padding: const EdgeInsets.only(top: Spacing.$3x),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
                children: (items as List<Widget>).insertBetween(Spacing.$2x.widthBox).toList(),
              ),
            ),
          ),
        ),
      );
}

/// Represents an action bar item displayed in the bottom navigation bar.
class ItemActionBar extends StatelessWidget {
  final String? label;
  final VoidCallback onPressed;
  final ButtonType buttonType;
  final IconData? icon;
  final EdgeInsetsGeometry? innerPadding;
  final ButtonColorScheme? colorScheme;

  /// Creates a new instance of [ItemActionBar].
  ///
  /// The [label] parameter specifies the text label displayed on the action bar item.
  /// The [onPressed] parameter is a callback function invoked when the action bar item is tapped.
  /// The [buttonType] parameter defines the color scheme of the action bar item.
  /// The [icon] parameter is an optional IconData used to display an icon alongside the label.
  ///
  /// All parameters are required.
  const ItemActionBar({
    required this.onPressed,
    required this.buttonType,
    this.label,
    this.icon,
    this.innerPadding,
    this.colorScheme,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => AppButton(
        padding: EdgeInsets.zero,
        primaryIcon: icon,
        primaryLabel: label,
        buttonType: buttonType,
        buttonColorScheme: colorScheme ?? ButtonColorScheme.accentSecondary,
        innerPadding: innerPadding,
        onTap: onPressed,
      );
}
