class FilterItem {
  FilterItem({
    required this.filterType,
    required this.icon,
    required this.onTap,
    this.title,
    this.selected = false,
  });

  final String? title;
  final String icon;
  FilterType filterType;
  final bool selected;
  void Function() onTap;
}

enum FilterType {
  custom,
  home,
  work,
  favourites,
  quick,
}
