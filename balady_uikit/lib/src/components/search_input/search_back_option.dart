import 'package:balady_uikit/core/icons/system_icons.dart';
import 'package:balady_uikit/src/layouts/spacing.dart';
import 'package:flutter/widgets.dart';

sealed class SearchBackOption {
  final void Function() onPressed;

  const SearchBackOption({required this.onPressed});
}

class SearchTextBackOption extends SearchBackOption {
  final String text;
  final EdgeInsets padding;

  const SearchTextBackOption({
    required this.text,
    required void Function() onPressed,
    this.padding = const EdgeInsets.symmetric(vertical: Spacing.$3x),
  }) : super(onPressed: onPressed);
}

class SearchIconBackOption extends SearchBackOption {
  final IconData icon;

  const SearchIconBackOption({
    required void Function() onPressed,
    this.icon = SystemIcons.closeSmall,
  }) : super(onPressed: onPressed);
}
