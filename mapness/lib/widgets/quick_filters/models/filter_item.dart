import 'package:flutter/widgets.dart';

sealed class FilterItem {
  FilterType filterType;
  final bool selected;

  FilterItem({
    required this.filterType,
    this.selected = false,
  });
}

class FilterItemConfig extends FilterItem {
  final String? title;
  final IconData? icon;
  /// Spoken by screen readers when [title] is omitted (icon-only chip).
  final String? semanticsLabel;
  final VoidCallback onTap;

  FilterItemConfig({
    required super.filterType,
    required this.onTap,
    this.icon,
    this.title,
    this.semanticsLabel,
    super.selected = false,
  });
}

class FilterItemBuilder extends FilterItem {
  final Widget Function(
    BuildContext context, {
    required bool isSelected,
  }) builder;

  FilterItemBuilder({
    required this.builder,
    required super.filterType,
    super.selected = false,
  });
}

enum FilterType {
  custom,
  home,
  work,
  favourites,
  quick,
}
