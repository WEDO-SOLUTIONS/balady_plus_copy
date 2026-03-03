import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:balady_uikit/src/components/badge/utils/ext.dart';
import 'package:flutter/widgets.dart';
import 'package:urbi_utils/urbi_utils.dart';

/// A badge widget that informs about the state of an object or provides additional information.
///
/// The [BaladyBadge] can display a text and an optional icon, with support for primary and secondary
/// color schemes. It is highly customizable through the [badgeType] and [iconPosition] parameters.
///
/// ### Example Usage
/// ```dart
/// // Primary badge with an icon on the left
/// BaladyBadge.primary(
///   'Info',
///   badgeType: BadgeType.info,
///   iconPosition: BadgeIconPosition.left,
///   icon: Icons.info_outline,
/// );
///
/// // Secondary badge with an icon on the right
/// BaladyBadge.secondary(
///   'Warning',
///   badgeType: BadgeType.warning,
///   iconPosition: BadgeIconPosition.right,
///   icon: Icons.warning_amber_outlined,
/// );
/// ```
///
/// See also:
/// - [BadgeType], which defines the type of the badge (e.g., info, warning, error, success).
/// - [BadgeIconPosition], which defines the position of the icon relative to the text.
class BaladyBadge extends StatelessWidget {
  /// Creates a primary badge with a prominent color scheme.
  ///
  /// The primary color scheme is used to draw more attention to the badge.
  ///
  /// ### Parameters
  /// - [text]: The text to display on the badge.
  /// - [badgeType]: The type of the badge, which determines its color and style.
  /// - [iconPosition]: The position of the icon relative to the text.
  /// - [icon]: An optional icon to display on the badge.
  /// - [key]: An optional key for the widget.

  ///Primary color scheme
  ///Used for greater attention
  const BaladyBadge.primary(
    this.text, {
    required this.badgeType,
    required this.iconPosition,
    this.icon,
    super.key,
  })  : colorScheme = BadgeTypeColorScheme.primary,
        assert(
          ((iconPosition == BadgeIconPosition.start || iconPosition == BadgeIconPosition.end) && icon != null) ||
              iconPosition == BadgeIconPosition.none && icon == null,
          'Icon must be provided when iconPosition is start or end',
        );

  ///Secondary color scheme
  ///Used for less attention
  const BaladyBadge.secondary(
    this.text, {
    required this.badgeType,
    required this.iconPosition,
    super.key,
    this.icon,
  })  : colorScheme = BadgeTypeColorScheme.secondary,
        assert(
          ((iconPosition == BadgeIconPosition.start || iconPosition == BadgeIconPosition.end) && icon != null) ||
              iconPosition == BadgeIconPosition.none && icon == null,
          'Icon must be provided when iconPosition is start or end',
        );

  ///Tertiary color scheme
  ///Used for less attention
  const BaladyBadge.tertiary(
      this.text, {
        required this.badgeType,
        required this.iconPosition,
        super.key,
        this.icon,
      })  : colorScheme = BadgeTypeColorScheme.tertiary,
        assert(
        ((iconPosition == BadgeIconPosition.start || iconPosition == BadgeIconPosition.end) && icon != null) ||
            iconPosition == BadgeIconPosition.none && icon == null,
        'Icon must be provided when iconPosition is start or end',
        );

  final IconData? icon;
  final BadgeIconPosition iconPosition;
  final String text;
  final BadgeType badgeType;
  final BadgeTypeColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final textColor = badgeType.textColor(colorScheme, context);
    final isEnd = iconPosition == BadgeIconPosition.end;
    var children = <Widget>[
      if (icon != null) icon!.icon(size: 16, color: textColor),
      Text(
        text,
        textAlign: TextAlign.center,
        style: context.textStyles.bodySmallRegular.copyWith(color: textColor),
      ),
    ];
    if (isEnd) {
      children = children.reversed.toList();
    }
    return Container(
      height: Spacing.$6x,
      decoration: BoxDecoration(
          color: badgeType.backgroundColor(colorScheme, context),
          borderRadius: const BorderRadius.all(
            Radius.circular(RadiusBorder.s),
          )),
      padding: const EdgeInsets.symmetric(horizontal: Spacing.$1_5x),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: children.insertBetween(Spacing.$0_5x.widthBox).toList(),
      ),
    );
  }
}
