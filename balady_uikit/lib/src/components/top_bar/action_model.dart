import 'package:flutter/material.dart';

/// A [ActionModel] is a model for the [TopBar] action widgets.
/// This model is used to create the [ActionItem] widget.
@immutable
class ActionModel {
  /// The [icon] is the icon to be displayed in the [ActionItem] widget.
  final IconData? icon;

  /// Icon size is 24 by default.
  final double iconSize;

  /// The [text] is the text to be displayed in the [ActionItem] widget.
  final String? text;

  /// The [onPressed] is the callback to be called when the [ActionItem] widget is pressed.
  final VoidCallback? onPressed;

  /// The [isEnabled] is a boolean to enable or disable the [ActionItem] widget.
  final bool isEnabled;

  /// Main constructor for the [ActionModel] widget.
  const ActionModel({
    this.icon,
    this.text,
    this.onPressed,
    this.iconSize = 24,
    this.isEnabled = true,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActionModel &&
          runtimeType == other.runtimeType &&
          icon == other.icon &&
          iconSize == other.iconSize &&
          text == other.text &&
          onPressed == other.onPressed &&
          isEnabled == other.isEnabled;

  @override
  int get hashCode => icon.hashCode ^ iconSize.hashCode ^ text.hashCode ^ onPressed.hashCode ^ isEnabled.hashCode;

  @override
  String toString() =>
      'ActionModel(icon: $icon, iconSize: $iconSize, text: $text, onPressed: $onPressed, isEnabled: $isEnabled)';
}
