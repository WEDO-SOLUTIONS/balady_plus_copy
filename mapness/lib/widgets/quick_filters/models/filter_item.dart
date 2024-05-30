class FilterItem {
  FilterType filterType;
  final String? title;
  final String icon;
  final bool selected;
  void Function() onTap;

  FilterItem({
    required this.filterType,
    required this.icon,
    required this.onTap,
    this.title,
    this.selected = false,
  });
}

enum FilterType {
  custom,
  home,
  work,
  favourites,
  quick,
}
