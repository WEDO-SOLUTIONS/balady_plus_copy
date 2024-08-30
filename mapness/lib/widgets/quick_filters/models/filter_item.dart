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
  final String? icon;
  final VoidCallback onTap;

  FilterItemConfig({
    required super.filterType,
    required this.onTap,
    this.icon,
    this.title,
    super.selected = false,
  });
}

class FilterItemBuilder extends FilterItem {
  final Widget Function(
    BuildContext context, {
    required bool isSelected,
    required bool isDashboard,
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
